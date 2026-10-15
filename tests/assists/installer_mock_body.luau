local function fixture(prediction,studio)
    local state={writes=0,failRemaining=0,running=false}
    local function new(class,name,parent,source)
        local object=setmetatable({state=state,values={ClassName=class,Name=name or class,Source=source or ""},children={},attributes={}},mt)
        if parent then object.Parent=parent end
        return object
    end
    local root=new("Folder","DataModel")
    local services={}
    for _,name in ipairs({"ReplicatedStorage","ServerStorage","ServerScriptService","StarterPlayer"}) do services[name]=new("Folder",name,root) end
    services.RunService={IsRunning=function() return state.running end}
    local starter=new("Folder","StarterPlayerScripts",services.StarterPlayer)
    local package=new("Folder","NR2003Lab",services.ReplicatedStorage)
    local core=new("Folder","Core",package)
    local parents={core=core,cup=new("Folder","NR2003Cup",core),modules=new("Folder","Roblox",package),starter=starter,servers=services.ServerScriptService}
    for _,e in ipairs(ENTRIES) do
        local old=studio and e.studio or e.old
        if old~="" and (e.id~="prediction" or prediction) then new(e.class,e.name,parents[e.parent],old) end
    end
    local env=setmetatable({game={GetService=function(_,name) return assert(services[name],name) end},
        Instance={new=function(class) return new(class) end},print=function() end},{__index=getfenv()})
    return {root=root,parents=parents,state=state,storage=services.ServerStorage,env=env}
end
local function run(text,f)
    local chunk,reason=loadstring(text);assert(chunk,reason);setfenv(chunk,f.env);return pcall(chunk)
end
local function snapshot(object)
    local out={object.ClassName,object.Name,object.Source or ""}
    local keys={};for name in pairs(object.attributes) do keys[#keys+1]=name end;table.sort(keys)
    for _,name in ipairs(keys) do out[#out+1]=name.."="..tostring(object.attributes[name]) end
    if object.Value~=nil then out[#out+1]=type(object.Value)=="table" and ("reference="..object.Value.Name) or tostring(object.Value) end
    local children=object:GetChildren();table.sort(children,function(a,b) return a.Name<b.Name end)
    for _,child in ipairs(children) do out[#out+1]=snapshot(child) end
    return table.concat(out,"\0")
end
for _,studio in ipairs({false,true}) do
for _,prediction in ipairs({true,false}) do
    local f=fixture(prediction,studio);local before=snapshot(f.root)
    local ok,reason=run(APPLY,f)
    check("actual XML installer applies "..tostring(prediction),ok)
    for _,e in ipairs(ENTRIES) do
        if not ((e.id=="prediction" and not prediction) or (e.id=="legacy" and prediction)) then
            check("exact source installed "..e.name,f.parents[e.parent]:FindFirstChild(e.name).Source==e.source)
        end
    end
    local installed=snapshot(f.root);f.state.writes=0
    check("repeat install no-op "..tostring(prediction),run(APPLY,f) and f.state.writes==0 and snapshot(f.root)==installed)
    check("rollback restores full tree "..tostring(prediction),run(ROLLBACK,f) and snapshot(f.root)==before)
end
end
for _,name in ipairs({"NR2003CupDriver","CupChassisAdapter"}) do
    local f=fixture(true)
    local parent=name=="CupChassisAdapter" and f.parents.modules or f.parents.cup
    parent:FindFirstChild(name).Source..="\n-- user edit\n"
    local before=snapshot(f.root);f.state.writes=0
    local ok,reason=run(APPLY,f)
    check("unknown source refused before writes "..name,not ok and string.find(tostring(reason),"source differs",1,true) and f.state.writes==0 and snapshot(f.root)==before)
end
local failure=fixture(true);local before=snapshot(failure.root)
failure.state.failName="CupChassisAdapter";failure.state.failRemaining=1
local ok,reason=run(APPLY,failure)
check("injected write failure restores every source and addition",not ok and string.find(tostring(reason),"Injected Source",1,true) and snapshot(failure.root)==before)
local edited=fixture(true);assert(run(APPLY,edited));edited.parents.cup.NR2003CupAssists.Source..="\n-- edited\n"
before=snapshot(edited.root);edited.state.writes=0
ok,reason=run(ROLLBACK,edited)
check("rollback preserves post-install edits",not ok and string.find(tostring(reason),"rollback refused",1,true) and edited.state.writes==0 and snapshot(edited.root)==before)
local running=fixture(true);running.state.running=true;running.state.writes=0
check("Play mode install refused",not run(APPLY,running) and running.state.writes==0)
print(passed,"installer assertions passed")
