-- FIX_CARMODEL_MATERIALS — corrige a transparência do carro ORIGINAL já instalado (NR2003Lab.CarModel.Assets), sem
-- reconverter nem reimportar. Cole na Command Bar, FORA do Play. NÃO salva o place.
-- NR2003 desenha o alfa da textura como transparência (para-brisa "buildup" quase todo transparente, vidros das janelas,
-- redes, luzes do painel, backfire, recortes do interior). Um import (ex.: GLB exportado pelo Blender com materiais
-- OPAQUE) deixa a SurfaceAppearance em AlphaMode Overlay: o vidro vira uma placa cinza. Este script põe AlphaMode =
-- Transparency onde o alfa é transparência (Overlay nas demais) e informa como as texturas foram importadas.
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local folder=assert(RS:FindFirstChild("NR2003Lab") and RS.NR2003Lab:FindFirstChild("CarModel"),"NR2003Lab.CarModel ausente")
local data=assert(folder:FindFirstChild("Data"),"CarModel.Data ausente")
local assets=assert(folder:FindFirstChild("Assets"),"CarModel.Assets ausente")
local DEFAULT_BLEND={backfire=true,bottom=true,card=true,catch=true,glass=true,interior=true,light_c=true,
    netting=true,tach_night=true,tachlight=true}
local function applyMaterials(model,desc)
    local st={parts=0,surface=0,textureId=0,none=0,blend=0,alphaFixed=0,created=0,errors=0}
    for _,g in ipairs(desc.geometries) do
        local p=model:FindFirstChild(g.name,true)
        if p and p:IsA("BasePart") then
            st.parts+=1
            local blend
            if g.alpha~=nil then blend=(g.alpha=="blend") else blend=DEFAULT_BLEND[g.texture]==true end
            if blend then st.blend+=1 end
            local sa=p:FindFirstChildOfClass("SurfaceAppearance")
            if sa then
                st.surface+=1
                local want=blend and Enum.AlphaMode.Transparency or Enum.AlphaMode.Overlay
                if sa.AlphaMode~=want then
                    if pcall(function() sa.AlphaMode=want end) then st.alphaFixed+=1 else st.errors+=1 end
                end
            elseif p:IsA("MeshPart") and p.TextureID~="" then
                st.textureId+=1
                if blend then
                    local ok=pcall(function()
                        local n=Instance.new("SurfaceAppearance");n.ColorMap=p.TextureID
                        n.AlphaMode=Enum.AlphaMode.Transparency;n.Parent=p
                    end)
                    if ok then st.created+=1 else st.errors+=1 end
                end
            else st.none+=1 end
        end
    end
    return st
end
local function reportMaterials(st)
    print(string.format("Materiais: %d peças | textura em SurfaceAppearance %d, em TextureID %d, SEM textura %d | %d transparentes (alfa = transparência), %d AlphaMode corrigidos, %d SurfaceAppearance criadas, %d erros",
        st.parts,st.surface,st.textureId,st.none,st.blend,st.alphaFixed,st.created,st.errors))
    if st.none>0 then
        warn(st.none.." peças importadas sem textura: reimporte obj/make_a.glb (texturas embutidas) pelo 3D Importer; se continuar, confira se as imagens passaram pela moderação do Roblox (Asset Manager > Images)")
    end
end
local done=0
for _,m in ipairs(data:GetChildren()) do
    if m:IsA("ModuleScript") and m.Name:match("^NR2003CarModelData_") then
        local desc=require(m)
        local model=desc.meta and assets:FindFirstChild(desc.meta.package)
        if model then
            print("Pacote "..desc.meta.package..":");reportMaterials(applyMaterials(model,desc));done+=1
        end
    end
end
assert(done>0,"nenhum modelo instalado encontrado (rode INSTALL_CARMODEL_ASSETS antes)")
print("Pronto. Dê Play: os vidros e o para-brisa ficam transparentes como no NR2003. O place NÃO foi salvo.")
