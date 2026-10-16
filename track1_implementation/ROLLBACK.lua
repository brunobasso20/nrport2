-- Stop Play. Restore only the changes made by the track1 installer.
local Transaction=(function()
-- Scoped, persistent journal for track1 installation. Never saves or publishes.
local T={BACKUP="NR2003Backup_Track1"}
local Http=game:GetService("HttpService")
local function same(a,b,key)
    if key=="Source" and type(a)=="string" and type(b)=="string" then
        return a:gsub("\r\n","\n")==b:gsub("\r\n","\n")
    end
    return a==b
end
function T.new()
    local tx={ops={},created={},refs={},ids={}}
    function tx:id(value)
        if not self.ids[value] then self.refs[#self.refs+1]=value;self.ids[value]=#self.refs end
        return self.ids[value]
    end
    function tx:pack(value)
        local kind=typeof(value)
        if value==nil then return {"nil"} end
        if kind=="Instance" then return {"ref",self:id(value)} end
        if kind=="EnumItem" then return {"enum",tostring(value.EnumType):gsub("^Enum%.",""),value.Name} end
        if kind=="CFrame" then return {"CFrame",{value:GetComponents()}} end
        if kind=="Vector3" then return {"Vector3",value.X,value.Y,value.Z} end
        assert(kind=="string" or kind=="number" or kind=="boolean","Unsupported journal value "..kind)
        return {"value",value}
    end
    function tx:write(target,kind,key,value)
        local old
        if kind=="attribute" then old=target:GetAttribute(key) else old=target[key] end
        if same(old,value,key) then return end
        local entry={kind,self:id(target),key,self:pack(old),self:pack(value)}
        if kind=="attribute" then target:SetAttribute(key,value) else target[key]=value end
        self.ops[#self.ops+1]=entry
    end
    function tx:create(class,name,parent)
        local target=Instance.new(class);self:id(target)
        self.created[#self.created+1]={self:id(target),name,parent and self:id(parent) or false}
        target.Name=name;target.Parent=parent
        return target
    end
    function tx:unpack(value)
        local k=value[1]
        if k=="nil" then return nil end
        if k=="ref" then return self.refs[value[2]] end
        if k=="enum" then return Enum[value[2]][value[3]] end
        if k=="CFrame" then return CFrame.new(table.unpack(value[2])) end
        if k=="Vector3" then return Vector3.new(value[2],value[3],value[4]) end
        return value[2]
    end
    function tx:undo()
        for i=#self.ops,1,-1 do
            local op=self.ops[i];local target=self.refs[op[2]];local value=self:unpack(op[4])
            if op[1]=="attribute" then target:SetAttribute(op[3],value) else target[op[3]]=value end
        end
        for i=#self.created,1,-1 do self.refs[self.created[i][1]]:Destroy() end
    end
    function tx:commit()
        local storage=game:GetService("ServerStorage")
        assert(not storage:FindFirstChild(T.BACKUP),"track1 backup already exists")
        -- Encode before constructing persistent state: failed encoding remains reversible.
        local encoded=Http:JSONEncode({ops=self.ops,created=self.created})
        local backup=Instance.new("Folder");backup.Name=T.BACKUP
        local ok,reason=pcall(function()
            local refs=Instance.new("Folder");refs.Name="Targets";refs.Parent=backup
            for id,target in ipairs(self.refs) do
                local ref=Instance.new("ObjectValue");ref.Name=tostring(id);ref.Value=target;ref.Parent=refs
            end
            local journal=Instance.new("StringValue");journal.Name="Journal";journal.Value=encoded;journal.Parent=backup
            backup:SetAttribute("Track1PatchVersion",1);backup.Parent=storage
        end)
        if not ok then backup:Destroy();error(reason) end
        return backup
    end
    return tx
end
function T.rollback()
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before rolling back track1")
    local backup=assert(game:GetService("ServerStorage"):FindFirstChild(T.BACKUP),"track1 backup not found")
    local data=Http:JSONDecode(backup.Journal.Value)
    local tx=T.new();tx.ops=data.ops;tx.created=data.created
    for _,ref in ipairs(backup.Targets:GetChildren()) do tx.refs[tonumber(ref.Name)]=ref.Value end
    local final={};local owned={}
    for _,entry in ipairs(tx.created) do owned[entry[1]]=true end
    -- Validate the final value for every field before restoring any field.
    for i=#tx.ops,1,-1 do
        local op=tx.ops[i];local key=op[2]..":"..op[1]..":"..op[3]
        if not final[key] then
            local target=assert(tx.refs[op[2]],"track1 rollback: target was removed")
            local actual
            if op[1]=="attribute" then actual=target:GetAttribute(op[3]) else actual=target[op[3]] end
            assert(same(actual,tx:unpack(op[5]),op[3]),
                "track1 rollback refused: changed after installation: "..target:GetFullName().."."..op[3])
            final[key]=true
        end
    end
    for _,entry in ipairs(tx.created) do
        local target=assert(tx.refs[entry[1]],"track1 rollback: created target was removed")
        assert(target.Name==entry[2],"track1 rollback: created object was renamed")
        local expected=entry[3] and tx.refs[entry[3]] or nil
        assert(target.Parent==expected,"track1 rollback: created object was moved")
        for _,child in ipairs(target:GetChildren()) do
            local id=table.find(tx.refs,child)
            assert(id and (owned[id] or final[id..":property:Parent"]),
                "track1 rollback refused: new child in "..target:GetFullName())
        end
    end
    tx:undo();backup:Destroy()
    print("track1 rolled back; previous sources, surfaces, active track and respawn marker restored")
    return true
end
return T

end)()
Transaction.rollback()
