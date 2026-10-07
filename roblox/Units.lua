local M={}; M.__index=M
function M.new(tune,root) return setmetatable({m=tune.metresPerStud,massKg=tune.mass,root=root},M) end
function M:studs(metres) return metres/self.m end
function M:metres(studs) return studs*self.m end
function M:force(newtons) return newtons*(self.root.AssemblyMass/self.massKg/self.m) end
function M:torque(newtonMetres) return newtonMetres*(self.root.AssemblyMass/self.massKg/(self.m*self.m)) end
return M
