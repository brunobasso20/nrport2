# Mapa de recuperação — nr2003carmodel (carro Cup original: modelo, cockpit, instrumentos, volante, câmeras)

Base: Stage 13 publicado (3.12.0-stage13). Etapa de apresentação entre o Stage 13 e o Stage 14 (Stage 14 não iniciado);
**física inalterada**, nada é escrito no núcleo. Tudo em `nr2003carmodel_implementation/`: relatórios **`README.md`**,
**`CARMODEL_RESULT.md`**, **`CARMODEL_VALIDATION.md`**, **`recovery/CARMODEL_RECOVERY.md`** (endereços, formatos),
`CARMODEL_HIERARCHY.md`, `ASSET_INVENTORY.md`; evidências `recovery/evidence/` (NR2003.exe 237 funções, rendserv.dll 24);
harness do código original `recovery/orig_carmodel.py`. Dano: fora do escopo (carro sem dano).

| Original | Port | Estado |
|---|---|---|
| `cup.dat` (DAT + DCL), `make_a.3do` (objetos tipados), `*.mip` (DXT1/3), `.car` (CTEX), `make_a.cam` (MACC) | `pipeline/nr2003res` (leitura completa, erro em classe desconhecida) → OBJ/PNG/descritor | conversão; assets fora do git |
| rendserv `10011ec0` StateSwitch, `100118e0` LodSwitch (+ piso de detalhe), `10012810` AnimatedTransform | `NR2003CarModelRig` (+ `pipeline/nr2003res/rig.py`) | EXACT vs original (91 / 202 / 276 vetores) |
| `005f6f20` Euler, `005f74c0` decomposição | `NR2003Scale.euler` / `decompose` | ≤ 1 ulp f32 vs original |
| `00551990` células 0x1508..0x15b4, `00565880` coleta, `005ba170` interpolação | `NR2003DrawState` (servidor lê, cliente interpola) | regras campo a campo; leitura do núcleo validada |
| `005662d0` desenho: variáveis, rodas, volante (±2,79), câmbio, cabeça, `00565b10` wheel_speed | `NR2003CarModelClient` + `NR2003CarModelRig.localCF` | EXACT (wheel_speed 41/41); rig = referência a 1e−14 |
| `0056edd0` / `0056f040` agulhas, luzes de aviso | `NR2003Gauges` | EXACT (276 valores, 0 ulp) |
| `0056a9a0` câmera (14 modos), `00567e10` tabelas, `.cam`, `00411530/50` ordem, `00568e20`, `00569450`, `005697e0`, opção de FOV `00411850/60`, `00567a80/ab0` | `NR2003CameraSystem` | EXACT vs original (168 poses: olho 1,5e−5 m, rotação 4e−7, FOV 6e−9) |
| `00587e70` / rendserv `100043a0` projeção (FOV 4:3 horizontal, Hor+, ramo widescreen `00587ea2`, deslocamento (0, −0,125)) | `NR2003Scale.verticalFov`, `NR2003CarModelClient.applyCamera` | exato exceto o deslocamento (aproximado por inclinação) |
| escala / eixos (0,28 m/stud, (x, y, z) → (−y, z, −x)) | `NR2003Scale` (compartilhado com as pistas futuras) | = `TestTune` / `CupTune`; rodas = cubos da física a 5e−5 m |
| `0056a9a0` câmera de espelho (2º argumento; base `006f5f0c`, FOV 120°, near 0,3) + portal `rearView` | `NR2003CameraSystem.computeMirror` + `NR2003Mirror` (ViewportFrame, mundo refletido) | câmera EXACT vs original (60 poses); projeção no portal aproximada |
| alfa da textura base = transparência (janelas, para-brisa buildup, redes, luzes) | conversor (`g.alpha`, GLB BLEND) + instaladores (SurfaceAppearance AlphaMode) | por evidência dos dados; estado de blend do rendserv não rastreado |
| câmeras de fora com órbita (mouse / analógico) | `NR2003CameraSystem:applyOrbit` | extensão NÃO original (pedido); sem entrada = original |
| Noite / SelfLighting, câmeras de pista, LOD da opção de detalhe, `make_a_light_cockpit`, sombra, controle 3 | — | não portados (motivos em `CARMODEL_RESULT.md`) |

# Mapa de recuperação — Stage 13 (torque de direção / force feedback)

Base: Stage 12.1 (3.11.1-stage12.1). Imagem do executável: projeto Ghidra do OpenNR2003 (`TChapman500/OpenNR2003`)
exportado por `recovery/ghidra_tools/ExportMemoryPy.py`. Evidências: `recovery/stage13/` (listagens `evidence/dis/`, prova
sem realimentação `evidence/nofeedback.txt`, harness `orig_stage13.py`, cenários `scenarios13.py`, fixtures
`gen_units13.py` / `gen_fixtures13.py`). Relatórios: **`STAGE13_RECOVERY.md`**, **`STAGE13_FFB_STATE_MAP.md`**,
**`STAGE13_VALIDATION.md`**. Destino: `core/NR2003Cup/NR2003CupFFB.lua` (portado à mão do x86, aritmética x87 exata) +
linhas do Stage 13 em `NR2003CupDriver.lua` e `NR2003CupFrame.lua`.

**Achados principais:** (1) o FFB não lê nenhuma célula da cadeia de direção: só estatísticas dos pneus dianteiros
(`00554e70` → `00554d30`) e o item 0x30 cru; nada volta para a física (prova dinâmica); (2) o efeito é uma única força
constante DirectInput num eixo (`_ftol(força × 10000)`), adquirida pelo `0054fed0` só com o controle 7 num eixo analógico,
FF ligado e dispositivo capaz; (3) `bf6eb8` é ao mesmo tempo o portão do FFB e o portão do ramo do jogador de `005524f0`;
(4) as opções só chegam pela leitura do controls.cfg (`0043f1d0`, inteiros); (5) o modelo double das convenções dos
Stages 6–12 muda um bit gravado em 197 de 26 568 chamadas reais (até 3,3 % num cenário) → aritmética x87 exata.

| Função | Papel | Chamado por | Chama | Células | Destino Luau | Status | Confiança | Evidência |
|---|---|---|---|---|---|---|---|---|
| `00554d30` | estatísticas dos pneus dianteiros por tick (carga, deslize, Fy, momento) | `005539c0` @00553a64 | — | `74c960..68`, `bf6ec4/c8/d0`, `bf6ed4..ef0` | `V._ffbTick` (de `tickInputs`) | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | alta | L1 2600 vetores, L2 21 168 chamadas originais rastreadas, L3 32 reinícios do Stage 12 |
| bloco FFB de `00554520` (`0055464c..0055479d`) | latência / amortecimento / força / relação → força constante | `00554520` | `005f7c50`, `00557d60`, `005d08d0` | `bf6ec0`, `bf6ecc`, `bf3a00`, opções, item 0x30 | `V._ffbFrameEnd` (de `frameEnd11`, a cópia erguida é saltada) | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | alta | L1 3000 vetores, L2 5400 blocos originais, L4 7 cenários |
| `00550070` | controles do jogador ativos / suspensos (`bf6eb8`) | `00550a50` @00550b07, `00550930`, `00550b30`, `00550a10`, `0057ab00` / `0057ab90` | `0054fed0`, `00550030` | `bf6eb8`, `bf6ebb` | `V.setControlsSuspended`, `enterTrack`, troca de vínculo | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | alta | L1 1728 casos (estado + sequência de chamadas) |
| `0054fed0` | eixo do FF = vínculo do controle 7; libera / adquire | `00550070`, `00550490` | `0057b1e0` → `0057aff0`, `00550280`, `005d0820`, `005f79a0` (`00550000` / `00550060`) | `bf6ebb`, `bf6ebc`, `74c95c`, `d37d83` | `configure` | EXACT (decisões) + ADAPTER (dispositivo) | alta | L1 (tipos 0 / 1 / 3; 2 / 4 formatam nomes de teclas no front end) |
| `00550030` / `00550680` | força zero / liberação no fim da sessão | `00550070`, `00550000` / `00572cb0`, `00573bc0` | `005d08a0` (sem efeito), `005d08d0` / `00550060` | `bf6ebb` | `zeroForce` / `V.endSession` | EXACT | alta | L1 |
| `00550270` / `00550290` / `005502d0` / `005502b0` | opções FF liga, força, amortecimento, latência (mensagens 8..11) | `005bb010..40` ← `0043f1d0` (controls.cfg) | — | `bf6f1c`, `74c9a4`, `bf6f24`, `bf6f20` | `V.setForceFeedbackOptions` | EXACT | alta | L1 464 vetores |
| `005d08d0` → `005d2260` → `005d3010` | força constante DirectInput (`_ftol(força × 10000)`, `SetParameters`) | bloco FFB, `00550030` | DirectInput | `f5d4f0`, `f5d414` | `deviceForce` → sink / `forceFeedbackState` | ADAPTER (conversão EXACT) | alta | L1 507 forças |
| `005d0820` / `005d0840` / `005d0870` / `005d2bb0` | capacidade / aquisição / liberação / criação do efeito | `0054fed0`, `00550000`, `00550060` | DirectInput | — | `setForceFeedbackDevice{capable, acquire}` | ADAPTER | — | Roblox: HUD + motores do gamepad |
| `005f79a0` | pedido ao thread de primeiro plano | `0054fed0`, `00550680` | `00550000` / `00550060` | `7559d8..e0` | chamada direta (caminho `005f79de`) | ADAPTER | — | harness: `jmp 005f79de` |

---

# Mapa de recuperação — Stage 12 (cadeia de direção)

Base: Stage 11 (3.10.0-stage11). Evidências: `recovery/stage12/` (Ghidra `evidence/ev1..ev14` com `FUNCS.txt`, listas
`funcs_*.tsv`, relatórios de pesquisa `evidence/reports/` — bit 25, itens de setup, geometria dos cubos, interface de
FFB —, harness `orig_stage12.py`, cenários `scenarios12.py`, fixtures `gen_units12.py` / `gen_fixtures12.py`, ferramentas
`dev/`). Relatórios: **`STAGE12_RECOVERY.md`**, **`STAGE12_STEERING_STATE_MAP.md`**, **`STAGE12_VALIDATION.md`**.
Legenda: **EXACT**, **LUA PORTED**, **LUA VALIDATED**, **ROBLOX INTEGRATED**, **ADAPTER**, **NOT PORTED**. Destino:
`core/NR2003Cup/NR2003CupSteering.lua` (portado à mão do x86) + linhas do Stage 12 em `NR2003CupDriver.lua`.

**Achados principais:** (1) direção = dois controles (7 esquerda / 8 direita, 0..1), um eixo analógico é separado pelo
sinal; (2) a única dependência de velocidade da entrada é a sensibilidade pela linearidade
(`(1 − 0,15 L) + 0,15 L·exp(−0,000493827 v²)`, nula com L = 0); (3) batente = π / relação (item 0x30, 18:1 → ±10°), com
override de baixa velocidade 7:1 até 8,94 m/s e rampa até 17,88 m/s; (4) sem Ackermann, sem bump steer, sem taxa de
esterço: os cubos são rotações prescritas sobre um eixo inclinado (caster 2,455°, inclinação 9,215°); (5) o bit 25 das
opções de corrida é o modo ARCADE (também troca a especificação do chassi no build) e a assistência de direção usa a linha
de corrida da pista — ambos recusados em produção; (6) os itens 0x3a / 0x9f..0xa4 ("steeringGeometry*") são do
diferencial traseiro, não da direção (correção no `SETUP_MAP.md`).

## Lógica original NR2003 — direção (portada à mão)

| Endereço | Papel | Chamadores | Chamados | Globais / offsets | Destino Luau | Status | Confiança | Validação |
|---|---|---|---|---|---|---|---|---|
| `005524f0` (ramo do jogador / não dirigido) | dispositivos do piloto por quadro | `00551e80` | `00553080`, `00552720`, `00552df0` | `bf63c8`, `bf6eac`, `bf6390`, células zeradas sem motorista | `frameStart` + `V._steerDevices` | EXACT para a entrada de direção (`bf63c8 = 00552720()`), o caminho do freio do Stage 8 (`00553080`) e as células do ramo não dirigido; acelerador / embreagem (`00552df0` / `005534f0`) ainda valores do host (PROVISIONAL desde o Stage 7); bloco `00568e00` / `bf6f18`, `0057af40(3)` / `bf6f36` e a porta estado de jogo / `bf6eb8` não portados (substituída por `controls.driver = false`) · ROBLOX INTEGRATED | alta | L2 1481 snapshots bit a bit contra o harness (no harness o ramo não dirigido e acelerador / embreagem também são host); cenário `notdriven` |
| `00552d00` | limite de taxa por controle + `sin(x·π/2)` (rate < 1) | `00552720`, `00552df0` | — | `74c990[i]`, `74c99c`, `bf639c[i]` | Stage 8 `V.axisOriginal` | EXACT · LUA VALIDATED | alta | L1 1212 vetores |
| `00552720` | entrada processada: velocidade, sensibilidade, limitador arcade, assistência | `005524f0` | `00554f50`, `00552410`, `00552d00`, `0055a770`, `00550230` | `bf6d70` (taxa de guinada), `bf6f44` | `steerInput` | EXACT · LUA VALIDATED (assistência > 0 NOT PORTED) | alta | L1 3872 vetores + sequência de 400 quadros |
| `00552410`, `00550230`, `0055a770`, `0055a680` | linearidade (remapeamento arcade/assistência), assistência, bit 25 | `00552720`, `00551e80` | — | `bf6f00`, `bf6f08`, `c0692a+0x4c` | `linearity`, `assist`, `settingsBit25` | EXACT | alta | L1 |
| `00551e80` cauda `@00552082..00552336` | `−bf63c8`, linearidade (`_CIpow`, só eixos analógicos), × π, ÷ relação, alvo, rampas | `005b2190` | `005524b0`, `00552410`, `006c5c40`, `00554fb0` | `bf63c0`, `bf63b8`, `bf6e80`, `bf6e88` | `V._steerTail` + `frameStart` (Stage 12.1: a constante π pode ser trocada pela opção do host `lockDegrees`; 360 = π, bit a bit) | EXACT · LUA VALIDATED | alta | L1 2100 vetores; L2; L3 |
| `00554fb0` | relação de direção (item 0x30) + override de baixa velocidade | `00551e80`, `005662d0`, `00565cc0` (o bloco FFB de `00554520` lê o item 0x30 cru via `00557d60`, sem o override) | `00557d60`, `00554f50` | `c055c0+0xc0`, `74c9a0` | `ratio` | EXACT · LUA VALIDATED | alta | L1 192 vetores (limiares ±1 ulp); cenários `ratio12` / `ratio32` / `parking` |
| `005502f0`, `005500c0`, `00550110`, `00550210`; `0043f1d0` | setters das opções (mensagens 0x48..0x4c / 0x51 da tabela `00752370`, despachante `005bad80` na tarefa de simulação); carga do controls.cfg | front end | — | `bf6f00`, `74c990..998`, `74c9a0`, `bf6f08`, `72c5f0` | `V.setSteeringOptions` (Stage 12.1: + `lockDegrees`, `cockpitLimit`, `momentumKeys` / `momentumAxis` do host) | EXACT · LUA VALIDATED | alta | L1 215 vetores |
| `005662d0`, `00565cc0` | ângulo do volante (cockpit / modelo) | desenho `00587aa5` (em `00587a90`) / `00587afb` (em `00587ae0`) | `00554fb0`, `005ba130` | `car+0x1554` (`00551990`), limite 2,79 rad `006f5e6c` (Stage 12.1: opção do host `cockpitLimit`, padrão da bancada = a trava) | `V.steeringWheelAngle` → `Cockpit.updateAngle` (em todas as câmeras; o original gira o nó `steer` só no cockpit / LookLeft / LookRight e usa o registro de desenho interpolado `005ba170`) | EXACT (fórmula) · ROBLOX INTEGRATED | alta | testes de comportamento / adaptador |
| `005539c0` (linhas de direção) | rampa por tick + toe → entradas dos cubos | `005b2190` | `005b2b90` | `bf6360/64`, `c086b0/b4` | `tickInputs` (Stage 7 + C1) | EXACT · LUA VALIDATED | alta | L3 / L4 (L2 cobre só o início de quadro) |

## Fronteira do host (ADAPTER) e itens não portados

| Item | Onde | Observação |
|---|---|---|
| poll de dispositivos `0057abc0` (controles 7 / 8, tipo de vínculo) | `NR2003CupSteering.hostDevices`, `CupChassisAdapter.steerControls` | teclado → digital (tipo 0); `Thumbstick1` / eixo → analógico (tipo 1, separado pelo sinal); `steer` legado = teclas. Mesmas células no harness Unicorn |
| calibração do joystick `005d04d0` (quadrática, sem zona morta) | — | o Roblox já entrega o eixo normalizado; zona morta do cliente `Config.gamepadSteerDeadzone` (padrão 0) |
| assistência de direção > 0 (linha de corrida `bd7960` via `car+0x5ae`) | `setSteeringOptions` → erro | NOT PORTED (sistema de pista) |
| modo ARCADE (bit 25: limitador + remapeamento + chassi 0 no build `004233a0`) | `setSteeringOptions{yawLimiter = true}` → erro (só validação) | NOT PORTED como opção de produção; o ramo da direção é EXACT (cenário `yawlimit`) |
| replay / rede (`005beac0`, quantização de `bf6360`) | — | NOT PORTED (sem replay) |
| FFB / torque de direção | **Stage 13**: `NR2003CupFFB` (`00554d30`, bloco FFB, `00550070` / `0054fed0`; ver o mapa do Stage 13 acima) | EXACT · LUA VALIDATED (Stage 13) |

---

# Mapa de recuperação — Stage 11 (térmico / desgaste / dano / combustível)

Base: Stage 10 (3.9.0-stage10). Evidências: `recovery/stage11/` (Ghidra `evidence/b1..b4` com `index.tsv` de
chamadores/chamados, varreduras de xref, grafo do lift `evidence/lift_callgraph.txt`, pseudo-C limpo
`pseudo/stage11_runtime.c`, harness `orig_stage11.py`, lifter `lift11.py`, gerador `gen_stage11.py`, rastreio
`trace11.py`, fixtures `gen_fixtures11.py`). Relatórios: **`STAGE11_RECOVERY.md`** (auditoria, ordem, achados, fronteira
do host), **`STAGE11_STATE_MAP.md`** (cada estado: endereço, unidade, inicialização, escritores/leitores),
**`STAGE11_VALIDATION.md`**. Legenda: **EXACT**, **LUA PORTED**, **LUA VALIDATED**, **ROBLOX INTEGRATED**, **ADAPTER**,
**PROVISIONAL**, **UNKNOWN**. Arquivo de destino de todo o código original abaixo: `core/NR2003Cup/NR2003CupFrameCode1..4.lua`
(erguido do x86, 216 funções: o fecho das raízes de `lift11.ROOTS`), orquestrado por `NR2003CupFrame.lua`.

**Achados principais:** (1) o fim de quadro inteiro do NR2003 roda em Luau a partir do x86 — combustível só age pela
massa/inércia do registro de componente (o solve gerado recompõe massa, CG e inércia); (2) não existe fade nem falha de
freio no executável (`0054f3d0`/`0054f610` sem referência); (3) não existe geometria de suspensão dependente de dano
(`0055e610/670/6c0/780` = `ret`); componentes quebrados chegam ao drivetrain; (4) o dano de colisão depende de três
estados que a bancada só-física nunca criou: a **árvore de zonas** (`00433610`, carga do modelo do carro), a **ordem de
corrida** (`car+4`) e o **objeto de colisão** do sistema de pista (`c7e75c`) — sem eles nenhuma colisão danificava o carro,
nem no original executado.

## Lógica original NR2003 — fim de quadro e eventos (erguido do x86)

| Endereço | Papel | Chamadores | Chamados principais | Globais / offsets | Destino Luau | Status | Confiança | Validação |
|---|---|---|---|---|---|---|---|---|
| `00554520` | fim de quadro do carro do jogador | `005b2190` | `00551ce0`, `0051a830`, `0051aac0`, `0051c3d0`, `005605c0`, `005f74c0`, `00551990`, `005547a0` (host), `005d08d0` (FFB, host) | `bf3a00` (velocidade do ar), `car+0x5aa`, `bf6ebb` (FFB) | `XF[0x554520]` via `V._frameEnd` | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | alta | snapshots sincronizados bit a bit; reinícios de estado completo |
| `0051aac0` (+`0051a9c0`, `0051be00`, `0040bde0`, `0051c850`) | motor por quadro: ignição/falha, combustível (BSFC 275 − 115·rpm/max), água/óleo, níveis, vazamentos, `x4d0`, sobre-giro, desgaste/vida, falha aleatória, potência × ρ/1,2 | `00554520`, `0052c640` | `0051a000`, `0054b610`, `005f56b0/e0` (rnd), `006c5c40` (pow) | motor `E=car+0xc`: `+0x4a4` água, `+0x4d4` óleo, `+0x50c` combustível (protegidos), `+0x49c/0x4a0` níveis, `+0x554` potência, `+0x558` desgaste | idem | EXACT · LUA VALIDATED | alta | idem + corridas `launch/overrev/idle/cold/hot` |
| `0051a830`, `0051a000`, `0051a020` | entradas do radiador (1,1, ρ, ar, velocidade do ar, fita); objeto motor; init do motor | `00554520`, `00550c40` | — | `E+0x470..0x480` | idem | EXACT · LUA VALIDATED | alta | idem |
| `0051c3d0` (`0051c300`, `0051c380`, `00548a00/aa0`, `0054b940`, `0055e7e0`) | falhas aleatórias de componentes (tensão³ × escala de dano) → flags `c086e0` | `00554520` | rnd fluxo 0 | `c086e0[9]`, acumulador de tensão por tick (Stages 6/7) | idem | EXACT · LUA VALIDATED | alta | cenário `failure` (22 snapshots através da falha no quadro 207) |
| `005605c0` (+`005b4840`) | combustível → massa/inércia do registro de componente | `00554520` | `00562f70` | `*c08234 +0x125/+0x141/+0x15d` (massa), `+0x179/...` (inércia = kg·0,1) | idem | EXACT · LUA VALIDATED | alta | reinícios (mutação +2 kg detectada) |
| `00551990` (+`00551890/920/950`, `00556e30`, `00565840/b70/c30`, `00562f50`) | instantâneo do carro + pneu visual (apresentação, mantido pela ordem dos sorteios) | `00554520`, `005637e0` | `0054d610` ×4 | — | idem | EXACT | alta | idem |
| `0054d610` | pneu por quadro: ambiente, resistência ao rolamento, pressão quente (gás amortecido), rigidez, calor, 3 zonas superfície/carcaça, resfriamento, fumaça/derrapagem | `00551990`, `00550f10` | `0054e9f0`, `0054f260`, `0054fb50`, `005100e0`, `00583590` | pneu `T=bf3a20+0xa39·w`: `+0x160/18c/1b8` superfície, `+0x1e4/210/23c` carcaça (protegidos), `+0x2a0` pressão quente, `+0x29c/+0x2a4` derivados lidos por `0054cab0` | idem | EXACT · LUA VALIDATED | alta | idem (mutação de `+0x29c` detectada) |
| `0054e9f0`, `0054ef10` | desgaste a cada 0,2 s (termo cúbico de sobretemperatura), aderência = 1 − 0,2·desgaste, estouro (> 0,66) | `0054d610` | rnd | `T+0x74` desgaste, `+0x134` relógio, `+0xcc` aderência | idem | EXACT · LUA VALIDATED | alta | idem (mutação de `+0xcc` detectada) |
| `0054f260` | temperatura do freio (sem fade/falha no executável) | `0054d610` | — | `T+0x26c` (protegido) | idem | EXACT · LUA VALIDATED | alta | cenário `brakes` |
| `00549c40` (`0054a330`, `00549290`, `00549860`, `00549ab0`, `0054a2a0`, `00549c00`, `00548740/760`) | dano de colisão do quadro: eventos de roda/pneu, dano de carroceria por zona, motor, vazamentos, fogo, peças soltas | `0055bfd0` | `0054a710` (zona), `00547e20`, `00577cb0`, `00592dc0` (host) | lista de registros `bf39f0`, pool `bf09c0`, zonas `006f5500`, escala `bef700`, `car+4` (ordem de corrida), `c7e75c` (objeto de colisão) | `XF[0x549c40]` via `V._frameEnd` | EXACT · LUA VALIDATED | alta | cenário `impacts` (snapshots + reinícios após cada impacto) |
| `0054a760`, `0054a8d0`, `0054aa20`, `00567660` | entrada de registro de colisão (máximo por chave), impactos de pneu/roda | código de contato da pista `00576e00` | `0054a710`, `005f6a70` | idem + `car+0x1323` (`getIntCount`) | `V.collision(rec)` | EXACT · LUA VALIDATED | alta | idem |
| `00433610`, `00433660`, `00547e60` | árvore de zonas de dano (planos de corte constantes do executável; pool estático `*bf39d4`) | carga do modelo `00432d90` | — | `00890490[6]`, pool `bef728..` | `V.buildDamageZones()` (sessão) | EXACT · LUA VALIDATED | alta | início de sessão bit a bit |
| `00563080` (`0054b3c0`, `0054b410`, `00547ee0`, `0054b0d0`), `00550c40`, `00550c60`, `005512d0`, `00550f10` | carro colocado na pista (`00550a50`, subconjunto): reparo, motor, combustível, pneus novos; troca de pneus | `00550a50`, `00559360`, ... | `0051a020`, `0054d610` | — | `V.enterTrack()`, `V.pitTyres()` | EXACT · LUA VALIDATED | alta | cenários `enter`, `pit` (snapshots de evento) |
| `00547e90` | opção de corrida 'dano' → `bef700` | `0055be60` | — | `c0692a+0x4c` bits 22–23 | `V.setDamageLevel` | EXACT | alta | início de sessão |
| `005486a0`, `0054b6c0/5a0/610/4c0/7d0/800/8c0/900/970/9b0/ba50` | objeto de dano (palavras empacotadas + floats decodificados) | dano / telemetria | — | `car+0x1493` (empacotado, layout `006f56b8`) | idem + `V.damageComponentOriginal` | EXACT | alta | idem |
| `00583250` ... `005b4e60` (partículas) | faíscas, fumaça, derrapagem, detritos — **mantidos**: sorteiam do fluxo aleatório 0 da física | `0054d610`, `00549c40` | rnd | listas de partículas | idem | EXACT | alta | RNG idêntico em todos os snapshots |

## Fronteira do host (ADAPTER) — idêntica no port e na referência Unicorn

| Item | Onde | Observação |
|---|---|---|
| contador de quadros `7559bc` e relógio de interrupção `7559c4` (+1 por quadro) | `NR2003CupFrame.frameStart11` | o laço de tarefas `005f78f0` e o relógio de interrupção do jogo; mesma convenção do harness do Stage 8 |
| registro de mundo do carro (`car+0x5ae`, pose de `005543f0`) | `syncWorldRecord` | pose/velocidades do estado exportado pelos `005f5a60`/`005f5ac0` originais (sem pista carregada) |
| ordem de corrida (`car+4/car+8`) | `frameEnd11` | anel de um carro só durante `00549c40` (habilitaria a cópia de render `005543f0` por tick) |
| objeto de colisão do sistema de pista (`c7e75c`, 9 partes) | `hostBlocks` | partes zeradas: o host não simula deformação de malha (PROVISIONAL) — zonas de canto 0–3 e 5 só mudam quando destruídas |
| campo de série `car+0x596` | `V.setSeriesField` | PROVISIONAL = 1 (valor real do roster não recuperado; só habilita dano de colisão) |
| `005547a0` (registro de replay), `00592dc0` (sincronização de dano), `00557650` (som), `005d08d0` (FFB), `005f58d0` (ponto de pista) | builtins do lift | sem pista/áudio/replay/FFB na bancada |
| `00554d30` (estatísticas de FFB por tick) | Stage 13: `NR2003CupFFB` (`V._ffbTick`) | portado no Stage 13; o bloco FFB de `00554520` é avaliado pelo `NR2003CupFFB` (a cópia erguida é saltada) |
| eventos de teste `DamageTestImpact` / `PitTyresTest` | `CupChassisAdapter.stage11TestEvents` | só teste (a bancada não tem paredes nem pit) |

## Mapeado / pendente (fora do Stage 11)

| Item | Status |
|---|---|
| produtores de registros de contato de carroceria (física de contato carro–parede/carro–carro, `005762f6`/`00576c1b`) | UNKNOWN (não analisado); avaliação do dano pronta a partir do registro |
| deformação da malha de colisão do sistema de pista (`00577xxx`) | UNKNOWN (host) |
| clima dinâmico `005a4cc0` | mapeado (Stage 9), não portado |
| menu de pit / ajustes em corrida / reabastecimento (`0040e1c0`, `005601c0`) | mapeado, não portado (só a troca de pneus `00550f10`) |
| zeros com sinal das somas exatas no lift do tempo de execução 6/7 (+0 onde o x87 dá −0) | herdado; candidato à divergência quase-estática do `overrev` (ver `STAGE11_RECOVERY.md` §6, §8) |
| Stage 12 (cadeia de direção) | concluído no Stage 12 (seção do topo) |

---

# Mapa de recuperação — Stage 10 (setup completo → parâmetros de tempo de execução)

Base: Stage 9 (3.8.0-stage9). Evidências: `recovery/stage10/` (pseudo-C limpo em `pseudo/stage10_setup.c`, exportações do
Ghidra em `evidence/b1..b4`, harness `orig_setup.py`, controle do emissor `emitter_control.py`, geradores). Detalhes:
`recovery/stage10/README_RECOVERY_STAGE10.md`. Mapa por item (184 itens, endereço/nome/exibição/unidade/faixa/passo/
conversão/destino/status/confiança/validação): **`SETUP_MAP.md`**.
Legenda: **EXACT**, **LUA PORTED**, **LUA VALIDATED**, **ROBLOX INTEGRATED**, **ADAPTER**, **PROVISIONAL**, **UNKNOWN**.

**Achado principal:** o NR2003 aplica um setup **reconstruindo o carro**, e o build **gera de novo os callbacks x87**
com decisões que dependem dos valores (dobras de 0/1, compartilhamento de células constantes, dedup de literais). O
código traduzido do Stage 6/7 é o do setup padrão. O Stage 10 ergue o build original inteiro para Luau, conduz as
decisões do emissor por tabela (estrutura natural = código do padrão, verificada; estrutura genérica = mesmo emissor
sem as dobras que variam entre setups) e reconstrói o carro em Luau para qualquer setup da garagem.

## Lógica original NR2003 — garagem (portada à mão, `Core/NR2003Cup/NR2003CupSetup`)

| Endereço | Papel | Destino Luau | Status | Validação |
|---|---|---|---|---|
| `c05150` | 184 × {kind u16, descritor*}; descritor: tipo (3 int / 4 float), mín, máx, passo, padrão, toInternal, toDisplay | `NR2003CupSetupData.items` (gerado do exe) | EXACT | 184/184 = original |
| `00423dc0..004241f0` | 29 conversores de unidade (identidade, %, graus, molas ×175×MR², pol, toe, lb, gal, K, barras, aerofólio) | `Setup.CONV` | EXACT · LUA VALIDATED | 2346 + 2433 vetores bit a bit em cada CW (0x027f / 0x077f), incl. −0 e NaN |
| `00557d20` | padrão do setup pelo descritor (CRT) | `Setup.defaults` | EXACT · LUA VALIDATED | = setup CRT |
| `00559950` (+`004254d0`, `00424490`) | complemento do padrão do Cup (combustível cheio, marchas, batentes) | `cupDefault` / `cupGarageDefault` (gerado) | EXACT | = original |
| `005582d0`, `00558320`, `00557e40`, `005581d0`, `005580f0`, `005583e0`, `00558380` | garagem: nº de passos, índice, valor na grade, set com grade+limites, set (retorno sem clamp), ±1 passo, set por índice | `Setup.stepCount/stepIndex/snapped/setSnapped/setClamped/step/setIndex` | EXACT · LUA VALIDATED | 62 / 2317 / 2317 / 2314 / 2314 / 4634 / 1823 vetores bit a bit (×2 CWs) |
| `00558da0` + `004247e0` | validação de arquivo de setup (.sto): limites sem grade; modos 1/5 track bar LR ≤ RR | `Setup.validateLoaded` | EXACT · LUA VALIDATED | 30 setups × 2 CWs |
| `00559360` | início de sessão: ativo = garagem; rebuild no task de primeiro plano; `00559820`; `00550c60` | `NR2003CupGarage.applySetup` (orquestração) | EXACT (ordem) · ADAPTER (gatilho) | — |

## Lógica original NR2003 — build do carro (erguido do x86, `NR2003CupBuild*`)

| Endereço | Papel | Destino Luau | Status | Validação |
|---|---|---|---|---|
| `00559820` → `00425ad0` (`00425690`, `004257a0`, `00425900`, `00425a30`, `00424860`) | itens derivados: relações de marcha, barras, amortecedores, ride RF, pesos de canto, perches, camber estático, alturas aero, deflexões | `XF[0x559820]` (erguido) | EXACT · LUA VALIDATED | passos 1–16 do build: 0 dwords diferentes do Unicorn |
| `00550c40` (`0051a020`), `00550c60`, `00550bc0` (`0054c1c0` ×4, `0056ed60`), `005b29c0` | motor/limitador, massa de combustível, objetos de pneu, árvore de componentes | idem | EXACT · LUA VALIDATED | idem |
| `005b2f20` → `0055e9b0` | setup → células/registros (molas, batentes, amortecedores, barras, Kb, toe, track bar, perches, caster/camber nos cubos, lastro, alturas aero, rake) | idem | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | build por setup = original (exato fora das células variáveis) |
| `005b4060`, `005b4560`, `005b3f50`, `005b2fb0`, `005b9ce0`, `005b3090` (+ IR/back-end `005bd*`, `005b9*`) | emissor dos callbacks x87 e execução do solve gerado | idem; callbacks executados pelo JIT traduzido (`NR2003CupJIT*` / `NR2003CupJITG*`) | EXACT · LUA VALIDATED | código, pool e literais = referência; células variáveis do solve ≤ 2e−4 rel (double × x87) |
| `0057c8d0`, `0057c900`, `0057ca60`, `005b9970` | decisões dependentes de valor do emissor | ganchos de decisão no código erguido (`G_*`), tabelas natural/genérica em `NR2003CupBuildData*` | EXACT (natural, verificado) · ADAPTER (genérica: resultado "não dobra" imposto nos 181 eventos variáveis) | 121 setups novos sem violação; espelho Unicorn `TableControl` |
| `0054d610` ×4 | propriedades do pneu (pressão/carga) após o build | idem | EXACT | idem |

## Tempo de execução e caminhos mapeados

| Endereço | Papel | Status |
|---|---|---|
| itens 0x29/0x2a (toe via `c086b0`), 0x3b/0x3d (aero `00410280`) | lidos pela física a cada tick do setup ativo | EXACT (Stages 7/9) |
| item 0x30 relação de direção | lida por `00554fb0` | armazenamento/conversão EXACT; uso = Stage 12 PROVISIONAL |
| itens 0x31, 0x47..0x5a (combustível, temperaturas, desgaste) | queima/térmica/desgaste em corrida | Stage 11 (congelados nos valores do build) |
| `005601c0`, `00550f10`, `0040e1c0` | pit stop: track bar/cunha e pressões em corrida sem rebuild | RECOVERED (pseudo-C), não portado |
| `00558530`, `00480b40`/`00480ba0` | passo de combustível com limites vivos; passos de marcha na UI | RECOVERED (fora do port: UI) |

## Adaptação Roblox (não é lógica NR2003)

| Item | Onde | Observação |
|---|---|---|
| `applySetup` (reset → build → nova imagem de reset → `reset()`), escolha natural → genérica, restauração da imagem para o padrão | `NR2003CupGarage` | orquestração; nenhuma conversão |
| Atributos `Setup_<item>` (unidades da garagem) + `SetupBrakeBias/SetupGrilleTape/SetupSpoiler` | `CupChassisAdapter.garageSetup/applyGarageSetup` | `Setup.set` (= `005581d0`) por atributo; rebuild só quando muda; saídas `SetupStructure/SetupApplySeconds/SetupError`, 1 linha de Output |
| Divisão em módulos < 200.000 caracteres com registradores compartilhados entre partes | `NR2003CupBuildCode*` | chamadas entre partes salvam/restauram EAX..ESP, FT, FSW |

---

# Mapa de recuperação — Stage 9 (aerodinâmica completa)

Base: Stage 8 (3.7.0-stage8) com Stages 6/7/8 validados no Studio; módulos gerados 6/7 intactos (o gerador os
reproduz byte a byte nesta máquina). Evidências: `recovery/stage9/` (pseudo-C/asm do Ghidra, xrefs, varreduras de
operandos, harness `orig_aero.py`, gerador `gen_fixtures_stage9.py`). Detalhes: `recovery/stage9/README_RECOVERY_STAGE9.md`.
Legenda: **EXACT**, **LUA PORTED**, **LUA VALIDATED** (comparado ao original executado), **ROBLOX INTEGRATED**,
**ADAPTER**, **PROVISIONAL**, **UNKNOWN / NOT RECOVERED**. "Gerado" = traduzido do x86 no Stage 6/7 (intacto).

**Achado principal:** o modelo aerodinâmico original já executava dentro do núcleo gerado, mas com **ρ = 0 e fatores
= 0**: o build do carro não roda o início de sessão (clima) nem a atualização por quadro do carro. Até o Stage 8 o
carro não tinha nenhuma força aero. O Stage 9 recupera e porta essas entradas e valida o caminho inteiro.

## Lógica original NR2003 — forças (gerado, intacto; agora validado)

| Endereço | Papel | Chamadores → chamados | Dados | Destino Luau | Status | Validação |
|---|---|---|---|---|---|---|
| `00561960` | emissor de build: registra `00561a80` e `00561b70` no callback de forças do chassi; liga velocidade (`+0x385`), rotação (`+0x2d9`), taxas (`+0x391..399`) e soma o resultado na força do chassi (`+0x39d`) via `005b7db0/005b87c0/005b8370/005b8040` | `00560680` (dispatch de forças no build) | células `c0836c..` (ar relativo), `c08404..c08418` (saída) | executou no build original; o JIT gerado contém as chamadas | EXACT (gerado) | trajetórias e snapshots |
| `00561a80` | meio vento: `0,5·(w − (w·n)n)` com `n` = normal da pista do objeto do carro (`car+0x5ae → +0x24`); sem objeto: `0,5·w` | JIT forças (2×/tick) → `0055ab00`, `00562f70` | `e0b840..e0b848`, células `*0074e094..9c` | `XF[0x561a80]` | EXACT · LUA VALIDATED | 600/600 vetores bit a bit (com/sem projeção) |
| `00561b70` | aero do chassi: `q = 0,5·ρ·|v|²` (ρ = `e0b84c`); yaw = `atan2(vy,vx)`; pitch = `atan2(−vz,|vxy|) + c083c4`; altura dianteira `((c084c8−z_LF)+(c084cc−z_RF))/2`; fatores `car+0x59e/5a2/5a6` → `00410280`; força ×`q·A` (spec+0xa0 = 2,0449 m²), momento ×`q·A·L` (spec+0xa4 = 2,794 m) + amortecimento angular `(k/|ω|)·ω` (k = `006f5cf8`, `006ea478` se `|ω| ≤ 0,1`); a cada 16 chamadas `00410b50` | JIT forças → `00410280`, `00410b50` | `0074e090` (contador), `0074fd74`·`006ea628` | `XF[0x561b70]` | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | 5000 vetores: 4892 bit a bit, pior 4,5e−6 relativo (x87 80 bits × double); 44 snapshots: telemetria = original 0 ulp |
| `00410280` | coeficientes: arrasto, lateral, sustentação e 3 momentos a partir de curvas de yaw (`spec+0xec..0x10c`, com mistura `007636e4` em `+0xf0/+0xfc/+0x108`), de pitch (`+0x110..0x128`, faixas ±10°, ±90°), de proximidade do solo (`+0x12c/0x130/0x134` em `max(0, 0,1778 − altura)`), escalares `+0xa8..+0xe0`, fita (item 0x3b, só se a opção `005486a0(obj,1) < 1`) × `+0xb8/+0xbc/+0xc0` × `(1+cos yaw)/2`, aerofólio (item 0x3d) × `+0xc4/+0xc8/+0xcc` × fator traseiro, itens 0x20/0x21 > 2° × `+0xb4` (Cup: 0), fatores de vácuo `(1−f)·+0xd8/+0xdc/+0xe0`, dano `00410910`; sustentação limitada a 3,0 | `00561b70` → `00410630..004108f0` (lookups `005677d1`), `00410910`, `005486a0`, `00557d60`, vtable `0x566aa0` | spec Cup `0x7238e0` +0xa0..+0x144; setup `c055c0` | `XF[0x410280]` e chamados | EXACT · LUA VALIDATED | idem (inclui todos os ramos de yaw/pitch, fita, aerofólio, dano) |
| `00410910` | deltas de dano aero: 11 zonas (`car+0x14a3`) × tabelas `spec+0x138..+0x144` (inclinação; valor fixo quando zona = 2,0) × `max(0,5, [bef700])` | `00410280` → `00547ec0` | `0071f908..0071fa68` | `XF[0x410910]`; **16 células das tabelas fora das janelas da imagem** (trace sem dano) gravadas por `NR2003CupAero` em cada reset | EXACT · LUA VALIDATED (dano ≠ 0 só no Stage 11) | vetores com dano: bit a bit/≤ 4,5e−6 após a correção |
| `00410b50` | estado de estol/histerese de yaw: `e0 += ((curva(+0xf8, yaw) − 1,5)·q·0,01 − 3)·dt·k`; `e4 = clamp(e4 + e0, 0, 1)`; só se `spec+0x9c & 2` e `[0071f904] ≠ 0` (Cup: ambos) | `00561b70` (a cada 16 chamadas) | `007636e0`, `007636e4`, `0071f904` | `XF[0x410b50]` | EXACT · LUA VALIDATED | contador e estado idênticos em 5000 vetores; derrapagem: comportamento = original |

## Lógica original NR2003 — entradas (portadas à mão no Stage 9, `Core/NR2003Cup/NR2003CupAero`)

| Endereço | Papel | Chamadores → chamados | Dados | Destino Luau | Status | Validação |
|---|---|---|---|---|---|---|
| `005a3c00` (subconjunto) | início de sessão: T(°C) = (T°F − 32)·5/9; T do ar para a densidade +28 °C se condições < 2 e dia; vento = −(cos, sin)(norte − dir·π/4)·mph·0,447; ρ = `005a3ba0(T, P·3386,53, UR)` | `0055d3ec → 0055af80 → 0055b140 → 0055a830` (task de simulação, CW `0x077f`) | objeto `e0b728` (+0x108..+0x124 = `e0b840..e0b84c`), settings `c0692a` (+0x48 bit 1, +0x4c bits 26..28, +0x58, +0x5c, +0x5d), norte `bdbcf8` | `V.startSession` (`applyWeather`) | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | 1576 vetores (todas as temperaturas × condições × noite; vento 0..30 × 8 direções × 3–6 nortes) **bit a bit** |
| `005a3ba0` + `005a3be0` | densidade do ar úmido `(fd(P·0,003484) − e_sat(T)·UR·0,001317)/(T+273,15)`; `e_sat` = 611 + 27,479T + 3,0953T² − 0,0257T³ + 0,0009T⁴ (Pa) | `005a3c00`, `005a4cc0` | `006f6f50..006f6f7c`, `006ee350` | `density`, `V.airDensityOriginal` | EXACT · LUA VALIDATED | 2500 vetores bit a bit |
| `005a38b0` | construtor do clima: UR 0,3, pressão 29,92 inHg, condições 1 (recipientes XOR) | inicializadores CRT `005a33e0/005a3630` | `e0b728` | constantes `HUMIDITY0/PRESSURE0` | EXACT | probe no emulador |
| option getters `004cd250..004cd2d0`, `004cec30` | RealisticWeather, condições 0..3, temperatura 40..110 (padrão 70 em `00743944`), direção 0..7, vento 0..30 | vtable `0x6f2338..` | `8d4534..8d4540`, `743944` | limites em `applyWeather` | EXACT (limites) | — |
| `005637e0` (subconjunto) | por quadro, antes de `005b2190`: fatores ← 1,0; `car+0x5aa` = \|v_obj − vento\| (`dx` gravado float32, `(dz²+dy²)+dx²`); se o carro é o focado: `005afd80` | `0055bfd0` (`0055d3f4 → 0055b450`, task de simulação) | `car+0x59e..0x5aa`, objeto de pista `car+0x5ae` | `V._aeroFrame` (chamado por `NR2003CupDriver.drive` antes de `frameStart`) | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | snapshots: fatores idênticos; cenários dentro do envelope |
| `005afd80` | vácuo: anel de ordem de corrida (`car+4` à frente, `car+8` atrás); gap = `00516daa` (volta `bad918`); gap normalizado = gap·75/max(5, \|v\|·spec+0xd4) (< 264 à frente, < 66 atrás); lateral < 7 m; esteira `005b0230`·spec+0xd0·atenuação; arrasto Π(1+w); sustentação dianteira/traseira ×(w·g/((g²·k+1)·r)+1) (k = 0,0004 / 0,001); atenuação ×(0,0786·lat + 0,45); arrasto final = min·(1 − (1 − max)·0,3); limites [0,5, 1,1] | `005637e0`, `0051f9b0` (outro chamador, não investigado) | `006f7340..006f7350`, `006ea514`, `006f5a64`, … | `V.draftingOriginal` / `V.setDraftEnvironment` | EXACT · LUA VALIDATED · ROBLOX INTEGRATED (interface; sem outros carros na bancada) | 3000 anéis sintéticos (1884 com esteira ativa) **bit a bit**; cenários de vácuo dentro do envelope, fatores = original |
| `005b0230` + `00567818` | esteira: tabela `006f7228` (x0 −45 m, dx 7,5 m, 32 linhas × colunas lateral 0 / 3,5 m; coluna 7 m = `e7d27c` = 0), interpolação linear na lateral | `005afd80` | `006f7228..006f733c`, saídas `e7d274/e7d278` | `wake`, `wakeLookup` | EXACT · LUA VALIDATED | 3000 vetores bit a bit |
| `00516daa` | gap na volta: `b − a` + comprimento enquanto negativo | `005afd80`, `0055bfd0`, … | `bad918` | `trackGap` | EXACT | via `005afd80` |
| `0051370a` | consulta da pista: distância na volta (+0x3c), lateral (+0x40), **normal da superfície** (+0x24/+0x28/+0x2c = `(−∂h/∂x, −∂h/∂y, 1)/norma`), direção (+0x34/+0x38) | `005f58d0` (posição do objeto do carro) | dados de pista `bcf734` | **não portado** (geometria da pista = host) | RECOVERED / IDENTIFIED | — |
| itens de setup 0x3b / 0x3d | fita no radiador (% 0..100 passo 5, `00423de0`) e aerofólio traseiro (45..70°, interno = graus − 45, `004241d0`); lidos em tempo de execução só por `00410280` (e 0x3b pela térmica do motor em `00554520`, Stage 11) | garagem; `0055c830` só lê | `c055c0`, descritores `006ee11c`/`006ee138` | `V.setAeroSetup` | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | 21 + 26 conversões = original |
| itens derivados 0xad/0xae/0xb1 | alturas de referência LF/RF (`c084c8/c084cc` = 0,19847 m) e ângulo de rake estático (`c083c4`) gravados por `0055e9b0` | build | `c084c0/c08310` = registros lfsusp/rfsusp | imagem pós-build (já original) | EXACT | aero com alturas variadas |

Mapa do aero Cup (do código original validado; `tests/stage9/AERO_MAP.txt`): a atitude fixa o arrasto e a
sustentação são puramente ∝ v² (Fx/v² = −0,614, Fz/v² = −0,510 com ρ 1,0812 → Cd·A ≈ 1,136 m², Cl·A ≈ 0,943 m²);
abaixo de 7 pol de altura dianteira o arrasto cai e o downforce sobe; com yaw a força lateral cresce rápido e a
sustentação inverte (Fz +6,9 kN a 90°, +15,2 kN a 135° a 70 m/s); aerofólio 45→70° +1,35 kN de downforce; fita 100 %
+1,03 kN de downforce e −163 N de arrasto.

## Adaptação Roblox (não é lógica NR2003)

| Item | Onde | Observação |
|---|---|---|
| Clima da sessão por atributos (`WeatherTemperatureF`, `WeatherWindMph`, `WeatherWindDirection`, `WeatherConditions`, `WeatherNight`, `TrackNorth`) | `CupChassisAdapter.initialize` | fazem o papel das opções de corrida; `TrackNorth` = ângulo do norte da pista no referencial do núcleo |
| `AeroSession = false` | idem | mantém o estado pós-build (sem ar) para comparação A/B |
| `SetupGrilleTape` / `SetupSpoiler` | idem | garagem; aplicados no reset |
| Normal do objeto de pista | `CupChassisAdapter.aeroHostInputs` | média das normais dos planos de contato apoiados (referencial do núcleo), por quadro |
| `DraftTestGap` / `DraftTestLateral` | idem | **TESTE**: carro fantasma em linha reta ao longo de +X do núcleo, mesma velocidade, esteira Cup, para exercitar o `005afd80` original; não é recurso do NR2003 |
| Telemetria/HUD aero | `CupChassisAdapter.telemetry`, `Client` | `aeroState` à taxa de telemetria; divisão dianteira/traseira = apresentação |

## Mapeado / pendente (fora do Stage 9)

- **Clima dinâmico** `005a4cc0` (+ `005a4690` vento, `005a4b10`) por quadro em `0055bfd0`, ativo quando o modo de clima
  (`settings+0x54` → recipiente `+0x128`) ≠ 1: deriva aleatória de UR/pressão/vento (rndSeed/rndUniform). Recuperado no
  nível do grafo de chamadas, **não portado**: a bancada usa clima constante do início de sessão (determinístico).
- **Vácuo com outros carros reais**: interface pronta (`setDraftEnvironment`); ordem de corrida e posição na pista dos
  outros carros vêm do multiplayer/pista (Stage 14 / ambiente). O re-ordenamento do anel em `0055bfd0` é do host.
- **Dano aero**: caminho `00410910` exato e validado com dano ≠ 0; as zonas `car+0x14a3` ficam 0 até o Stage 11.
- **Fita → térmica do motor** (`00554520 → 0051a000/0051a830` com ρ, `e0b830`, velocidade do ar e fator dianteiro) e
  `bf3a00` (velocidade do ar para a térmica de freio/pneu `0054f260`): consumidores do Stage 11, congelados.
- Som de vento `car+0x1196`: não físico.
- `00561e50`/`00561d90` (outro callback de forças do chassi, `005f6a70`/`005501d0`) e `005618d0`: fora do aero
  (não investigados neste estágio; não leem as células de ar).

---

# Mapa de recuperação — Stage 8 (modelo de freio completo)

Base: Stage 6/7 validado no Studio (núcleo gerado intacto). Evidências: `recovery/stage8/` (pseudo-C/asm do Ghidra,
xrefs, sítios-chave anotados, harness e fixtures do código original). Detalhes da cadeia:
`recovery/stage8/README_RECOVERY_STAGE8.md`.

Legenda de status: **EXACT** (mesma aritmética/ramos do original), **LUA PORTED**, **LUA VALIDATED** (comparado ao
original executado), **ROBLOX INTEGRATED**, **ADAPTER** (fronteira do host), **PROVISIONAL**, **UNKNOWN / NOT RECOVERED**.

## Lógica original NR2003

| Endereço | Papel | Chamadores → chamados | Dados | Destino Luau | Status | Validação |
|---|---|---|---|---|---|---|
| `0057af30` / `0057af40` / `0057af60` | valor bruto / botão / tipo de ligação do controle n | `00552d00`, `005524f0`, `00553080` | f32 `d35b18+10n`; i32 `d37cc8+29n` (1 = eixo) | host grava a tabela original (`NR2003CupDriver.frameStart`) | EXACT (leitura) + ADAPTER (dispositivo → tabela) | via vetores de `00553080` |
| `00552d00` | limitador de taxa por eixo (5 acel., 6 freio, 7/8 dir.) | `00553080`, `00552720`, `00552df0` | `0074c990..9c` (0.033/1.0/1.0, ×2.5), estado `bf639c+4k` | `V.axisOriginal` | EXACT · LUA VALIDATED | 3000 vetores: estados `bf63a0/bf63a8` bit a bit |
| `00554f50` | velocidade do carro (cache `bf6f44`) | `00553080`, `005524f0`, `00551e80` | `bf6d44/4c/54` | `speed()` | EXACT (recalcula; cache por `getIntCount` = ADAPTER sem efeito) | ≤ 1 ulp em 3000 vetores (0 diferenças) |
| `005f7570` = `005f6e40` + `005f74c0` | quaternion → matriz → ângulos (pitch/roll) | `00553080`, `005539c0` | `bf6d58` | `V.attitudeOriginal` | EXACT · LUA VALIDATED | 1500 quaternions, 0 ulp |
| `00553080` | **processamento do pedal**: hold automático (v < 0.8 m/s, acel. < 0.2 ou N; plano → 0.98; rampa → nível por pitch/roll, mín. 0.2), rampa de tecla (+1/12, −1/8 ou −1/24 por quadro), braking help | `005524f0` | consts `006efb28` 0.8, `006e9824` 0.2, `006f5a30` 0.5°, `006efac8` 0.98, `006f53c0` 1/12, `006f4614` 1/8, `006f5a24` 1/24, `006ea68c` 11, `006efbf0` 12.5, … | `V.brakePedalOriginal` | EXACT · LUA VALIDATED · ROBLOX INTEGRATED | **3000/3000 vetores bit a bit**; pedal idêntico ao original em 11 cenários e 25 snapshots |
| `00550130` | "braking help" (auxílio do piloto) | `00553080` | opção `bf6f04` (padrão 0), flag `0x20000000` em `c0692a+0x4c` | `brakingHelp()` | EXACT · LUA VALIDATED (ligado e desligado nos vetores) | |
| `005c2d20([c08194])` / `00509b60` / `005672e0→0055a730` | sessão online / tipo de piloto | `00553080` | `c08194`, `c067e0` (1 → freio 1.0) | offline: `005c2d20` = 0 | ADAPTER (offline) + EXACT (`c067e0`) | `c067e0` = 1 nos vetores |
| `005524f0` (subconjunto freio) | entradas do piloto por quadro; ramo "não dirigido" (pedal 1.0, embreagem 0); `bf6eb9` retido | `00551e80` | `bf6eac`, `bf6eb0`, `bf6390`, `bf63c8`, … | `frameStart` / `notDriven` | EXACT (ordem: pedal antes do acelerador) · LUA VALIDATED | cenário `nodriver` |
| `00551e80` (cauda) | pedal² → alvo, rampa de 8 ticks | `005b2190` | `bf6e34`, `bf6358`, `bf6e64` | Stage 7 (inalterado) | EXACT · LUA VALIDATED | 6/7 + 8 |
| `005539c0` + `005b2b90` | rampa por tick → `bf636c` → célula `e84474[3]` (`ebdd4c`) | `005b2190` | | Stage 7 (inalterado) | EXACT | |
| item de setup 0x28 / `00423de0` / `00423e00` | viés de freio da garagem (int 50..90 %, padrão 74; `pct·0.01f`) | garagem | descritor `006edf78` | `V.setBrakeBias` | EXACT (round-to-nearest do CW padrão: reproduz `0x3f3d70a4`) | rebuild original 60 % = células Luau bit a bit |
| `0055e9b0 @0055f314` | Kb por roda: `fd(maxT·b)` / `fd(maxT·fd(1−b))`, maxT = spec `+0x1bc` = 3800 N·m | build `005b2f20` | `c0850c..c08518` → células `ebbfa4..ebbfb0` | `V.setBrakeBias` | EXACT · LUA VALIDATED | 2812 / 987.99994; 2279.9998 / 1520.0001 |
| `005610b0` ×4 (`00561090/1230/1250/1270`) | emite no build o torque de freio/atrito por roda: C = brake·Kb + 10 + 1e−4ω² + τ_rr; D = M44·ω·288 + τ_y | `0055f8f0`/forças | `0074e798` (10), `0074e79c` (1e−4), `0074fda0` (288), registros 5/8/10/11 | código JIT gerado (Stage 6/7, intacto) | EXACT (tradução instrução a instrução) · LUA VALIDATED | snapshots: torque por roda ≤ 1,1e−3 relativo |
| `00561040` | `τ = −clamp(D, ±C)` (atrito estático/dinâmico → travamento) | JIT forças | | nativa traduzida | EXACT · LUA VALIDATED | travamento a 85 %, saturação a 74 %, roda traseira a 60 % = original |
| `0055e450..0055e480` | gravam o torque de atrito da roda em `tire+0x268` | JIT forças (`0074e86c`) | | `V.wheelBrake().torque` | EXACT (leitura) | |
| `0054cab0` (`@0054d0cf`, ramo de baixa velocidade) | τ de resistência ao rolamento em `c081f4[w]`; âncora longitudinal do pneu × célula de freio | JIT pneu | `c081f4..`, `*e84480` | nativa traduzida (Stage 6/7) | EXACT · LUA VALIDATED | cenários `nearzero`, `keyboard` (parada e hold) |
| `0055e3e0` | zera `c081f4..c08200` por passo | JIT | | nativa traduzida | EXACT | |
| `0054f260` (em `0054d610`) | temperatura do freio: `T += dt·(|τ·v_banda|/9200 − (T−T_amb)(√v+1)·0.0036)`, XOR em `tire+0x26c/+0x274` | `0054d610` (por quadro) | `tire+0x5c/0x60`, `0074c954`, `bf3a00` | `V.brakeTemperature` (leitura) | RECOVERED / IDENTIFIED — evolução **congelada (Stage 11)** | valor de build 295.0 K |
| `0054f3d0`, `0054f610` | limiares 400/550 K e falha aleatória do freio | **nenhum** (sem chamadas/ponteiros) | `tire+0x64/0x68` | não portado | RECOVERED / UNREFERENCED | busca por bytes e ponteiros em toda a memória |
| `0055e6d0` | viés por diagonal | **nenhum** | | não portado | RECOVERED / UNREFERENCED | idem |

**Fade:** inexistente no original (a temperatura não volta para o torque). **ABS:** inexistente no Cup; só o
"braking help" de auxílio ao piloto, desligado por padrão.

## Adaptação Roblox (não é lógica NR2003)

| Item | Onde | Observação |
|---|---|---|
| Tecla S → controle 6 = 0/1, ligação digital | `CupChassisAdapter.tickCore` | o cliente da bancada só tem teclado; `input.brakeAxis = true` seleciona eixo analógico |
| Sem piloto → `driver = false` | `CupChassisAdapter.tickCore` | equivale ao ramo "não dirigido" de `005524f0` |
| `SetupBrakeBias` (atributo do carro) | `CupChassisAdapter.initialize` | aplicado no reset, como a garagem; o original não tem ajuste no carro |
| Telemetria/HUD de freio | `CupChassisAdapter.telemetry`, `Client` | `locked` é indicador de apresentação |
| `getIntCount`, sessão `c08194` | harness e port | cache de velocidade recalculado; sessão offline |

## Ainda pendente / fora do Stage 8

- Evolução térmica do freio e do pneu (Stage 11), entrada do volante/acelerador/embreagem por dispositivo
  (`00552720`/`00552df0`/`005534f0`, Stages 12/7-host), gravação de replay/telemetria original (`0051370a`).

---

# Mapa de recuperação e limites — estágios 6 + 7

Origem: projeto Ghidra do `NR2003.exe` original entregue com o port (mesma imagem do mapa do estágio 5). A partir desta entrega o carro de referência **NR2003 NASCAR/Cup** roda no Roblox com o **núcleo original completo de 45 estados**: o código x86/x87 do próprio jogo foi executado (Unicorn) para montar o carro e depois traduzido para Luau. Detalhes da cadeia: `recovery/stage6_7/README_RECOVERY.md`.

## Arquitetura (NR2003PhysicsCore / RobloxAdapter / Rendering)

| Camada | Módulos | Papel |
|---|---|---|
| NR2003PhysicsCore (gerado) | `Core/NR2003Cup/NR2003CupImage1..2` | memória do carro **depois** do build original: spec Cup `0x7238e0` (série 0, chassis type 2), setup padrão dos descritores, motor/combustível/pneus inicializados, grafo de 16 componentes, células do emissor x87, tabelas de lookup |
| | `Core/NR2003Cup/NR2003CupCore` | estado de máquina + 86 nativas x86 traduzidas + primitivas do host (tires/export/import/checkpoint) |
| | `Core/NR2003Cup/NR2003CupJIT1..4` | as callbacks que o NR2003 gera no build (005b3090): predictor 005b39a0, solve 005b3180+0055e410, pneu×4 0055d9c0, forças 005b3990 (0055f8f0+00560680), corrector 005b3e50, commit 005b2fb0 |
| NR2003PhysicsCore (portado à mão) | `Core/NR2003Cup/NR2003CupDriver` | ordem do tick 005b2190 + camada do piloto 00551e80/005539c0 (aritmética float32 com arredondamento para −∞) |
| API numérica | `Core/NR2003CupVehicle` | monta os módulos; API sem Instances (eixos NR2003: +X frente, +Y esquerda, +Z cima, m, s) |
| RobloxAdapter | `Roblox/CupChassisAdapter` (modo `NR2003_CUP`) | planos de contato por raycast nas posições de roda **do núcleo**, controles, pose, fronteira de colisão, telemetria, snapshot de render |
| Rendering | `RenderSnapshot`/`SnapshotBuffer`/`RenderPresentation`/`VisualRig`/`Cockpit` (estágio 5, inalterados) + `Core/CupTune` (geometria de apresentação do Cup) | apresentação interpolada no cliente; nunca alimenta a física |

## Estágio 6 — suspensão, massas não suspensas, eixo traseiro

Os 45 estados do layout 005b2cd0 estão vivos no carro em Play (índices C a partir de 0):

| Componente (registro) | Estados | Observação |
|---|---|---|
| chassis (0) | 0–12: x,vx,y,vy,z,vz, quaternion xyzw, taxas de corpo | massa pós-setup 1074,50 kg; I=(471,0; 2455,5; 2695,7) |
| lfsusp (3) / rfsusp (6) | 13–14 / 19–20: curso e velocidade | eixo inclinado (0; 7,907°; ∓1,420°), offset (1,207; ±0,7684; −0,0982) |
| lfhub (4) / rfhub (7) | 15–16 / 21–22: ângulo prescrito de esterço | 73,03 kg; entrada `lfSteer/rfSteer`; rotação prescrita (flags 0x300: código 6, eixo z local) com ângulos-base (0; −10,407°; ±10,604°) sobre a suspensão — eixo de esterço com caster 2,455° e inclinação 9,215° passando pelo centro da roda; roda ∓8° (KPI); ordem dos ângulos Rz·Ry·Rx (`005b8c40`); velocidade 16/22 nunca escrita (sem taxa de esterço); sem Ackermann nem bump steer (Stage 12, `recovery/stage12/evidence/reports/hubgeometry.md`) |
| lfwheel (5) / rfwheel (8) | 17–18 / 23–24: ângulo e taxa de giro | Iyy = 1,71 |
| raxle (9) | 25–28: curso, velocidade, rolagem, taxa | 67,3 kg; eixo rígido (−1,587; 0; −0,2577), pitch −7,522° |
| lrwheel (10) / rrwheel (11) | 29–30 / 31–32 | 73,03 kg; (0; ±0,7684; 0,1042) no eixo |
| head (15) | 39–44 | massa 3 kg |

Molas, amortecedores, batentes, barras e todos os coeficientes vêm do setup padrão aplicado pelo próprio jogo (00559820 → 00425ad0/00425900/00425a20/00424860) e estão na imagem; nenhum valor do `TestTune` participa da física deste modo.

Contato: `0055e1e0` (forças de pneu 0054cab0 via 0055d880/0055d8d0/0055d920/0055d970) recebe por roda um plano `n·x + d = 0` em eixos do veículo, velocidade do solo, material e grip, exatamente os argumentos que 00576e00 passa. O adaptador consulta o solo **duas vezes por tick** (antes de cada passo de forças, como 00578da0/00578de0) na posição atual da roda (ponteiros de registro +0x32d/+0x339).

## Estágio 7 — drivetrain

| Peça | Origem | Situação |
|---|---|---|
| engine / clutch / outshaft (estados 33–38) | registros 12–14, I = 0,12 / 0,08 / 0,12 | vivos no núcleo |
| torque do motor, embreagem, projeção 0055fc50, diferencial 005614b0, acoplamento até as rodas traseiras | nativas chamadas pelas callbacks (00560dd0→0051a870, 0055fc50, 005614b0, 00561040, …) | traduzidas do x86; 4 marchas (engine+0x444) |
| máquina de troca de marchas, blip/corte de aceleração, embreagem automática | 00553d70 + 005542f0 + 00565830 + 005538a0/005538f0 (traduzidas) | modo de transmissão 1 (imagem), troca sequencial |
| limitador de giro | 005539c0: engine+0x438 = 9300 rpm, banda 4,34 % (006f5a3c) | portado à mão, teste PASS |
| pedidos de troca | 00552450 / 00552480 (portado à mão) | |
| timer de corte por frame | 0051aac0 (subconjunto +0x550) a 36 Hz | resto do 0051aac0 = estágio 11 |

## Sequência por tick (005b2190)

`e843fc=1` → 005539c0 (rampas, toe, freio, embreagem, **00553d70**, marcha, limitador, **005b2b90** predictor+solve, export 005b2cb0) → pneus ×4 (0055e1e0) → 005b2bd0 forças → `e843fc=0` → 005b2be0 corrector+solve, export → pneus ×4 → forças → 005b2c00 commit. Início de frame (a cada 8 ticks): 00551e80 (parte do carro do jogador). Fim de frame: 0051aac0 (corte). Leituras de estado do host exportam para um bloco de rascunho, sem tocar `bf6d40` (lido por 00554f10/00554ee0 no tick seguinte).

## Numérica

Memória = `buffer` com as células float32/int32 originais. Toda escrita float32 arredonda para −∞ (CW `0x077f` do task de simulação, `0055cef0` → `00567704(1,3)`); FIST = floor. Intermediários x87 de 80 bits são avaliados em double IEEE: diferença de 1–2 ulp por operação. Medido: ticks 1–8 com erro relativo ≤ 4,1e−7 contra o original; em horizonte longo a divergência fica dentro do envelope de sensibilidade do **próprio** original (mesma simulação original com z inicial +1 ulp). Ver `VALIDACAO.md`.

## PROVISÓRIO / NÃO RECUPERADO (marcado no código)

- **Direção (estágio 12):** o host entrega o ângulo-alvo de roda; a forma 00552720 + linearidade pow + razão 00554fb0 não estão portadas. Lei de slew/velocidade = bancada do estágio 5. O toe (`c086b0/c086b4` = 0,00224 rad) já é aplicado pelo caminho original.
- **Colisão de carroceria:** Blockcast + translação pelo import original 005b4560 (somente posições). Resposta de colisão NR2003 (forças de parede/carro) não recuperada; velocidade/momento não são alterados.
- **Sem geometria sob a roda:** plano 1000 m abaixo (o original simplesmente não cria o par de contato).
- **Âncora do pneu** reinicializada no ponto do raycast quando o contato reaparece (005778a0 usa a posição do objeto de contato).
- **Material:** índice repassado a 0055e1e0 (atributo `NRSurface` ou tabela do estágio 5); as tabelas de material da pista não são carregadas — o efeito do material vem da térmica do pneu (0054d610), congelada.
- **Estágio 11 congelado nos valores de build:** térmica/pressão do pneu (0054d610 por frame), combustível/massa (005605c0), térmica/dano/misfire do motor (0051aac0), falhas aleatórias (0051c300/0051c380).
- **Não portados (fora do escopo):** gravação de replay/telemetria (005548d0/0051370a), FFB, troca automática 005536b0 (modo 0), câmbio H (bf6f0c 1/2), estados de ignição do 005524f0/0057af40(0x19), estatísticas de frame 00554d30, cópias de render 005543f0/00551480.
- **Freio (8) e aero (9):** o caminho original de forças executa dentro do núcleo porque é inseparável das callbacks; a validação desses subsistemas e suas entradas não é reivindicada nesta entrega.

## Validação de identidade do port

`tests/stage67/run.luau` (16 checks) `tests/stage67/adapter_mock.luau` (16 checks, inclui o auto-teste de Studio) e `tests/stage67/patch_mock.luau` (11 checks) — resultados em `tests/stage67/RESULTS_STAGE67.txt`. O gerador reproduz os módulos byte a byte (`recovery/stage6_7/gen_runtime.py`).

# Histórico — mapa de recuperação do estágio 5 (mantido)

Origem: [TChapman500/OpenNR2003](https://github.com/TChapman500/OpenNR2003), commit `03bcafb44cf63464493f1864edbd9f781fac24f4`. O projeto contém análise Ghidra do executável. Os endereços abaixo se referem a essa imagem, não a funções de uma API pública.

Esta entrega conclui e valida o estágio 5 como baseline para os Stages 6 + 7. O núcleo multibody está traduzido e testado separadamente; o carro dirigível usa o integrador do núcleo para o chassi e o adaptador da bancada para as forças. A apresentação interpolada foi validada em Play no Studio em 2026-10-04. Não é declarado port integral do veículo/calibração original.

## Núcleo recuperado

| Lua | Origem | Implementação e alcance |
|---|---|---|
| `NR2003Components`, `NR2003StateLayout`, `NR2003VehicleState` | 005b29c0, 005b2c40 e percurso de cópia | Hierarquia, máscaras, massas, coordenadas livres/prescritas e layout de 45 entradas |
| `NR2003Math`, `NR2003MassProperties` | operações 0057c800–0057de00; transformações 005b31e0/005b3850 | Operações float32, matrizes espaciais e transformação de inércia/momento |
| `NR2003Constraints` | 005b3180–005b3850 | Coleta da inércia/momento dos filhos e distribuição de velocidades; LU em eixos selecionados (005b3490/005b36c0), sem pivotamento |
| `NR2003Integrator` | 005b39a0, 005b3e50, 005b2fb0 | Predictor, corrector e commit; atualização de geometria, quaternions e momento em referenciais móveis |
| `NR2003VehicleSolver`, `NR2003FixedStep` | orquestração Lua da sequência recuperada | API, passos a 288 Hz, snapshot, callbacks e replay; agenda é adaptação do host |
| `NR2003ForceAccumulator`, `NR2003Contact` | fronteira Lua para o núcleo | Forças/torques em referenciais explícitos, gravidade, pares internos e saída de pneu com momento de alinhamento |
| `NR2003DrivetrainProjection` | 0055fc50, 0055f8f0 | Matriz de correção das velocidades de rotores/rodas e reação no chassi |
| `NR2003RecoveredForces` | 00560b40, 00560c30, 005608d0, 00560e80, 00561290, 005610b0, 00561040 | Rotinas isoladas de suspensão, acoplamento e freio, com coeficientes/capacidades explícitos |
| `NR2003Derivatives` | taxas cinemáticas e saída do passo | Taxas de coordenadas e diferença média discreta; não reivindica recuperar uma função contínua de acelerações |
| `CoreChassisBridge`, `CoreChassisAdapter` | adaptação Roblox do estágio 5 | 13 estados ativos do chassi, forças da bancada, contatos externos, pose e colisão translacional |
| `RenderSnapshot`, `SnapshotBuffer`, `RenderPresentation` | estabilização PRE-STAGE-6 (host Roblox) | snapshots visuais compactos, interpolação cliente, slerp, extrapolação limitada e atualização antes da câmera; **não** pertencem ao solver original e não alimentam física |

O passo usa `float32(1/288)` e o corrector usa `float32(1/576)`. A sequência é predictor → resolver restrições → forças → corrector → resolver restrições → forças → commit. No commit, o momento físico salvo é `M * totalVelocity`; a velocidade local da junta não substitui a velocidade total.

### Hierarquia e vetor de estado

`inertial` é o referencial implícito. Os componentes são: chassis; ballast; fuel; lfsusp → lfhub → lfwheel; rfsusp → rfhub → rfwheel; raxle → lrwheel/rrwheel; engine; clutch; outshaft; head. Todos os ramos partem do chassis.

| Componente | Índices Lua |
|---|---|
| chassis | 1–13 |
| lfsusp / lfhub / lfwheel | 14–15 / 16–17 / 18–19 |
| rfsusp / rfhub / rfwheel | 20–21 / 22–23 / 24–25 |
| raxle | 26–29 |
| lrwheel / rrwheel | 30–31 / 32–33 |
| engine / clutch / outshaft | 34–35 / 36–37 / 38–39 |
| head | 40–45 |

Ballast/fuel não acrescentam coordenadas livres. `state_layout.csv` detalha campo, eixo, offset e índice C a partir de zero. Coordenadas prescritas de cubo não são graus livres de direção; a existência de um slot de velocidade no registro não recupera automaticamente uma derivada do controle.

O registro recuperado tem 0x505 bytes. Entre seus campos: nome 0x00, pai nominal 0x20, flags 0x40, offset 0x44, ângulos base 0x51, massa 0x5d, inércia 0x61, ligações 0x6d/0x71/0x75, eixos ativos 0x7d, matriz de restrição 0x95 e matriz de massa 0x125. Flags: translações nos bits 0–2, eixo de rotação nos bits 3–4, quaternion no bit 5, simetria axial no bit 6 e coordenada prescrita nos bits 7–9.

Campos dinâmicos contêm referências a células float: translação 0x2cd, rotação relativa 0x2d9, rotação de attachment 0x309, posição mundo 0x32d, rotação mundo 0x339, orientação 0x35d, momento 0x36d, velocidade 0x385, força 0x39d e velocidade total 0x3cd. Estado salvo inclui translação 0x1e5, rotações 0x221/0x251, orientação 0x275, momento 0x285, velocidade 0x29d e força 0x2b5. O CSV fornece a correspondência usada pelo Lua.

As massas recuperadas são um baseline **pré-setup**. `0055e9b0` modifica propriedades com o setup do carro, e esse carregamento não está completo no runtime. Não confundir os 584,79999 kg do registro inicial de chassis com a massa final de um carro Cup. O tune dirigível atual ainda tem 1.500 kg declarados e inércia experimental de caixa, mas **não é o target final**. O primeiro carro de referência do jogo será o NASCAR/Cup do NR2003; os Stages seguintes devem substituir parâmetros provisórios pelos valores originais recuperados/confirmados desse carro.

### Evidências e dispatch

`recovery/vehicle_core` contém 301 exports pseudo-C, assembly, memória e índice. O export selecionou 302 endereços; `00551710` está marcado como ausente. `recovery/baseline/pseudo_c` preserva 1.546 funções candidatas da entrega anterior. Essas contagens são evidência de análise, **não contagens de funções integralmente portadas**.

- `dispatch.csv`: 43 slots lidos dos bytes das tabelas. O seletor 0057dcd0 escolhe modo 0 (constantes), 1 (execução direta) e 2 (emissão x87). Tabelas binárias 0074fdac/0074fde0/0074fe14; unárias 0074fdbc/0074fdf0/0074fe24; quatro saídas de freio em 0074e86c.
- `generated_callbacks.json`: seis grupos de ponteiros montados por 005b3090, com alocação 005b9cf0 e execução 005b9d10. Inclui predictor e84548, solve e84498, pneu por roda e84b90, forças e84bdc, corrector e84ba0 e commit e84604.
- `call_graph.json`: referências a símbolos de função extraídas do pseudo-C, com dependências ausentes identificadas. Não é uma exportação de todos os xrefs nativos do Ghidra nem prova de cobertura de todos os callbacks de runtime.
- `original_x86_reference.py` e fixtures: execução independente de rotinas originais em cenários controlados; detalhes em `VALIDACAO.md`.

A entrada de forças 005b3990 encaminha para projeção 0055f8f0 e dispatch 00560680. Os ponteiros gerados e dependências de setup ainda não formam um carregador completo do carro original em Lua.

## Módulos de força preservados da bancada

| Módulo | Referência | Cobertura e condição |
|---|---|---|
| ComponentTree | 005b29c0–005b2c40 | Hierarquia, busca, ligações, contagem; herdado do pacote anterior. |
| RotationMatrix | 005b8c40 | Parte numérica da matriz; sem motor de expressões do original. |
| TrackProfile / RecoveredData | 0050fbd0; tabelas incluídas | Defaults e coeficientes de material; registros brutos preservados. |
| Lookup | 005677d1 | Interpolação/extrapolação; arredondamento de FIST é configurável porque o controle x87 do chamador ainda não foi recuperado. |
| Suspension | 0055e490, 0055e510, 00560b40, 00560c30, 005608d0 | Curvas mola/amortecedor, forças, antiroll, heave/roll do eixo como função isolada. Runtime usa contatos independentes. |
| TireCurves | 0054c1c0; 0055e8f0 | Construção das curvas de slip, velocidade, carga, rigidez e cambagem. `pow` foi inferido dos operandos x87; helper ofuscado não foi validado em execução. |
| TireForces | 0054cab0, chamador 0055d9c0 | Forças combinadas, relaxação, camber, resistência ao rolamento e caminho de baixa velocidade. A API NR2003Contact também permite aplicar a saída ao núcleo; o carro do estágio 5 conserva o adaptador de contatos. |
| TireThermal | subconjuntos 0054d610, 0054f260 | Pressão, fator de temperatura/pressão, três regiões superficiais + três internas, temperatura de freio. Entradas de calibração e alguns controles são explícitos no tune. |
| Engine | 0051a4a0, 0051a870 | Ajuste cúbico isolado e cálculo de torque com tabelas. Tabelas do runtime são curvas declaradas de teste. Modelo de perdas paramétrico original e térmica/danos não estão completos. |
| Drivetrain.limitTorque | callback 00561040 | Limitação de torque em oposição à demanda. |
| Drivetrain.differentialCapacity | callback 005614b0 | Expressão isolada de capacidade com os getters do setup expostos como argumentos. |
| Drivetrain.step / brake | adaptador | Integração de engine/wheel omega, acoplamento, câmbio, lançamento e diferencial limitado. O original soluciona isso na cadeia multibody. |
| Aerodynamics | combinação 00410280; escala 00561b70 | Interface de curvas e combinação de coeficientes; pressão dinâmica e amortecimento angular. Seleção/construção completa de tabelas, dano, interação entre carros e drafting não estão completos. |
| Steering, VehicleDynamics e módulos Roblox | adaptadores novos | Direção geométrica, forças da bancada, contatos, rig, rede, HUD e meshes. No estágio 5, CoreChassisBridge/Adapter ligam essas forças ao chassi numérico. |

## Convenções do pneu

`TireForces.evaluate(state, parameters, input)` conserva entradas de 0054cab0: velocidades longitudinal/lateral/normal, velocidade de banda, gap, bodyGap, camber, âncoras e steerTrail. A rigidez vertical usa sinal negativo para que compressão (`gap<0`) produza carga positiva. Cada roda possui estado próprio.

No carro desta entrega, a carga vem da suspensão por aproximação quase estática; `bodyGap` e âncoras são zerados. A API numérica independente permite enviar forças a outros componentes, mas não substitui por si só a recuperação da ancoragem original. O momento de alinhamento tem interface preservada; o fator `aligningTrailFactor` ainda não foi confirmado como calibração e fica desativado no tune. `bodyStiffnessScale` exige argumento quando seu ramo é usado.

## Adaptações e pendências após o estágio 5

- O chassi agora usa o integrador recuperado em `NR2003_CORE`, com 13 estados. O grafo de 45 estados está disponível/testado, mas massas não suspensas, eixo rígido e transmissão ainda não estão ligados integralmente ao carro em Play.
- O adaptador atualiza rodas/motor uma vez por tick e mantém as forças no predictor/corrector do chassi. Essa política é uma fronteira de integração provisória, não a reconstrução completa dos callbacks originais.
- Um raycast por roda; normal limitada, envelope de atrito e dissipação longitudinal de baixa velocidade explícitos no tune.
- Massa, inércia, torque e demais parâmetros da bancada não são calibração dinâmica original. Há embreagem de lançamento e auxílio de marcha lenta.
- Chassi numérico ancorado recebe pose por `PivotTo`; `Blockcast` trata translação. Sobreposição inicial, rotação sem translação, reação em corpos móveis, danos e colisões completas entre carros não estão resolvidos.
- Float32 em fronteiras recuperadas; os intermediários Lua não emulam toda aritmética x87 de 80 bits.
- Direção geométrica e animação do volante são provisórias. Não há force feedback completo, mapas aero/drafting completos, desgaste/furos/falhas completos ou carregamento integral de setup.
- Servidor calcula física. A apresentação cliente interpola snapshots via `UnreliableRemoteEvent`; o usuário validou em Play no Studio em 2026-10-04 que o carro ficou visualmente suave e que a suspensão física se tornou mais legível. Ainda não houve comparação de trajetórias/state-history do carro completo contra o jogo original.
- Prediction/reconciliation continua explicitamente fora deste patch e pertence ao Stage 14; o motorista local usa a mesma interpolação atrasada dos demais clientes.

### Próxima dupla do roadmap

A baseline 1–5 está aprovada para prosseguir. O próximo trabalho deve implementar, na ordem e no mesmo prompt, **Stage 6 — complete suspension / unsprung mass / rear-axle dynamics** e depois **Stage 7 — complete drivetrain integration**. Não iniciar Stage 8 nesta passagem.

O Stage 1 ter mapeado o grafo de 45 estados não significa que todos estejam live no carro: o Stage 5 ativa os 13 estados do chassi; Stage 6 deve ativar corretamente os estados de suspensão/hubs/wheels/rear axle e Stage 7 os estados/coupling de engine/clutch/outshaft/drivetrain.

Próximas integrações posteriores continuam pendentes após o Stage 7.

Referências do host: [WorldRoot / Blockcast](https://create.roblox.com/docs/reference/engine/classes/WorldRoot), [VehicleSeat](https://create.roblox.com/docs/reference/engine/classes/VehicleSeat), [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart), [RunService](https://create.roblox.com/docs/reference/engine/classes/RunService) e [RaycastParams](https://create.roblox.com/docs/reference/engine/datatypes/RaycastParams).
