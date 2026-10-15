local Setup=require('../../../core/NR2003Cup/NR2003CupSetup')(require('../../../core/NR2003Cup/NR2003CupSetupData'))
local Setups=require('../../../roblox/NR2003WatkinsGlenSetup')
local original=require('./setup_load_fixtures')
local count=0
for _,name in ipairs({'fast','easy','qualify','jasper'}) do
    local s,chosen,hash=Setups.new(Setup,name)
    assert(chosen==name and #hash==64)
    for i,want in pairs(original[name]) do
        assert(s[i]==want,string.format('%s item %d got %08x original %08x',name,i,s[i],want))
        count+=1
    end
    for _,i in ipairs({137,138,139,140,149,150,151,152}) do assert(s[i]==0,'stale bench internal setting retained') end
end
assert(select(2,Setups.new(Setup))=='fast')
assert(not pcall(Setups.new,Setup,'unknown'))
print(string.format('Original setup file load: %d input fields bit-exact; four profiles, default selection, invalid-name rejection and cleared internals passed',count))
