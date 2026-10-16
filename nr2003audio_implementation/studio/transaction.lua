-- Scoped, persistent journal for audio installation. Never saves or publishes.
local T={BACKUP="NR2003Backup_Audio",VERSION="1.0.0",CHUNK_BYTES=150000}
local Http=game:GetService("HttpService")
local function writeJournal(backup,encoded)
    local journal=Instance.new("Folder");journal.Name="Journal";journal.Parent=backup
    local first,count=1,0
    while first<=#encoded do
        local last=math.min(first+T.CHUNK_BYTES-1,#encoded)
        -- A property must receive valid UTF-8 even when a boundary crosses a
        -- non-ASCII name or a source comment. Keep the whole code point together.
        if last<#encoded then
            local byte=encoded:byte(last+1)
            while byte and byte>=128 and byte<=191 do last-=1;byte=encoded:byte(last+1) end
        end
        count+=1
        local part=Instance.new("StringValue");part.Name=string.format("Part%05d",count)
        part.Value=encoded:sub(first,last);part.Parent=journal
        first=last+1
    end
    journal:SetAttribute("ChunkCount",count)
    journal:SetAttribute("ByteLength",#encoded)
    backup:SetAttribute("JournalFormat",2)
    backup:SetAttribute("AudioInstallerVersion",T.VERSION)
end
function T.readJournal(backup)
    local journal=assert(backup:FindFirstChild("Journal"),"audio backup journal missing")
    -- Preserve rollback compatibility with successfully installed v1 backups.
    if journal:IsA("StringValue") then return Http:JSONDecode(journal.Value) end
    assert(journal:IsA("Folder"),"audio backup journal has an unexpected class")
    local count=journal:GetAttribute("ChunkCount")
    assert(type(count)=="number" and count>0 and count==math.floor(count)
        and count==#journal:GetChildren(),"audio backup journal chunk count mismatch")
    local parts={}
    for i=1,count do
        local part=journal:FindFirstChild(string.format("Part%05d",i))
        assert(part and part:IsA("StringValue"),"audio backup journal chunk missing: "..i)
        parts[i]=part.Value
    end
    local encoded=table.concat(parts)
    assert(#encoded==journal:GetAttribute("ByteLength"),"audio backup journal byte length mismatch")
    return Http:JSONDecode(encoded)
end
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
        assert(not storage:FindFirstChild(T.BACKUP),"audio backup already exists")
        -- Encode before constructing persistent state: failed encoding remains reversible.
        local encoded=Http:JSONEncode({ops=self.ops,created=self.created})
        local backup=Instance.new("Folder");backup.Name=T.BACKUP
        local ok,reason=pcall(function()
            local refs=Instance.new("Folder");refs.Name="Targets";refs.Parent=backup
            for id,target in ipairs(self.refs) do
                local ref=Instance.new("ObjectValue");ref.Name=tostring(id);ref.Value=target;ref.Parent=refs
            end
            writeJournal(backup,encoded)
            backup:SetAttribute("AudioPatchVersion",1);backup.Parent=storage
        end)
        if not ok then backup:Destroy();error(reason) end
        return backup
    end
    return tx
end
function T.rollback()
    assert(not game:GetService("RunService"):IsRunning(),"Stop Play before rolling back audio")
    local backup=assert(game:GetService("ServerStorage"):FindFirstChild(T.BACKUP),"audio backup not found")
    local data=T.readJournal(backup)
    local tx=T.new();tx.ops=data.ops;tx.created=data.created
    for _,ref in ipairs(backup.Targets:GetChildren()) do tx.refs[tonumber(ref.Name)]=ref.Value end
    local final={};local owned={}
    for _,entry in ipairs(tx.created) do owned[entry[1]]=true end
    -- Validate the final value for every field before restoring any field.
    for i=#tx.ops,1,-1 do
        local op=tx.ops[i];local key=op[2]..":"..op[1]..":"..op[3]
        if not final[key] then
            local target=assert(tx.refs[op[2]],"audio rollback: target was removed")
            local actual
            if op[1]=="attribute" then actual=target:GetAttribute(op[3]) else actual=target[op[3]] end
            assert(same(actual,tx:unpack(op[5]),op[3]),
                "audio rollback refused: changed after installation: "..target:GetFullName().."."..op[3])
            final[key]=true
        end
    end
    for _,entry in ipairs(tx.created) do
        local target=assert(tx.refs[entry[1]],"audio rollback: created target was removed")
        assert(target.Name==entry[2],"audio rollback: created object was renamed")
        local expected=entry[3] and tx.refs[entry[3]] or nil
        assert(target.Parent==expected,"audio rollback: created object was moved")
        for _,child in ipairs(target:GetChildren()) do
            local id=table.find(tx.refs,child)
            assert(id and (owned[id] or final[id..":property:Parent"]),
                "audio rollback refused: new child in "..target:GetFullName())
        end
    end
    tx:undo();backup:Destroy()
    print("audio rolled back; previous scripts and audio settings restored")
    return true
end
return T
