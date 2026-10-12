"""Studio installer for one converted package (written by convert_car.py next to the converted files).

INSTALL_CARMODEL_ASSETS.lua puts the rig descriptor (NR2003CarModelData_<package>) in NR2003Lab.CarModel.Data and the
model imported with the Studio 3D Importer (<package>.obj) in NR2003Lab.CarModel.Assets.<package>, after checking the
calibration markers and that every geometry of the descriptor exists in the import. It contains data derived from the
user's own NR2003 files: private use only, never part of the repository. Never saves the place; keeps what it replaces
in ServerStorage.NR2003Backup_CarModelAssets."""
import json
from xml.sax.saxutils import escape


def long_string(text):
    eq = "="
    while ("]" + eq + "]") in text:
        eq += "="
    return "[" + eq + "[\n" + text + "]" + eq + "]"


def fnv(s):
    h = 0x811c9dc5
    for b in s.encode("utf-8"):
        h = ((h ^ b) * 0x01000193) & 0xffffffff
    return h


def assets_installer(desc, data_name, data_source):
    pkg = desc["meta"]["package"]
    names = [g["name"] for g in desc["geometries"]]
    transparent = {g["name"]: round(1 - g["opacity"], 4) for g in desc["geometries"] if g["opacity"] < 1}
    head = r'''-- INSTALL_CARMODEL_ASSETS — pacote __PKG__ (gerado pelo convert_car.py a partir dos SEUS arquivos do NR2003:
-- uso privado, não distribua). Cole na Command Bar do Studio, FORA do Play, depois de INSTALL_CARMODEL.lua e de importar
-- __PKG__.obj pelo 3D Importer (File > Import 3D; unidade Stud; o importador pode mover / escalar à vontade: os 4
-- marcadores NR2003_MARKER_* medem a transformação). Selecione o modelo importado (ou deixe-o no Workspace com o nome
-- __PKG__) e rode este script. NÃO salva o place.
--   * cria/atualiza NR2003Lab.CarModel.Data.__DATA__ (descritor do rig)
--   * move o modelo importado para NR2003Lab.CarModel.Assets.__PKG__ (o anterior vai para ServerStorage.NR2003Backup_CarModelAssets)
--   * peças: Anchored, sem colisão / consulta / toque; transparência = 1 - opacidade do material 3do (vidros)
--   * _G.NR2003_LIVERY_TEXTURE = "rbxassetid://..." (opcional): atributo NR2003LiveryTexture no TestCar
assert(not game:GetService("RunService"):IsRunning(),"Pare o Play antes")
local RS=game:GetService("ReplicatedStorage")
local storage=game:GetService("ServerStorage")
local SES=game:GetService("ScriptEditorService")
local Selection=game:GetService("Selection")
local PKG,DATA="__PKG__","__DATA__"
local pkg=assert(RS:FindFirstChild("NR2003Lab"),"NR2003Lab ausente")
local folder=assert(pkg:FindFirstChild("CarModel"),"NR2003Lab.CarModel ausente: rode INSTALL_CARMODEL.lua antes")
local dataF=folder:FindFirstChild("Data") or Instance.new("Folder",folder);dataF.Name="Data"
local assetsF=folder:FindFirstChild("Assets") or Instance.new("Folder",folder);assetsF.Name="Assets"
local NAMES=__NAMES__
local TRANSPARENT=__TRANSPARENT__
local MARKERS={"NR2003_MARKER_O","NR2003_MARKER_X","NR2003_MARKER_Y","NR2003_MARKER_Z"}
-- 1) find the imported model
local src=_G.NR2003_CARMODEL_IMPORT
if src==nil then
    local sel=Selection:Get()
    if #sel==1 and (sel[1]:IsA("Model") or sel[1]:IsA("Folder")) then src=sel[1] end
end
if src==nil then src=workspace:FindFirstChild(PKG) end
local existing=assetsF:FindFirstChild(PKG)
if src==nil then src=existing end
assert(src,"modelo importado não encontrado: selecione o Model criado pelo 3D Importer ("..PKG..".obj) e rode de novo")
local missing,parts={},0
for _,m in ipairs(MARKERS) do
    local p=src:FindFirstChild(m,true)
    assert(p and p:IsA("BasePart"),"marcador "..m.." ausente: importe o .obj inteiro (os marcadores calibram escala e eixos)")
end
for _,n in ipairs(NAMES) do
    local p=src:FindFirstChild(n,true)
    if p==nil or not p:IsA("BasePart") then table.insert(missing,n) else parts+=1 end
end
assert(#missing==0,#missing.." geometrias do descritor ausentes no modelo importado (primeira: "..tostring(missing[1])..")")
-- 2) descriptor module
local DATA_SOURCE=__SOURCE__
local backup=storage:FindFirstChild("NR2003Backup_CarModelAssets")
if not backup then backup=Instance.new("Folder");backup.Name="NR2003Backup_CarModelAssets";backup.Parent=storage end
local old=dataF:FindFirstChild(DATA)
if old and old.Source~=DATA_SOURCE then local c=old:Clone();c.Name=DATA.."_"..os.time();c.Parent=backup end
local m=old or Instance.new("ModuleScript")
m.Name=DATA
SES:UpdateSourceAsync(m,function() return DATA_SOURCE end)
m.Parent=dataF
assert(#m.Source==__LEN__,"descritor truncado")
-- 3) imported model -> Assets
if existing and existing~=src then existing.Name=PKG.."_"..os.time();existing.Parent=backup end
src.Name=PKG
for _,d in ipairs(src:GetDescendants()) do
    if d:IsA("BasePart") then
        d.Anchored=true;d.CanCollide=false;d.CanQuery=false;d.CanTouch=false;d.CastShadow=true
        local t=TRANSPARENT[d.Name]
        if t then d.Transparency=t end
    end
end
src.Parent=assetsF
-- 4) optional livery
local car=workspace:FindFirstChild("TestCar",true)
if _G.NR2003_LIVERY_TEXTURE and car then car:SetAttribute("NR2003LiveryTexture",_G.NR2003_LIVERY_TEXTURE) end
-- 5) self-test (code + descriptor + imported model)
local ok,lines=require(folder.NR2003CarModelSelfTest).run(true)
print(string.format("Pacote %s instalado: %d geometrias, descritor %d caracteres. Auto-teste: %s",PKG,parts,#m.Source,ok and "OK" or "FALHOU"))
print("Dê Play e entre no carro: V/B troca câmera (cockpit, Roll Bar, F10, Chase, Nose...), Z/C olha, [ ] muda o FOV.")
print("O place NÃO foi salvo. Para desfazer: apague CarModel.Data."..DATA.." e CarModel.Assets."..PKG.." (ou ROLLBACK_CARMODEL.lua).")
'''
    body = (head.replace("__PKG__", pkg).replace("__DATA__", data_name)
            .replace("__NAMES__", "{" + ",".join(json.dumps(n) for n in names) + "}")
            .replace("__TRANSPARENT__", "{" + ",".join("[%s]=%r" % (json.dumps(k), v) for k, v in transparent.items()) + "}")
            .replace("__LEN__", str(len(data_source.encode("utf-8")))))
    return body.replace("__SOURCE__", long_string(data_source))


def rbxmx_module(name, source):
    return ("<?xml version='1.0' encoding='utf-8'?>\n<roblox version=\"4\">\n  <External>null</External>\n"
            "  <Item class=\"ModuleScript\" referent=\"RBX_DATA\">\n    <Properties>\n"
            "      <string name=\"Name\">%s</string>\n"
            "      <ProtectedString name=\"Source\">%s</ProtectedString>\n"
            "    </Properties>\n  </Item>\n</roblox>\n" % (escape(name), escape(source)))
