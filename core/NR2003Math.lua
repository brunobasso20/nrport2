-- Numeric cells of the 005b7xxx/005b8xxx expression engine, row-major matrices.
-- Each primitive corresponds to a stored float cell, not arbitrary Lua arithmetic.
local F = require(script and script.Parent.Float32 or "Float32")
local M = {f=F.round}
local f=F.round
function M.copy(a) local b={} for i=1,#a do b[i]=a[i] end return b end
function M.zero(n) local a={} for i=1,n do a[i]=0 end return a end
function M.eye(n) local a=M.zero(n*n) for i=1,n do a[(i-1)*n+i]=1 end return a end
function M.add(a,b) local c={} for i=1,#a do c[i]=f(a[i]+b[i]) end return c end
function M.sub(a,b) local c={} for i=1,#a do c[i]=f(a[i]-b[i]) end return c end
function M.scale(a,s) local c={} for i=1,#a do c[i]=f(a[i]*s) end return c end
function M.dot(a,b) local s=0 for i=1,#a do s=f(s+f(a[i]*b[i])) end return s end
function M.transpose(a,rows,cols)
    local b={} for i=1,rows do for j=1,cols do b[(j-1)*rows+i]=a[(i-1)*cols+j] end end return b
end
function M.mul(a,b,rows,inner,cols)
    local c={} for i=1,rows do for j=1,cols do
        local s=0 for k=1,inner do s=f(s+f(a[(i-1)*inner+k]*b[(k-1)*cols+j])) end
        c[(i-1)*cols+j]=s
    end end return c
end
function M.mv(a,b,n) return M.mul(a,b,n,#b,1) end
function M.slice(a,start,n) local b={} for i=1,n do b[i]=a[start+i-1] end return b end
function M.join(a,b) local c=M.copy(a) for _,x in ipairs(b) do c[#c+1]=x end return c end
function M.cross(a,b)
    return {f(f(a[2]*b[3])-f(a[3]*b[2])),f(f(a[3]*b[1])-f(a[1]*b[3])),f(f(a[1]*b[2])-f(a[2]*b[1]))}
end
function M.skew(a) return {0,-a[3],a[2],a[3],0,-a[1],-a[2],a[1],0} end
function M.wrap(a)
    local pi=f(math.pi); local tau=f(2*pi)
    while a>=pi do a=f(a-tau) end while a < -pi do a=f(a+tau) end return a
end
function M.axisRotation(axis,angle)
    local c,s=f(math.cos(angle)),f(math.sin(angle))
    if axis==1 then return {1,0,0,0,c,-s,0,s,c}
    elseif axis==2 then return {c,0,s,0,1,0,-s,0,c}
    else return {c,-s,0,s,c,0,0,0,1} end
end
function M.quatMultiply(a,b)
    local av,bv=M.slice(a,1,3),M.slice(b,1,3)
    return M.join(M.add(M.add(M.scale(bv,a[4]),M.scale(av,b[4])),M.cross(av,bv)),
        {f(f(a[4]*b[4])-M.dot(av,bv))})
end
function M.normalizeQuaternion(q)
    local n=M.dot(q,q); assert(n>0 and n<math.huge,"Invalid quaternion")
    return M.scale(q,f(1/f(math.sqrt(n))))
end
function M.quatRotation(q)
    local x,y,z,w=q[1],q[2],q[3],q[4]
    local w2,x2,y2,z2=f(2*w),f(2*x),f(2*y),f(2*z)
    local wx,wy,wz,ww=f(w2*x),f(w2*y),f(w2*z),f(w2*w)
    local xx,xy,xz,yy,yz,zz=f(x2*x),f(x2*y),f(x2*z),f(y2*y),f(y2*z),f(z2*z)
    return {f(f(ww+xx)-1),f(xy-wz),f(xz+wy),f(xy+wz),f(f(ww+yy)-1),f(yz-wx),
        f(xz-wy),f(yz+wx),f(f(ww+zz)-1)}
end
function M.finite(x) return type(x)=="number" and x==x and math.abs(x)<math.huge end
function M.vector(a,n,label)
    assert(type(a)=="table" and #a==n,(label or "vector")..": wrong size")
    for i=1,n do assert(M.finite(a[i]),(label or "vector")..": non-finite value") end
    return a
end
return M
