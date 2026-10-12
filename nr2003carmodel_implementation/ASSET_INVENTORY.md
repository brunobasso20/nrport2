# Inventário de assets e procedência — carro Cup original (make_a)

Gerado a partir de `manifest.json` do `pipeline/convert_car.py` (execução: `--series <NR2003>/series/cup --make 0 --livery cars/24_j_gordon.cup.car`). **Nenhum asset original está neste repositório**: OBJ / PNG / descritor ficam no pacote convertido entregue ao usuário (uso privado; © Papyrus / Sierra). Este arquivo só registra nomes, tamanhos e hashes para rastrear a procedência.

## Arquivos de origem

| arquivo | entradas | hash DAT | SHA-256 |
|---|---|---|---|
| `cup.dat` | 98 | `0b62ff9e` | `2c7607e690d5e0721014413ce891725f9bc6bfe4edd8559a9d0850dc37d2c470` |
| `cars/24_j_gordon.cup.car` | — | — | `473478e060b78fcab451c52f9b2c10e54b66fc73e9e5e8d993b8aa761b80d022` |

## Recursos usados (entradas do cup.dat)

| recurso | compactado (DCL) | bytes | SHA-256 | uso |
|---|---|---|---|---|
| `make_a.cam` | sim | 228 | `e93455afa4afa333…` | 6 câmeras on-car (MACC, modos 10..15) |
| `make_a.3do` | sim | 11142756 | `ea991100aecb022a…` | carro: carroceria (11 LODs), cockpit, piloto, rodas, 4 marcas (carMakeIdx) |
| `make_a_light_cockpit.3do` | sim | 10056 | `30d2c4c15f73ec45…` | instrumentos externos (convertido, não ligado) |
| `make_a_shadow.3do` | sim | 6126 | `0282a93b833820e0…` | sombra (convertido, não ligado) |
| `apillars.mip` | não | 87952 | `baa96a6f77240fce…` | textura |
| `backfire.mip` | não | 22320 | `eb77d0089d439882…` | textura |
| `bottom.mip` | não | 14852 | `4303069c92225805…` | textura |
| `card.mip` | não | 51852 | `0ec3f00b21567339…` | textura |
| `catch.mip` | não | 22364 | `105bac06fcbf9132…` | textura |
| `dash1.mip` | não | 175328 | `f1f933a07b37b4c5…` | textura |
| `dash2.mip` | não | 175328 | `38528311d1b713da…` | textura |
| `doors.mip` | não | 77740 | `ffe89be975f0d92d…` | textura |
| `fastgdyr_wc.mip` | não | 22364 | `8d38f685dd25d0b9…` | textura |
| `foam.mip` | não | 4180 | `77d8f7699abfdd07…` | textura |
| `glass.mip` | não | 87908 | `71df13abc80b5824…` | textura |
| `interior.mip` | não | 175328 | `73f62b704a0ec8b7…` | textura |
| `light_c.mip` | não | 76228 | `53922e67d3ba414b…` | textura |
| `mediumgdyr_wc.mip` | não | 22364 | `c6567c8acff0b828…` | textura |
| `netting.mip` | não | 3768 | `c51181e4264f69e4…` | textura |
| `netting2.mip` | não | 2860 | `b18b429acee30cb5…` | textura |
| `shifter.mip` | não | 16468 | `55c3a104ba09be65…` | textura |
| `slowgdyr_wc.mip` | não | 22364 | `c224db0474fc77ac…` | textura |
| `tach.mip` | não | 14596 | `fe8f1ee4d171d7a9…` | textura |
| `tach_night.mip` | não | 25188 | `9ffd19f60fae7304…` | textura |
| `tachlight.mip` | não | 21448 | `1d1bd54f0cc08c73…` | textura |
| `wheel2.mip` | não | 32852 | `54298acdf5c09f7b…` | textura |

## Pacotes convertidos

| pacote | geometrias únicas | instâncias | nós | triângulos únicos |
|---|---|---|---|---|
| `make_a` | 174 | 993 | 1361 | 16119 |
| `make_a_light_cockpit` | 10 | 16 | 30 | 18 |
| `make_a_shadow` | 4 | 4 | 6 | 148 |

## Texturas (nível maior de cada MIP, PNG RGBA)

| textura | formato | tamanho | clamp U/V | fator (cabeçalho MIP, não aplicado) | alfa = transparência |
|---|---|---|---|---|---|
| `apillars` | DXT1 | 512×256 | n/n | 0.7 | não |
| `backfire` | DXT3 | 128×128 | s/s | 4 | sim |
| `bottom` | DXT3 | 256×256 | s/s | 0.8 | sim |
| `card` | DXT3 | 512×512 | s/s | 0.8 | não |
| `catch` | DXT1 | 256×128 | s/s | 0.7 | sim |
| `dash1` | DXT1 | 512×512 | s/s | 4 | não |
| `dash2` | DXT1 | 512×512 | n/n | 4 | não |
| `doors` | DXT1 | 512×512 | s/s | 0.9 | não |
| `fastgdyr_wc` | DXT1 | 256×128 | s/s | 0.7 | não |
| `foam` | DXT1 | 64×128 | n/n | 0.7 | não |
| `glass` | DXT3 | 256×256 | n/n | 0.9 | sim |
| `interior` | DXT1 | 512×512 | s/s | 0.7 | sim |
| `light_c` | DXT3 | 512×256 | s/s | 4 | sim |
| `mediumgdyr_wc` | DXT1 | 256×128 | s/s | 0.7 | não |
| `netting` | DXT3 | 64×64 | n/n | 0.9 | sim |
| `netting2` | DXT1 | 128×64 | n/s | 0.9 | não |
| `shifter` | DXT1 | 256×128 | s/s | 0.7 | não |
| `slowgdyr_wc` | DXT1 | 256×128 | s/s | 0.7 | não |
| `tach` | DXT1 | 256×256 | s/s | 0.7 | não |
| `tach_night` | DXT3 | 256×256 | s/s | 0.7 | sim |
| `tachlight` | DXT3 | 256×256 | s/s | 0.7 | sim |
| `wheel2` | DXT1 | 256×256 | n/n | 0.7 | não |

`card` = a pintura em uso (aqui a do .car, sem alfa: janelas pintadas como no jogo); o `card.mip` genérico tem alfa 136
nas janelas (transparência sim) — é o caso de uma conversão sem `--livery`.

## Pintura

`24_j_gordon.cup.car` (CTEX, Jeff Gordon #24, Dupont Automotive Finishes) → `textures/livery_24_j_gordon.png` e, como o jogo faz para esse carro (CTEX substitui `card.mip`), também `textures/card.png` (o `card.mip` genérico fica em `card_default.png`). `--keep-card` mantém o genérico.

## Saída do conversor (pacote privado)

```
obj/make_a.glb                  biblioteca de geometria com texturas embutidas (RECOMENDADO para o 3D Importer)
obj/make_a.obj + .mtl           a mesma em OBJ (eixos Roblox, studs; 4 marcadores de calibração; PNG ao lado)
obj/make_a_light_cockpit.*, obj/make_a_shadow.*
textures/*.png                  23 texturas + pintura
luau/NR2003CarModelData_*.lua   descritor do rig (nós, switches, LODs, chaves, instâncias, câmeras)
json/*.json                     o mesmo descritor em JSON
studio/INSTALL_CARMODEL_ASSETS.lua, studio/NR2003CarModelData_make_a.rbxmx
manifest.json                   procedência (este inventário)
```

Licença: conteúdo original do NR2003 © Papyrus / Sierra. Convertido para uso privado do dono da cópia; não redistribuir. O código deste diretório (conversores, runtime, testes) não contém nenhum asset.
