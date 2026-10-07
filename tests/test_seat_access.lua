-- Real admission logic, with a minimal seat/event double (not Studio Play).
local fixture=dofile("tests/test_geometry.lua")
local I=fixture.Instance;local car=fixture.car;local seat=car.DriverSeat
local checks=0;local clock=0
local function check(value,label) checks=checks+1;assert(value,label) end
local function signal()
    local s={connections={}}
    function s:Connect(fn) local c={connected=true};function c:Disconnect() self.connected=false end
        self.connections[#self.connections+1]={c=c,fn=fn};return c end
    function s:Fire(...) for _,v in ipairs(self.connections) do if v.c.connected then v.fn(...) end end end
    return s
end
local players=I.new("Players");players.PlayerRemoving=signal()
local changed=signal();seat.EnterCar.Triggered=signal()
function seat:GetPropertyChangedSignal()return changed end
function car.Chassis:SetNetworkOwner()end
function I:FindFirstChildOfClass(class)for _,c in ipairs(self:GetChildren())do if c.ClassName==class then return c end end end
local function player(id)
    local p=I.new("Player");p.UserId=id;p.Parent=players
    local character=I.new("Model");character.Parent=workspace;p.Character=character
    local h=I.new("Humanoid");h.Health=100;h.Parent=character
    local root=I.new("Part");root.Name="HumanoidRootPart";root.CFrame=seat.CFrame;root.Parent=character
    return p,h,root
end
local driver,h,hrp=player(42);local other=player(43)
function players:GetPlayerFromCharacter(character)for _,p in ipairs(self:GetChildren())do if p.Character==character then return p end end end
local messages={};local remote={FireClient=function(_,p,data)messages[#messages+1]={player=p,data=data}end}
local attempts=0;local allowSit=false
function seat:Sit(humanoid)
    attempts=attempts+1
    if allowSit then self.Occupant=humanoid;humanoid.SeatPart=self;humanoid.Sit=true;changed:Fire() end
end
local env=setmetatable({script={Parent=fixture.packageRoot.Roblox},require=fixture.require,
    game={GetService=function(_,name)assert(name=="Players");return players end},os={clock=function()return clock end}},{__index=_G})
local Access=assert(loadfile("roblox/SeatAccess.lua","t",env))()
seat.DriverSeatMount.Name="SeatWeld"
local avatar=I.new("Weld");avatar.Name="SeatWeld";avatar.Part0=seat;avatar.Part1=hrp;avatar.Parent=seat
local access=Access.new(car,remote)
check(seat.DriverSeatMount~=nil and avatar.Name=="SeatWeld","migrate only permanent mount")
check(access:request(driver) and attempts==1,"Sit requested")
check(car:GetAttribute("DriverUserId")==0,"pending is not authority")
access:request(driver);check(attempts==1,"duplicate input limited")
allowSit=true;clock=.36;access:step()
check(attempts==2 and access:driver()==driver,"retry confirms occupant")
check(car:GetAttribute("DriverUserId")==42 and not seat.EnterCar.Enabled,"confirmed driver")
clock=1;access:request(other);check(messages[#messages].data.code=="occupied","occupied rejected")
access:exit(other);check(h.Sit,"other player cannot eject driver")
access:exit(driver);check(not h.Sit and h.Jump,"exit")
seat.Occupant=nil;h.SeatPart=nil;changed:Fire()
clock=2;hrp.Position=seat.Position+Vector3.new(100,0,0);access:request(driver)
check(messages[#messages].data.code=="distance","distant request rejected")
hrp.CFrame=seat.CFrame;car.Chassis.Anchored=true;clock=3;access:request(driver)
check(messages[#messages].data.code=="anchored","accidental anchoring diagnosed")
car.Chassis.Anchored=false;allowSit=false;clock=4;access:request(driver)
clock=8;access:step();check(messages[#messages].data.code=="timeout" and seat.EnterCar.Enabled,"timeout restores prompt")
clock=9;access:request(driver);driver.Character=other.Character;access:step()
check(messages[#messages].data.code=="cancelled","respawn cancels entry")
access:destroy();check(car:GetAttribute("EntryHandlerReady")==false,"cleanup")
print("PASS: "..checks.." seat admission checks")
