# nr2003carmodel_implementation — carro Cup ORIGINAL do NR2003 no Roblox (modelo, cockpit, instrumentos, volante, câmeras)

Etapa entre o Stage 13 e o Stage 14. **O Stage 14 não foi iniciado.** Física, cadeia de direção, FFB e todos os estágios
1–13: **inalterados** (nenhum arquivo do repositório fora deste diretório foi modificado; regressão completa em
`CARMODEL_VALIDATION.md`). **Dano: fora do escopo** — exporta-se o carro sem dano; nenhum código de dano foi tocado.

Relatórios: implementação `CARMODEL_RESULT.md` · validação + checklist do Studio `CARMODEL_VALIDATION.md` · recuperação
(Ghidra, endereços, formatos) `recovery/CARMODEL_RECOVERY.md` · hierarquia / transformações `CARMODEL_HIERARCHY.md` ·
inventário / procedência `ASSET_INVENTORY.md`.

## Estrutura

```
pipeline/                      conversão dos arquivos ORIGINAIS (Python 3, numpy só no preview)
  convert_car.py               cup.dat (+ .car) -> OBJ/MTL + PNG + descritor (Luau/JSON) + instalador de assets + manifest
  nr2003res/                   dat.py dcl.py (DAT + PKWARE DCL), obj3do.py (3do), mip.py (MIP/DXT), car.py (CARF/CTEX),
                               scene.py (grafo -> rig), export.py, scale.py, rig.py (rig de referência), studio.py
  preview.py                   renderizador por software (validação visual das câmeras / cockpit / pintura)
  hierarchy_report.py          mapa da hierarquia (CARMODEL_HIERARCHY.md)
roblox/CarModel/               módulos do runtime (ReplicatedStorage.NR2003Lab.CarModel)
  NR2003Scale                  ÚNICA conversão unidade/eixos NR2003 <-> Roblox (0,28 m/stud) — também para as pistas futuras
  NR2003Gauges                 agulhas 0056f040 / 0056edd0 e luzes de aviso de 005662d0
  NR2003DrawState              registro de desenho original (células 0x1508..0x15b0) + interpolação 005ba170
  NR2003CameraSystem           câmeras originais (0056a9a0, 00569450, 005697e0, 00568e20, opção de FOV, projeção)
  NR2003CarModelRig            grafo 3do no Roblox (switches 10011ec0, LOD 100118e0, animação 10012810, overrides 005662d0)
  NR2003CarModelClient         apresentação no cliente (rig + câmera), NR2003CarModelServer (envio do registro)
  NR2003CarModelSelfTest       auto-teste no Studio; NR2003CarModelGolden (vetores do código original)
roblox/Bench/                  NR2003Client / NR2003Server do Stage 13 + ganchos opcionais do modelo (instalados pelo INSTALL)
studio/                        INSTALL_CARMODEL.lua, ROLLBACK_CARMODEL.lua, NR2003_CarModel_Install.rbxmx
recovery/                      orig_carmodel.py (código ORIGINAL no Unicorn), gen_fixtures.py, CARMODEL_RECOVERY.md,
                               evidence/ (descompilação + asm de 261 funções do NR2003.exe / rendserv.dll), ghidra/
tests/                         carmodel_body.luau (+ make_carmodel_tests.py), install_mock_body.luau (+ make_install_mock.py),
                               fixtures_carmodel.lua (vetores do código original), RESULTS_CARMODEL.txt
tools/build_carmodel.py        gera studio/* a partir das fontes; tools/make_changed_zip.py gera o ZIP de arquivos alterados
```

Nenhum asset original (malha, textura, descritor do modelo) está no repositório: o pacote convertido é gerado a partir da
SUA cópia do NR2003 e fica fora do git (uso privado).

## Uso

### 1. Converter (no PC, fora do Roblox)

```
python3 -I pipeline/convert_car.py --series "<NR2003>/series/cup" --out <saida> --make 0 \
        --livery "<NR2003>/series/cup/cars/24_j_gordon.cup.car"
```

`--make` = carMakeIdx (0 Chevrolet, 1 Dodge, 2 Ford, 3 Pontiac; o `car_make` do .car). Com `--livery` a pintura (CTEX)
substitui `card.png` como o jogo faz (`--keep-card` mantém a genérica). Saída: `obj/make_a.obj + .mtl`, `textures/*.png`,
`luau/`, `json/`, `studio/INSTALL_CARMODEL_ASSETS.lua`, `manifest.json`. Opcional: `python3 -I pipeline/preview.py --pkg
<saida> --png views.png` (cockpit, Roll Bar, F10, Nose, externa).

### 2. Instalar no Studio (place do Stage 13, FORA do Play; nada é salvo automaticamente)

1. **Command Bar**: cole `studio/INSTALL_CARMODEL.lua` (ou Insert from File de `studio/NR2003_CarModel_Install.rbxmx` e
   `require(workspace.NR2003_CarModel_Install)()`). Confere NR2003Stage = 13 e NR2003Client / NR2003Server byte a byte
   (hash do Stage 13 publicado), faz backup em `ServerStorage.NR2003Backup_CarModel`, cria `NR2003Lab.CarModel` e
   `NR2003Lab.DrawState`, atualiza os dois scripts no lugar, roda o auto-teste e reverte sozinho se algo falhar.
2. **File > Import 3D** → `<saida>/obj/make_a.obj` (com o .mtl e as texturas na mesma pasta). Unidade: Stud; não
   reescale (se reescalar, os marcadores medem e compensam). O modelo importado fica no Workspace.
3. Selecione o modelo importado e cole `<saida>/studio/INSTALL_CARMODEL_ASSETS.lua` na Command Bar: instala o descritor
   em `CarModel.Data`, move o modelo para `CarModel.Assets.make_a` e roda o auto-teste completo (marcadores, todas as
   174 geometrias, rodas = cubos da física).
4. Salve o place você mesmo depois de conferir. Reverter tudo: `studio/ROLLBACK_CARMODEL.lua` (os scripts voltam ao
   Stage 13 publicado; a pasta CarModel vai para `ServerStorage.NR2003CarModel_Removido`).

Sem o passo 3 a apresentação continua como no Stage 13 (os ganchos só agem com o modelo instalado; o servidor apenas
passa a enviar o registro de desenho, 188 bytes por snapshot).

### 3. Dirigir

| Tecla | Ação (controle original) |
|---|---|
| V / B (gamepad L3) | próxima / anterior câmera (0x56 / 0x57): cockpit → Roll Bar → F10Near → F10Far → Nose → cockpit |
| Z / C (gamepad: analógico direito) | olhar esquerda / direita (0x54 / 0x55; 45° em 0,1 s) |
| [ / ] | FOV do cockpit −1° / +1° (0x6e / 0x6d; 65..78°) |

Atributos do `TestCar` (opcionais): `NR2003CockpitFOV` (65..78, padrão 65), `NR2003WidescreenProjection` (padrão true:
ramo widescreen do jogo, cockpit em 65°), `NR2003AnimatedSteeringWheel` (true), `NR2003Windshield` (true),
`NR2003CameraShift` (true: inclinação que aproxima o deslocamento de frustum −0,125), `NR2003LiveryTexture`
(`rbxassetid://…`, troca a pintura em tempo real), `NR2003CarModelData` (nome do descritor). Saída: `NR2003Camera`,
`NR2003CarModelStatus`.

### 4. Testes (Luau CLI)

```
python3 tools/build_carmodel.py
python3 tests/make_carmodel_tests.py <saida>      && luau -O2 tests/carmodel_run.luau      # 47 checks (sem <saida>: 34, sem o rig / cliente)
python3 tests/make_install_mock.py <saida>         && luau -O2 tests/install_mock.luau      # 14 checks (sem <saida>: 11)
NR2003_MEM=… RENDSERV_MEM=… python3 recovery/gen_fixtures.py <saida> tests/fixtures_carmodel.lua   # regenera os vetores
```

(caminhos relativos a este diretório; os arquivos gerados com `<saida>` contêm dados do modelo e ficam fora do git.)
