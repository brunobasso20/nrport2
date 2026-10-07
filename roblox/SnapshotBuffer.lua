-- Client presentation buffer. Uses workspace:GetServerTimeNow() timestamps on both ends,
-- adaptive interpolation delay, shortest-path quaternion interpolation and bounded extrapolation.
local Snap=require(script and script.Parent.RenderSnapshot or "RenderSnapshot")
local M={};M.__index=M
local DEFAULT={capacity=64,initialDelay=0.09,minDelay=0.055,maxDelay=0.18,maxExtrapolation=0.075,
    staleAfter=0.75,delaySlewPerSecond=0.05,latencyFastGain=0.20,latencySlowGain=0.015,
    intervalGain=0.10,jitterGain=0.08,intervalSafety=1.50,jitterSafety=2.50,maxSpinRate=2000}
local function clamp(v,a,b) if v<a then return a elseif v>b then return b end return v end
local function lerp(a,b,t) return a+(b-a)*t end
local function copyConfig(config)
    local c={};for k,v in pairs(DEFAULT) do c[k]=v end;for k,v in pairs(config or {}) do c[k]=v end;return c
end
function M.new(config)
    local self=setmetatable({cfg=copyConfig(config),scratch={x=0,y=0,z=0,w=1}},M);self:reset();return self
end
function M:reset()
    self.list={};self.delay=self.cfg.initialDelay;self.targetDelay=self.delay
    self.latency=nil;self.jitter=0.004;self.interval=1/60;self.lastSnapshotTime=nil
    self.lastArrival=nil;self.lastSeq=nil;self.lastLocal=nil;self.renderTime=nil;self.inExtrap=false
    self.window={start=nil,count=0,firstTick=nil,firstTime=nil,recvHz=0,tickHz=0}
    self.st={received=0,dropped=0,outOfOrder=0,duplicates=0,tooOld=0,rejected=0,
        extrapFrames=0,extrapEpisodes=0,maxExtrapSeen=0,underruns=0,resets=0}
end
function M:count() return #self.list end
function M:isStale(now) return self.lastArrival==nil or now-self.lastArrival>self.cfg.staleAfter or #self.list<2 end
local function updateWindow(self,s,now)
    local w=self.window
    if not w.start then w.start,w.count,w.firstTick,w.firstTime=now,0,s.tick,s.time end
    w.count=w.count+1
    local elapsed=now-w.start
    if elapsed>=1 then
        w.recvHz=w.count/elapsed
        local simElapsed=s.time-w.firstTime
        if simElapsed>0 then w.tickHz=((s.tick-w.firstTick)%4294967296)/simElapsed end
        w.start,w.count,w.firstTick,w.firstTime=now,0,s.tick,s.time
    end
end
local function clearPlayback(self,keepStats)
    local old=self.st
    self.list={};self.lastSeq=nil;self.lastSnapshotTime=nil;self.lastArrival=nil;self.lastLocal=nil;self.renderTime=nil
    self.latency=nil;self.jitter=0.004;self.interval=1/60;self.delay=self.cfg.initialDelay;self.targetDelay=self.delay
    self.inExtrap=false;self.window={start=nil,count=0,firstTick=nil,firstTime=nil,recvHz=0,tickHz=0}
    if keepStats then old.resets=old.resets+1 else self:reset() end
end
function M:push(s,now)
    if not (Snap.finite(s.time) and Snap.finite(now)) then self.st.rejected=self.st.rejected+1;return false,"time" end
    if Snap.hasFlag(s.flags,Snap.FLAG_TELEPORT) then clearPlayback(self,true) end
    local list=self.list;local st=self.st;local n=#list
    if n>0 and s.time<=list[n].time then
        if s.time==list[n].time then st.duplicates=st.duplicates+1;return false,"duplicate" end
        if s.time<list[1].time then st.tooOld=st.tooOld+1;return false,"too old" end
        local pos=n;while pos>=1 and list[pos].time>s.time do pos=pos-1 end
        if pos>=1 and list[pos].time==s.time then st.duplicates=st.duplicates+1;return false,"duplicate" end
        table.insert(list,pos+1,s);st.outOfOrder=st.outOfOrder+1;st.received=st.received+1;self.lastArrival=now
        if st.dropped>0 then st.dropped=st.dropped-1 end
        return true,"reordered"
    end
    local seqGap=1
    if self.lastSeq then
        local gap=(s.seq-self.lastSeq)%65536
        if gap>0 and gap<32768 then seqGap=gap end
        if gap>1 and gap<32768 then st.dropped=st.dropped+gap-1 end
    end
    self.lastSeq=s.seq;list[n+1]=s;st.received=st.received+1;self.lastArrival=now
    while #list>self.cfg.capacity do table.remove(list,1) end
    local sample=math.max(0,now-s.time)
    if self.latency==nil then self.latency=sample
    else
        local gain=sample<self.latency and self.cfg.latencyFastGain or self.cfg.latencySlowGain
        self.latency=self.latency+(sample-self.latency)*gain
    end
    local deviation=math.abs(sample-self.latency)
    self.jitter=self.jitter+(deviation-self.jitter)*self.cfg.jitterGain
    if self.lastSnapshotTime then
        local d=s.time-self.lastSnapshotTime
        if d>0 and d<0.5 then
            local nominal=d/math.max(1,seqGap)
            self.interval=self.interval+(nominal-self.interval)*self.cfg.intervalGain
        end
    end
    self.lastSnapshotTime=s.time
    self.targetDelay=clamp((self.latency or 0)+self.interval*self.cfg.intervalSafety+self.jitter*self.cfg.jitterSafety,
        self.cfg.minDelay,self.cfg.maxDelay)
    updateWindow(self,s,now)
    return true
end
function M:advance(now)
    if #self.list<2 then return nil end
    local dt=self.lastLocal and math.max(0,now-self.lastLocal) or 0
    local maxChange=self.cfg.delaySlewPerSecond*dt
    self.delay=self.delay+clamp(self.targetDelay-self.delay,-maxChange,maxChange)
    local t=now-self.delay
    if self.renderTime and t<self.renderTime then t=self.renderTime end
    self.renderTime=t;self.lastLocal=now;return t
end
local function copyBody(a,out)
    out.px,out.py,out.pz=a.px,a.py,a.pz;out.qx,out.qy,out.qz,out.qw=a.qx,a.qy,a.qz,a.qw
    out.lx,out.ly,out.lz=a.lx,a.ly,a.lz;out.ax,out.ay,out.az=a.ax,a.ay,a.az;out.steer=a.steer
end
local function copyWheels(a,out,mode,b,t,extra,previous,maxSpinRate)
    for j=1,#a.wheels do
        local o=out.wheels[j];if not o then o={};out.wheels[j]=o end;local aw=a.wheels[j]
        if mode=="interp" then
            local bw=b.wheels[j];o.comp=lerp(aw.comp,bw.comp,t);o.steer=lerp(aw.steer,bw.steer,t);o.spin=lerp(aw.spin,bw.spin,t)
            o.cx=lerp(aw.cx,bw.cx,t);o.cy=lerp(aw.cy,bw.cy,t);o.cz=lerp(aw.cz,bw.cz,t);o.grounded=t<0.5 and aw.grounded or bw.grounded
        else
            o.comp,o.steer,o.spin=aw.comp,aw.steer,aw.spin;o.cx,o.cy,o.cz=aw.cx,aw.cy,aw.cz;o.grounded=aw.grounded
            if mode=="extrap" and previous then
                local span=a.time-previous.time
                if span>0 then o.spin=aw.spin+clamp((aw.spin-previous.wheels[j].spin)/span,-maxSpinRate,maxSpinRate)*extra end
            end
        end
    end
end
function M:sample(t,out)
    local list=self.list;local n=#list;if n==0 then return nil end
    out=out or {};out.wheels=out.wheels or {};local first,last=list[1],list[n]
    local mode,alpha,extra="interp",0,0
    if n==1 or t<=first.time then
        copyBody(first,out);copyWheels(first,out,"hold");out.tick=first.tick;mode="clamp"
        if t<first.time then self.st.underruns=self.st.underruns+1 end
    elseif t>=last.time then
        local needed=t-last.time;alpha=1;extra=math.min(needed,self.cfg.maxExtrapolation)
        copyBody(last,out)
        if needed>0 then
            mode=needed<=self.cfg.maxExtrapolation and "extrap" or "clamp"
            out.px=last.px+last.lx*extra;out.py=last.py+last.ly*extra;out.pz=last.pz+last.lz*extra
            local q=Snap.integrate(last.qx,last.qy,last.qz,last.qw,last.ax,last.ay,last.az,extra,self.scratch)
            out.qx,out.qy,out.qz,out.qw=q.x,q.y,q.z,q.w
            copyWheels(last,out,"extrap",nil,nil,extra,list[n-1],self.cfg.maxSpinRate)
            self.st.extrapFrames=self.st.extrapFrames+1
            if not self.inExtrap then self.st.extrapEpisodes=self.st.extrapEpisodes+1 end
            if needed>self.st.maxExtrapSeen then self.st.maxExtrapSeen=needed end
            self.inExtrap=true
        else copyWheels(last,out,"hold");self.inExtrap=false end
        out.tick=last.tick
    else
        local i=n-1;while i>1 and list[i].time>t do i=i-1 end
        local a,b=list[i],list[i+1];alpha=(t-a.time)/(b.time-a.time)
        out.px=lerp(a.px,b.px,alpha);out.py=lerp(a.py,b.py,alpha);out.pz=lerp(a.pz,b.pz,alpha)
        local q=Snap.slerp(a.qx,a.qy,a.qz,a.qw,b.qx,b.qy,b.qz,b.qw,alpha,self.scratch)
        out.qx,out.qy,out.qz,out.qw=q.x,q.y,q.z,q.w
        out.lx=lerp(a.lx,b.lx,alpha);out.ly=lerp(a.ly,b.ly,alpha);out.lz=lerp(a.lz,b.lz,alpha)
        out.ax=lerp(a.ax,b.ax,alpha);out.ay=lerp(a.ay,b.ay,alpha);out.az=lerp(a.az,b.az,alpha);out.steer=lerp(a.steer,b.steer,alpha)
        copyWheels(a,out,"interp",b,alpha);out.tick=a.tick;self.inExtrap=false
    end
    out.alpha,out.mode,out.extrapolated,out.time=alpha,mode,extra,t;return out
end
function M:stats()
    local s={};for k,v in pairs(self.st) do s[k]=v end
    s.buffer=#self.list;s.delay=self.delay;s.targetDelay=self.targetDelay;s.latency=self.latency or 0;s.jitter=self.jitter
    s.recvHz=self.window.recvHz;s.serverTickHz=self.window.tickHz;s.serverSnapshotHz=self.interval>0 and 1/self.interval or 0
    return s
end
return M
