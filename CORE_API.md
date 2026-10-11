# Force feedback — API do Stage 13 (núcleo NR2003 Cup)

O force feedback é o **código original** portado à mão do x86 (`NR2003CupFFB`, aritmética x87 exata: significando de 64
bits arredondado para −∞ em cada operação, gravações f32 para −∞): `00554d30` por tick (estatísticas dos pneus
dianteiros), o bloco FFB do fim de quadro `00554520` (latência, amortecimento, força, relação do setup) e o controle /
aquisição `00550070` / `0054fed0` / `00550680`. É uma **saída de apresentação**: nada volta para a física
(`STAGE13_RECOVERY.md` §9). As células estão em `STAGE13_FFB_STATE_MAP.md`.

```lua
local car = Vehicle.new()
-- opções = os valores do controls.cfg (mensagens 8..11 do original; nil = valor da imagem: FF desligado, 80, 0, 0)
car:setForceFeedbackOptions({enabled = true, strength = 80, damping = 0, latency = 0})   -- 0..100 / 0..100 / 0..250 ms
car:forceFeedbackOptions()          --> {enabled, strength, damping, latency} (células bf6f1c / 74c9a4 / bf6f24 / bf6f20)
-- camada de dispositivo do host (ADAPTER do DirectInput): capable = há saída FF para o eixo de direção; acquire = resultado
-- da aquisição (padrão true); sink(axis, force, magnitude) a cada força enviada (magnitude = _ftol(force * 10000))
car:setForceFeedbackDevice({capable = true, sink = function(axis, force, magnitude) end})
car:startSession(weather, opts)     -- a colocação do carro roda o 00550070(0) original (eixo do FF pelo vínculo do controle 7)
car:step({throttle = 0.5, clutch = 1, steerAxis = 0.1}, planes)   -- eixo analógico: o 0054fed0 adquire o efeito
car:forceFeedbackState()            --> enabled, acquired (bf6ebb), suspended (bf6eb8), effect (host), axis (bf6ebc),
                                    --   directionSign (74c95c), force (-1..1, último enviado), magnitude (DirectInput),
                                    --   blockRan (o bloco rodou no último fim de quadro), frames, calls, slip (bf6ec4),
                                    --   moment (bf6ed0), fy (bf6ec8), load (74c960), previousSlip (bf6ec0),
                                    --   filtered (bf6ecc), strength, damping, latency, setupRatio, airspeed
car:setControlsSuspended(true)      -- 00550070(1): 005524f0 toma o ramo não dirigido, bloco FFB desligado, força zero
car:setControlsSuspended(false)     -- 00550070(0): ativo de novo (eixo do FF configurado de novo)
car:selectActiveControls()          -- 00550070(0) sobre o vínculo atual (fgmsgSelectActiveControls)
car:endSession()                    -- 00550680: libera o efeito
```

* **Aquisição:** só com o controle 7 num **eixo analógico** (`steerAxis`, ou `steerDigital = false`), FF ligado e
  dispositivo capaz — como o original. Com teclas o efeito nunca é adquirido e não há força. Quando o tipo de vínculo do
  controle 7 muda com o FF ligado / adquirido (teclas ↔ eixo), o núcleo roda `00550070(0)` (o caminho do menu de
  controles do jogo).
* **Sinal:** o do valor que o original entrega ao DirectInput (força constante de um eixo, `rglDirection` 0: o sinal da
  magnitude dá o sentido); a força satura em ±1 (|ecc| ≥ relação · 1600 / força).
* `reset()` mantém as opções; `checkpoint()` / `restore()` incluem o estado do dispositivo do host.
* Somente teste: `V.x87` (aritmética), `V.ffbStatsOriginal`, `V.ffbFrameOriginal`, `V._ffbTrace`, `V._ffbHostState`,
  `V._ffbModel(model, mutation)` (modelo double / erros deliberados das suítes).

Adaptador Roblox (`CupChassisAdapter`): atributos do `TestCar` `ForceFeedback` (bool), `ForceFeedbackStrength`,
`ForceFeedbackDamping`, `ForceFeedbackLatency`, `ForceFeedbackDevice` (padrões em `CupTune.driver`: ligado, valores da
imagem, dispositivo presente); sem piloto no banco = `setControlsSuspended(true)`; saída em atributos `FFBForce`,
`FFBMagnitude`, `FFBActive` e na telemetria (`ffb`); o cliente mostra a linha `FFB` e, com gamepad, aciona o motor grande
com |força| (apresentação, `CupTune.driver.ffbRumble`).

# Direção — API do Stage 12 / 12.1 (núcleo NR2003 Cup)

A cadeia de direção é o **código original** portado à mão do x86 (`NR2003CupSteering` + linhas do Stage 12 em
`NR2003CupDriver`): controles 7 (esquerda) / 8 (direita) → `00552d00` (taxa por quadro + `sin(x·π/2)`) → `00552720`
(sensibilidade à velocidade pela linearidade) → cauda de `00551e80` (expoente de linearidade só com eixos analógicos,
× π, ÷ relação `00554fb0` = item de setup 0x30 com override de baixa velocidade 7:1 abaixo de 8,94 m/s e rampa até
17,88 m/s) → rampa por tick (`005539c0`) + toe → coordenadas prescritas dos cubos (estados 15 / 21) → multicorpo. O
volante do cockpit é a fórmula original `005662d0`. Nenhum estado é duplicado em Luau (`STAGE12_STEERING_STATE_MAP.md`).

```lua
local car = Vehicle.new()
-- controles por quadro (V.drive / car:step), além de throttle / clutch / brake do Stage 8:
--   teclado:  {steerLeft = 0..1, steerRight = 0..1, steerDigital = true}    (vínculo digital: tipo 0)
--   analógico: {steerAxis = -1..1}  (+ = direita; um eixo vinculado aos dois controles, separado pelo sinal; tipo 1)
--   sem motorista: {driver = false} -> ramo "carro não dirigido" de 005524f0 (entrada de direção 0)
car:setSteeringOptions({linearity = 80, momentum = 0, lowSpeedOverride = false})   -- setters ORIGINAIS
-- Stage 12.1 (opções do host; nil / 360 = o original):
car:setSteeringOptions({lockDegrees = 360, momentumKeys = nil, momentumAxis = 0, cockpitLimit = "lock"})
local o = car:steeringOptions()      -- {linearity, steerRate, releaseFactor, lowSpeedOverride, assist, yawLimiter,
                                     --  drivingMode = "simulation" | "arcade", aidsDisabled, setupRatio,
                                     --  lockDegrees, cockpitLimitDegrees, momentumKeys, momentumAxis}
local s = car:steeringState()        -- leitura das células originais (sem efeito colateral)
print(s.input, s.target, s.current, s.hubLF, s.hubRF, s.ratioNow, s.wheelAngle)
local a = car:steeringWheelAngle()   -- 005662d0: clamp(-(relação · car[0x1554]), ±2,79 rad), + = horário (direita)
                                     -- (Stage 12.1: limite = cockpitLimit)
```

| Método | Contrato |
|---|---|
| `setSteeringOptions(opts)` | opções do piloto pelos setters ORIGINAIS: `linearity` (inteiro do controls.cfg 0..100 → `(float)v·0,01f`, `005502f0`), `linearityRaw` (valor 0..1 de `bf6f00`), `momentum` (0..100; 0 = sem limite de taxa → 1,0; senão `(1/(m·0,01))·0,016663333999866692`, `005500c0`), `lowSpeedOverride` (bool, `00550110`, ini `steer_ratio`). `nil` = valor da imagem (sem controls.cfg: linearidade 0, taxa 0,033/quadro, override ligado). Os valores sobrevivem a `reset()` e a `applySetup()`. **Recusados (erro)**: `assist ≠ 0` (assistência de direção precisa da linha de corrida da pista do NR2003, não portada) e `yawLimiter = true` (modo de condução ARCADE, bit 25 das opções de corrida: também troca a especificação do chassi do carro no build, `004233a0`, não portado) |
| `setSteeringOptions(opts)` — Stage 12.1 (HOST, não original; `nil` = o original) | `lockDegrees` (1..3600; **360** = o `× π_f32` original da cauda de `00551e80`, bit a bit; outro valor troca só a constante por `f32(rad(lock/2))`); `cockpitLimit` (`"original"` = 2,79 rad de `005662d0`, `"lock"` = a trava, ou graus 1..1800); `momentumKeys` / `momentumAxis` (0..100: momentum aplicado pelo setter original `005500c0` no início de cada quadro conforme o dispositivo que dirige — tipo de vínculo digital ou eixo; `nil` = a taxa base: a de `momentum`, ou a da imagem 0,033). Fora da faixa = erro `NR2003 Stage 12.1: …` |
| `clearSteeringOptions()` | volta aos valores da imagem no próximo `reset()` (incluindo trava 360 e limite 2,79 rad) |
| `steeringOptions()` | leitura das opções e da relação de setup ativa (`c055c0+0xc0`) |
| `steeringState(out?)` | `mode`, `left` / `right` (controles brutos 7 / 8), `digital`, `slewLeft` / `slewRight` (`bf639c` / `bf63a0`), `input` (`bf63c8`), `shaped` (após a linearidade), `sensitivity`, `yawLimiter` (fator do limitador de taxa de guinada de `00552720`, calculado em todo quadro também em simulação: `min(12,25/max(v, 0,01), max(|r|, 0,01)) / max(|r|, 0,01) · 0,9 + 0,1`; só multiplica a entrada com o bit 25 / arcade; vale 1 antes do primeiro quadro), `ratio` (relação do último quadro), `ratioNow` (`00554fb0` na velocidade atual, sem tocar no cache), `target` (`bf63b8`, rad, + = esquerda), `frameTarget` / `ramp` (`bf6e80` / `bf6e88`), `current` (`bf63c0`, rampa por tick), `lf` / `rf` (`bf6360` / `bf6364`, com toe), `toeLeft` / `toeRight` (`c086b0` / `c086b4`), `hubLF` / `hubRF` (estados 15 / 21 exportados), `drawSteer` (`car+0x1554`), `wheelAngle` |
| `steeringWheelAngle()` | ângulo do volante do cockpit (`005662d0`); em runtime `"frozen"` usa a média dos estados 15 / 21 em vez de `car+0x1554` |
| `setSteeringMode("original" | "provisional")`, `steeringMode()` | produção = `"original"`; `"provisional"` = contrato dos Stages 6–11 (`controls.steer` = alvo da roda em rad, + = esquerda) **só** para as suítes de regressão / self-tests 6–11 |

Fronteira do host (ADAPTER): a camada de dispositivos `0057abc0` (DirectInput, calibração `005d04d0`) é substituída
pelo adaptador Roblox, que escreve os dois controles brutos e o tipo de vínculo; o Roblox já normaliza o eixo do
gamepad em −1..1. Adaptador: entradas `steerLeft` / `steerRight` (teclas), `steerAxis` + `steerAnalog = true`
(gamepad `Thumbstick1`), `steer` legado (= teclas); atributos do carro `SteeringLinearity` (0..100),
`SteeringMomentum` (0..100), `SteeringLowSpeedOverride` (bool), lidos a cada reset; aplicados:
`SteeringLinearityApplied`, `SteeringRateApplied`, `SteeringRatioApplied`. Relação de direção pela garagem:
`Setup_steeringRatio` (12..32, Stage 10). Stage 12.1: padrões da bancada em `CupTune.driver`
(`steeringLockDegrees = 360`, `setupSteeringRatio = 12` — usado pela garagem original quando não há `Setup_steeringRatio`,
`momentumKeys = nil` = taxa da imagem, `momentumAxis = 0`, `cockpitLimit = "lock"`); atributos que mandam sobre eles:
`SteeringLockDegrees`, `SteeringMomentumKeys`, `SteeringMomentumAxis`, `CockpitWheelClamp` (`"lock"` / `"original"`);
aplicado: `SteeringLockApplied`. Painel: linha `DIREÇÃO` com todos os ângulos em + = direita. Telemetria: `hubSteerAngle` (média dos estados 15 / 21, + = esquerda),
`roadWheelAngle` (guinada média das rodas dianteiras medida nas poses do solver, + = direita, ≈ −0,99·q),
`steeringWheelAngle`, `steering {…}` (subconjunto de `steeringState`). Render snapshot: `steer` = ângulo do volante
(flag `FLAG_WHEEL_ANGLE`).

---

# Térmico / desgaste / dano / combustível — API do Stage 11 (núcleo NR2003 Cup)

O fim de quadro do carro é o **código original** `00554520` (+ dano de colisão `00549c40`), erguido do x86 para Luau
(`NR2003CupFrame` + `NR2003CupFrameCode1..4` + `NR2003CupFrameData1`) e executado na memória do núcleo uma vez por quadro
de 36 Hz, depois dos 8 ticks: motor (`0051aac0`: ignição/falha, queima de combustível, água/óleo, níveis, vazamentos,
desgaste, falha aleatória, potência × ρ), falhas aleatórias de componentes (`0051c3d0`), massa/inércia do combustível no
registro de componente (`005605c0`), pneus (`0054d610`: pressão quente, rigidez, 3 zonas superfície/carcaça, desgaste a
cada 0,2 s, estouro, fumaça), freios (`0054f260`), dano de colisão. Os estados são lidos pelos ticks do quadro seguinte
pelo código dos Stages 6–10 (sem mudança): massa do combustível, pressão/rigidez/aderência do pneu, potência do motor,
componentes quebrados. Nenhum estado é duplicado em Luau.

```lua
local car = Vehicle.new()
car:startSession({temperatureF = 70}, {damageLevel = 3, consumptionRate = 0, series = 1, seed = nil})
-- ... car.V.drive(controles, contatos) por tick (o fim de quadro original roda a cada 8 ticks)
local s = car:stage11State()          -- leitura das células originais (sem efeito colateral)
print(s.fuel.kg, s.engine.water, s.tyres[3].surface[2], s.tyres[3].wear, s.damage.zones[7])
car:collision({magnitude = 150000, material = 0x10, surface = 1, point = {x, y, z}, localPoint = {2.4, 0, 0.3},
               velocity = {vx, vy, vz}, normal = {nx, ny, nz}, speed = 20})   -- registro original 0054a760
car:pitTyres({0, 1, 2, 3})            -- 00550f10 x4 (troca de pneus)
car:enterTrack()                      -- 00550a50 (subconjunto): reparo, motor/combustível, 4 pneus novos
car:setRuntimeMode("frozen")          -- A/B: fim de quadro dos Stages 6–10 (só para comparações)
```

| Método | Contrato |
|---|---|
| `startSession(weather, opts)` | Stage 9 (`005a3c00`) e, no modo `"original"`, a sessão do Stage 11: blocos do host, **árvore de zonas de dano** (`00433610`, carga do modelo do carro no jogo), campo de série `car+0x596` (`opts.series`, padrão 1, PROVISIONAL), opções de corrida `opts.damageLevel` 0..3 (`00547e90` → escala `bef700` = 0 / 0,15 / 0,6 / 1,0; `nil` = valor pós-build 1,0), `opts.consumptionRate` 0..3 (×1..×4; `nil` = pós-build ×1), `opts.seed` (estado do fluxo aleatório 0; `nil` = pós-build) e o carro colocado na pista (`enterTrack`). `reset()` reaplica a mesma sessão |
| `enterTrack()` | `00563080(car, 1)` (reparo `0054b3c0`), `00550c40` (motor: água 93 °C, óleo 0 °C), `00550c60` (combustível: célula cheia 62,4698 kg no treino; item 0x31 em corrida), `005512d0` (4 × `00550f10`: pneus novos à temperatura do ar da sessão `e0b834` + 11 °C, pressão fria do setup, desgaste 0) |
| `collision(rec)` | entrada ORIGINAL de registro de colisão `0054a760` (o que o código de contato da pista chama): `magnitude`, `material` (0x13 pneu, 0x10 carroceria), `flags` (0x2000000 contato contínuo), `surface` (material do outro), `point` (mundo), `localPoint` (referencial do carro → zona), `otherLocal`, `velocity`, `normal`, `p9`, `speed`, `key` 0..7, `other`. Avaliado por `0054a8d0` (pneus, imediato) e `00549c40` (carroceria, fim do quadro) |
| `pitTyres(wheels)` | `00550f10` por roda (0 LF, 1 RF, 2 LR, 3 RR) |
| `setDamageLevel(n)` / `setConsumptionRate(n)` / `setSeriesField(v)` / `setRandomSeed(s)` / `randomState()` | opções individuais (as mesmas de `startSession`) |
| `buildDamageZones()` | `00433610(car+0x58e)` (já chamado por `startSession`) |
| `setRuntimeMode("original" | "frozen")`, `runtimeMode()` | produção = `"original"`; `"frozen"` mantém o fim de quadro dos Stages 6–10 (subconjunto do cut timer) para as suítes de regressão 6–10 |
| `stage11State(out?)` | leitura: `fuel {kg (double protegido), massRecord, inertiaRecord, specInertiaPerKg}`, `engine {water, oil, coolantLevel, oilLevel, power, cutTimer, radiator[5], heat[2], overRev, wear, life, blown, flags, x4d0}`, `tyres[1..4] {coldPressure, pressure, surface[3], carcass[3] (K), wear, gripWear, brake (K), state, wheel}`, `damage {words, zones[11], tyre[4], radiator, oil, fuel, engine, x5c, x60, failures, brokenFlags[9], scale, series}`, `airspeed`, `ambient`, `bgCount`, `intCount`, `random`, `mode` |

Fronteira do host (ADAPTER, idêntica no port e na referência Unicorn): contador de quadros `getBGCount` (`7559bc`) e
relógio de interrupção `getIntCount` (`7559c4`) +1 por quadro; registro de mundo do carro sincronizado do estado exportado
antes do fim de quadro (`005f5a60` / `005f5ac0` originais); carro na ordem de corrida (anel de um carro em `car+4/car+8`)
só durante `00549c40`; objeto de colisão do sistema de pista (`c7e75c`, 9 partes zeradas — sem deformação de malha
simulada pelo host); registro de mundo/replay `005547a0`, som `00557650`, FFB `005d08d0`, sincronização de dano
`00592dc0` = `ret`; consulta de pista `005f58d0` = copia o ponto.

Adaptador Roblox: atributos do carro `RaceDamageLevel` (0..3), `RaceConsumptionRate` (0..3), `RosterSeries`,
`RandomSeed`, `Stage11Runtime = "frozen"` (A/B), aplicados no reset; **teste** (não é recurso do NR2003):
`DamageTestImpact = magnitude` (registro original no para-choque dianteiro), `PitTyresTest = true` (troca dos 4 pneus).
Telemetria por roda (`temperature` = superfície do meio, `tyreSurfaceK`, `tyreCarcassK`, `tyrePressure`, `tyreWear`,
`tyreGrip`, `tyreState`, `brakeTemperatureK`) e o resumo `stage11`; HUD (painel T): linha COMB / água / óleo / pot /
dano / pneus / freios.

---
# Setup — API do Stage 10 (núcleo NR2003 Cup)

O setup da garagem é convertido em parâmetros de tempo de execução **pelo próprio build original do carro**, erguido do
x86 para Luau (`NR2003CupBuild` + `NR2003CupBuildCode*`): `00559820` (itens derivados) → motor → combustível → pneus →
árvore → `005b2f20` (`0055e9b0` grava o setup nas células/registros e o emissor gera os callbacks) → `0054d610` ×4.
Nenhuma fórmula de conversão é escrita à mão fora do port das funções da garagem (`NR2003CupSetup`). Aplicar um setup
reconstrói o carro e o reinicia (como sair da garagem para a pista); o resultado vira a nova imagem de `reset()`.

```lua
local car = Vehicle.new()
local Setup = car:setupModule()            -- NR2003CupSetup (puro, sem Instances)
local s = car:defaultSetup()               -- setup cru [0..183] = garagem padrão do Cup (00559950)
Setup.set(s, "springLF", 1700)             -- unidades de exibição -> 005581d0 (grade + limites) -> toInternal
Setup.step(s, "camberRF", true)            -- 005583e0: +1 passo (false = -1)
Setup.setIndex(s, 57, 20)                  -- 00558380: diferencial no índice 20 da grade
local ok, rep = car:applySetup(s)          -- build ORIGINAL; ok=false -> setup anterior mantido
print(rep.structure, rep.seconds)          -- "image" | "natural" | "generic"
local d = car:setupDump()                  -- inspeção garagem -> tempo de execução (sem saída por tick)
print(Setup.display(car:setup(), "cornerWeightLF"), d.runtime.springRate[1], d.runtime.gearRatio[3])
```

| Método | Contrato |
|---|---|
| `setupModule()` | o módulo `NR2003CupSetup` (ver abaixo) |
| `defaultSetup()` | cópia da garagem padrão do Cup (`c03350` após `00559950`), formato cru `[0..183]` |
| `applySetup(s, opts?)` | aplica o setup cru `s` (u32 por item: bits float32 ou int32) pelo build original. Padrão → imagem entregue bit a bit (`structure = "image"`); senão tenta a estrutura **natural** (estrito: o resultado do emissor deste setup = o do padrão → exatamente o código original do setup) e cai para a **genérica**. Grava a garagem `c03350` e o ativo `c055c0`, roda a sequência, compara com a referência (eventos, literais, pool `d47d60`, topo de literais `ec02c4`, fim do código `ebbcec`, slots dos callbacks) e só então grava a pegada do build na imagem de reset e chama `reset()` (camadas 8/9 incluídas). `opts.structure` força uma estrutura; `opts.rebuild = true` reconstrói o padrão em vez de restaurar a imagem. Retorna `ok, report` |
| `setup()` | setup aplicado (`c055c0` após `00559820`, inclui os itens derivados) |
| `setupReport()` | último relatório: `ok, structure, violations, firstViolation, imposed, events, literals, pool, litTop, codeEnd, seconds, attempts` |
| `setupDump(out?)` | `items` = itens ajustáveis {índice, nome, unidade, valor exibido, cru}; `runtime` = células gravadas pelo build: `springRate` (`0074e0a0`), `bumpStopRate` (`0074e0d0`), `bumpStopGap` (`0074e0b0`), `bumpRubber` (`0074e0c0`), `shockBump`/`shockRebound` (`0074e0e0`/`0074e0f0`), `antiRollRate` (células var. de `0074e788/c`), `brakeTorque` (Kb, `c0850c..`), `toeHalf` (`c086b0..`), `springPerch` (`c083b0..`), `trackBar` (`c085ac`, `*c085b0`), `aeroRefHeight` (`c084c8/cc`), `aeroPitchOffset` (`c083c4`), `casterTrail` (`c082d4/d8`), `gearCount`/`gearRatio`/`finalDrive` (motor `+0x444/+0x448../+0x468`), `tyrePressure` (pneu `+0`) |

`NR2003CupSetup` (porta à mão, bit a bit nos dois CWs; `mode` = `"nearest"` 0x027f, padrão, ou `"down"` 0x077f):
`ITEM[i]` (nome, unidade, grupo, status, descritor), `index(nome)`, `adjustable(i)`, `toInternal(i, bitsExibição, mode)`,
`toDisplay(i, cru, mode)`, `stepCount(i)` (`005582d0`), `stepIndex(s, i)` (`00558320`), `snapped(s, i)` (`00557e40`),
`setSnapped(s, i, bits)` (`005581d0`), `setClamped(s, i, bits)` (`005580f0`), `step(s, i, up)` (`005583e0`),
`setIndex(s, i, k)` (`00558380`), `defaults()` (`00557d20`), `validateLoaded(s)` (`00558da0` + `004247e0`, arquivo .sto),
`copy`, `cupDefault`, `cupGarageDefault`; conveniência (ROBLOX ADAPTER): `display(s, i)` → número, `set(s, i, número)`.

Baixo nível (`car.V`): `applySetup/setup/setupReport/setupDump/setupStructure`, `V.Setup`, `V.Build`
(`run(items, structure)`, `begin/step/check`, `saveFootprint/loadFootprint/copyFootprint`, `REF`), `V._bindDriverCells`
(Stage 8, re-liga as células de freio/inércia após um rebuild). Núcleo: `V._pristine()` (imagem de reset), `V.imageSize`,
`V._jitTable()` / `V._jitLoad(módulos)` (conjunto de callbacks ativo / carregar `NR2003CupJITG*`).
A relação de direção (item 0x30) é armazenada/convertida como no original; quem a usa é a cadeia de direção (Stage 12,
provisória). Combustível, temperaturas e desgaste (itens 0x31, 0x47..0x5a) entram no build; a evolução é do Stage 11.

Adaptador Roblox: atributos `Setup_<nomeDoItem>` no carro em unidades da garagem (`Setup_springLF = 1700`,
`Setup_camberLF = -2.5`, ...; `SetupBrakeBias`, `SetupGrilleTape`, `SetupSpoiler` continuam valendo) aplicados no
`initialize/reset` só quando o setup muda; saídas `SetupStructure`, `SetupApplySeconds`, `SetupError`.

---

# Aerodinâmica — API do Stage 9 (núcleo NR2003 Cup)

As forças aerodinâmicas são calculadas **pelo código original gerado no build** (`00561a80` + `00561b70` →
`00410280`, registrados por `00561960` no callback de forças do chassi) e entram no chassi como força + momento
espaciais (`005b8370`/`005b8040`), nos dois passos de forças de cada tick. O host nunca aplica força aero.
O que o Stage 9 acrescenta são as **entradas** que o build sozinho não produz e o jogo produz durante a corrida:
o ar da sessão (`005a3c00`) e a atualização por quadro do carro (`005637e0`: fatores, velocidade do ar, vácuo).

```lua
local car = Vehicle.new()
car:reset()
car:startSession({temperatureF = 70, windSpeedMph = 0, windDirection = 0, conditions = 0, night = false,
                  trackNorth = 0})          -- nil/campos ausentes = padrões originais (opções de corrida + construtor)
car:setAeroSetup({grilleTape = 0, spoiler = 65})   -- itens de garagem 0x3b / 0x3d (aplicar após reset)
car:setTrackNormal({0, 0, 1})               -- normal da pista sob o carro (objeto de pista +0x24), opcional
car:setDraftEnvironment({trackLength = 4023, lapDistance = 120.5, lateral = 0.3,
    ahead  = {{lapDistance = 128.4, lateral = 0.2, vx = 70, vy = 0, vz = 0}},   -- ordem de corrida (car+4)
    behind = {{lapDistance = 128.4, lateral = 0.2, vx = 70, vy = 0, vz = 0}}})  -- (car+8); nil = carro único
for tick = 1, 288 do car:step(controls, contacts) end
local a = car:aeroState()       -- telemetria: 00561b70 original no estado atual (sem efeitos colaterais)
print(a.density, a.q, a.drag, a.downforce, a.downforceFront, a.downforceRear, a.factorDrag)
```

| Método | Contrato |
|---|---|
| `startSession(weather?)` | porta de `005a3c00` (subconjunto que alimenta o aero): temperatura °F (40..110, getter `004cd280`), vento mph (0..30, `004cd2d0`), direção 0..7 (×45°, `004cd2b0`, fora da faixa → 0), condições 0..3 (`004cd260`), noite (bit 1 de settings+0x48), `trackNorth` (rad, dado da pista `bdbcf8`), `humidity` (padrão 0,3) e `pressureInHg` (padrão 29,92) dos recipientes do construtor `005a38b0`. Grava `e0b840/e0b844` (vento x/y), `e0b84c` (densidade, `005a3ba0`+`005a3be0`) e as temperaturas do objeto de clima. Ativa a atualização por quadro. Retorna os valores aplicados e derivados. Sobrevive a `reset()` |
| `endSession()` | volta ao estado pós-build (ρ = 0, fatores 0): o estado de todas as fixtures e auto-testes dos Stages 6–8 |
| `sessionActive()`, `weather()` | estado da sessão |
| `setAeroSetup({grilleTape, spoiler})` | fita no radiador % 0..100 passo 5 (`00423de0`: pct·0,01f, nearest) e aerofólio 45..70° (`004241d0`: graus − 45) gravados no setup ativo `c055c0`; o original os lê em tempo de execução (nenhuma conversão de build depende deles). Retorna os valores aplicados |
| `aeroSetup()` | fita %, aerofólio °, valores internos |
| `setTrackNormal(n \| nil)` | vetor `+0x24` do objeto de pista do carro (normal da superfície, `0051370a`), usado por `00561a80` para projetar o vento. `nil` = sem objeto de pista (vento sem projeção, como no build) |
| `setDraftEnvironment(env \| nil)` | entradas de `005afd80`: comprimento da volta (`bad918`, > 0), distância na volta / lateral do próprio carro (objeto +0x3c/+0x40), e os outros carros em ordem de corrida (`ahead` via `car+4`, `behind` via `car+8`) com distância, lateral, velocidade (objeto +0xc) e `wakeStrength`/`wakeLength` (spec +0xd0/+0xd4; padrão Cup 1/1). `nil` = sem anel (fatores 1,0, idêntico ao anel de um carro só) |
| `aeroFactors()` | fator de arrasto `car+0x59e`, sustentação dianteira `+0x5a2`, traseira `+0x5a6`, velocidade do ar `+0x5aa` |
| `aeroState(out?)` | avalia o `00561b70` ORIGINAL no estado exportado atual (velocidade do chassi − meio vento projetado, girada para o chassi; taxas do corpo), salvando/restaurando o contador `0074e090`, o estado de estol `007636e0/e4` e o alvo de export `e847c8`. Campos: `fx fy fz mx my mz` (eixos do chassi, em torno da origem do chassi), `drag` = −fx, `downforce` = −fz, `side` = fy, `downforceFront/Rear` (divisão equivalente pelos braços da suspensão dianteira e do eixo traseiro — só apresentação), `q`, `density`, `wind`, `airspeedBody`, `yaw`, `pitch` (+`c083c4`), `rideHeightFront` (`((c084c8−z_LF)+(c084cc−z_RF))/2`), `groundProximity` (0,1778 m − altura), fatores, `airspeed`, `stall` (`007636e4`) |

Baixo nível (`car.V`): `airDensityOriginal(T,P,RH)`, `esatOriginal(T)`, `wakeOriginal(gap, lat)`, `draftingOriginal(env)`,
`_aeroFrame()` (subconjunto de `005637e0`, chamado por `NR2003CupDriver` no início de cada quadro, antes de `frameStart`).

---

# Freio — API do Stage 8 (núcleo NR2003 Cup)

O freio entra pela **cadeia de entrada original** (`00552d00` → `00553080` → `bf6eac` → quadrado/rampa `00551e80` →
`bf636c` → célula de freio `e84480`) e vira torque nas rodas pelo **código de forças original gerado no build**
(`005610b0` ×4 + `00561040`). O host nunca aplica força de frenagem no chassi.

```lua
local car = Vehicle.new()
car:setBrakeBias(74)          -- viés da garagem (% dianteiro, inteiro 50..90; Cup padrão 74). Aplicar após reset()
for tick = 1, 288 do
    car:step({throttle = 0, clutch = 1, steer = 0,
              brakeControl = 1, brakeDigital = true,   -- tecla S (ligação digital: rampa 1/12 por quadro)
              throttleControl = 0}, flat)
end
local pedal, target, tickValue, core = car:brakeState()  -- bf6eac, bf6e34 (pedal²), bf636c, e84480
local w = car:wheelBrake(0)   -- LF: torque, kb, brakeCap, dragCap, omega, inertia, fx, fy, fz, vx, vslip, tread, temperature, locked
```

| Campo de `controls` | Contrato |
|---|---|
| `brakeControl` | valor bruto do dispositivo 0..1 (tecla 0/1 ou eixo do pedal) gravado no controle 6 da tabela original (`d35b18+60`) |
| `brakeDigital` | `true` (padrão) = ligação de tecla/botão (`0057af60(6)` verdadeiro); `false` = eixo analógico |
| `throttleControl` / `throttleDigital` | controle 5 (só influencia a taxa de soltura da tecla de freio); padrão = `throttle`, digital |
| `driver = false` | ramo "carro não dirigido" de `005524f0`: pedal 1,0, embreagem 0, acelerador 0 |
| `brake` (sem `brakeControl`) | contrato do Stage 6/7: valor injetado direto em `bf6eac` (pula `00553080`); usado pelas fixtures de regressão 6/7 |

| Método | Contrato |
|---|---|
| `setBrakeBias(pct)` | `00423de0` (pct·0.01f, nearest) → item 0x28 → células Kb exatamente como `0055e9b0` (`fd(3800·b)`, `fd(3800·fd(1−b))`). Retorna o pct aplicado (limitado ao descritor 50..90) |
| `brakeBias()` | `b` interno, pct, torque máximo (3800 N·m) |
| `brakeState()` | pedal processado, alvo do quadro (pedal²), valor por tick, célula do núcleo |
| `wheelBrake(i, out?)` | leitura sem efeitos colaterais das células originais da roda i (0 LF, 1 RF, 2 LR, 3 RR). `torque` = torque de atrito gravado por `0055e450..80` (`tire+0x268`); `brakeCap` = célula de freio × Kb; `dragCap` = 10 + 1e−4·ω² + resistência ao rolamento; `fx/fy/fz` = saídas do pneu (`+0x2d8/+0x2dc/+0x2e0`); `vx` = velocidade longitudinal do contato; `vslip` = banda − solo; `locked` = indicador de apresentação (banda ≈ 0 com o contato deslizando) |
| `brakeTemperature(i)` | temperatura do freio (K), armazenamento XOR original; evolução por quadro (`0054f260`) congelada até o Stage 11 |

Baixo nível (`car.V`): `brakePedalOriginal()`, `attitudeOriginal(addr)`, `axisOriginal(n)` expõem o port bit a bit para os testes.

---

# API do núcleo NR2003 Cup (estágios 6–7)

`Core/NR2003CupVehicle` monta o núcleo original gerado (`Core/NR2003Cup`). Sem Instances; eixos NR2003 (+X frente, +Y esquerda, +Z cima), SI.

```lua
local Vehicle = require(ReplicatedStorage.NR2003Lab.Core.NR2003CupVehicle)
local car = Vehicle.new()                    -- usa Core.NR2003Cup
local flat = {}
for i = 1, 4 do flat[i] = {0, 0, 1, 0,  0, 0, 0,  1, 1} end  -- nx,ny,nz,d, gvx,gvy,gvz, material, grip
for tick = 1, 288 do
    car:step({throttle = 0.7, brake = 0, clutch = 1, steer = 0, shiftUp = tick == 9}, flat)
end
local s = car:readState()                    -- 45 floats (ordem 005b2cd0, índice Lua = C + 1)
print(car:engineRpm(), car:gearIndex(), car:revLimiter())
local cp = car:checkpoint(); car:restore(cp) -- cópia completa da memória (bit a bit)
```

| Método | Contrato |
|---|---|
| `Vehicle.new(folder?)` / `Vehicle.fromLoader(get)` | carrega imagem, núcleo, JIT e camada do piloto |
| `car:reset()` | volta à memória pós-build (carro parado a z = 0,42 m sobre o plano z = 0) |
| `car:step(controls, contacts)` | um tick de 288 Hz na ordem 005b2190. `controls` são lidos no início de cada frame de 36 Hz (8 ticks): `throttle`, `brake` (pedal 0..1), `clutch` (engate 0..1, 1 = pedal solto), `steer` (alvo de roda em rad, + esquerda, PROVISÓRIO), `shiftUp`/`shiftDown`. `contacts`: 4 planos ou `function(phase)` chamada antes de cada passo de forças (phase 1/2) |
| `car:readState(out?)` | export 005b2cb0 para bloco de rascunho (não altera o bloco do jogo `bf6d40`) |
| `car:componentPose(record)` | posição mundo + rotação 3×3 (linhas) via ponteiros do registro +0x32d/+0x339. Registros: 0 chassis, 4/7 cubos, 5/8 rodas dianteiras, 9 eixo traseiro, 10/11 rodas traseiras |
| `car:contactOut(i)` | saída do último 0055e1e0 da roda `i` (0–3): `out1` (z = carga normal N; x/y não recuperados) e ponto de contato |
| `car:resetContactBlock(i, x, y, z)` | reinicia o bloco persistente do contato (âncora + 2 estados) |
| `car:translate(dx, dy, dz)` | desloca posições pelo import original 005b4560 (velocidades não mudam) |
| `car:engineRpm()`, `gearIndex()` (0 R, 1 N, 2.. marchas), `gearCount()`, `revLimiter()`, `inputs()` | leituras das células originais |

Baixo nível (`car.V`): `stepRaw(inputs, contacts)` escreve `bf6360` direto (testes contra o original), `drive`, `state`, `rf32/ri32/r32/wf32/w32` com endereços originais.

---

# API do núcleo numérico

Os módulos `core/NR2003*.lua` usam números e tabelas, sem Instances. As unidades são SI: m, s, kg, N, N·m e radianos. Eixos originais: +X frente, +Y esquerda, +Z cima. Matrizes são arrays planos por linha; quaternions usam x,y,z,w. O adaptador Roblox converte escala e referencial na fronteira.

## Construção e execução

Exemplo fora do Roblox, a partir da raiz do pacote; demonstra uma massa livre com gravidade e força, sem chão:

```lua
package.path = "./core/?.lua;./?.lua;" .. package.path
local Solver = require("NR2003VehicleSolver")
local Fixed = require("NR2003FixedStep")
local solver = Solver.new({
    records = {{
        name="chassis", parentName="inertial", flags=39,
        mass=1500, inertia={400,2600,2600},
        offset={0,0,0}, angles={0,0,0},
    }},
    gravity = {0,0,-9.80665},
    forces = function(s, accumulator, input, contacts, stage)
        accumulator:worldWrench("chassis", {input.thrust or 0,0,0})
    end,
})
local clock = Fixed.new(solver, 96)
clock:advance(1/60, {thrust=500}, {})
local flat = solver:pack()
local saved = clock:checkpoint()
clock:advance(1/60, {thrust=500}, {})
clock:restore(saved)
```

No Studio, requeira os ModuleScripts de `ReplicatedStorage.NR2003Lab.Core`. O solver sem `records` usa os 16 registros recuperados; sem fornecedor de forças ele não inventa pneu, motor ou setup. `massOverrides` aceita uma tabela por nome de componente com `mass` e/ou `inertia`. `state` recebe o vetor plano inicial, conforme `layout.entries`. Entradas prescritas usam `input.prescribed[nome]=coordenada` (m ou rad).

| Método/campo | Contrato |
|---|---|
| `Solver.new(options)` | Monta grafo, geometria, forças iniciais e snapshot de integração |
| `solver:step(input, contacts)` | Avança exatamente um passo e devolve vetor de estados |
| `solver:pack()` | Copia o vetor segundo o layout, com índices Lua a partir de 1 |
| `solver.state.components[nome]` | Pose, velocidades, momento, forças e referenciais do componente |
| `solver.layout.entries` | Índice, componente, campo, eixo, semântica e offset original |
| `solver:checkpoint()` / `:restore(c)` | Salva/restaura estado e campos derivados do solver |
| `Fixed.new(solver, maxSteps)` | Agenda passos; limite padrão de 96 por chamada |
| `clock:advance(elapsed, inputProvider, contactProvider)` | Aceita tabelas ou callbacks `(tick, solver)`; devolve passos e saldo em unidades de passo |
| `clock:checkpoint()` | Inclui o saldo de tempo e o checkpoint do solver |

A agenda usa 1/288 s de tempo externo. As equações usam `float32(1/288)` = 0,0034722222480922937 e `float32(1/576)` = 0,0017361111240461469. Tempo além do orçamento permanece no acumulador; não é descartado silenciosamente. O loop pode consumir o saldo numa chamada posterior, inclusive com `elapsed=0`.

## Integração, forças e estado externo

A sequência é predictor → solução de restrições → avaliação de forças → corrector → solução → avaliação de forças → commit. Não é um RK4 introduzido por conveniência. O callback `forces(solver, accumulator, input, contacts, stage)` roda nos estágios `initial`, `predictor` e `corrector`. O callback opcional `drivetrain(solver, accumulator, input, stage)` roda antes de gravidade/forças.

**Não avance um pneu, motor ou filtro com memória a cada avaliação como se cada chamada fosse um novo tick.** O chamador precisa administrar os snapshots ou fornecer forças sem efeitos colaterais. `CoreChassisBridge` resolve isso no estágio 5: atualiza o adaptador de rodas/motor uma vez por tick e mantém as forças durante predictor/corrector. Essa é uma adaptação explícita da bancada, não a ligação final dos callbacks originais.

O checkpoint do solver não inclui memória de fornecedores externos. Salve-a junto para replay. `CoreChassisBridge:checkpoint()` inclui dinâmica do adaptador, forças mantidas e momentos de alinhamento; `CoreChassisAdapter.runner:checkpoint()` inclui também o acumulador temporal.

| Acumulador | Uso |
|---|---|
| `worldWrench(name, force, torque?, position?)` | Força/torque no mundo numérico; posição acrescenta braço de alavanca |
| `localWrench(name, wrench6)` | Força nos eixos de attachment e torque nos eixos do corpo |
| `gravity(acceleration3)` | Peso por componente |
| `childReaction(name, wrench6)` | Reação oposta no pai pela transformação espacial |
| `jointTorque(name, axis, torque)` | Torque interno no eixo 1, 2 ou 3 e reação |
| `forcePair(a, b, force, position)` | Par de forças opostas no mesmo ponto |

Velocidade local de junta, velocidade total e momento são campos distintos. O momento salvo no commit é `M * totalVelocity`. Não substitua por `M * velocity` numa hierarquia.

## Contatos e transmissão isolados

`NR2003Contact` recebe `hit`, `position`, `normal`, `forward`, `left`, `groundVelocity` em arrays numéricos. As bases devem ser ortonormais e `forward × left = normal`. `applyOutput(acc, name, contact, output)` aplica forças e momento de alinhamento no componente escolhido. `rollingTorque` já deve ter sinal de eixo; `evaluate(...)` resolve o sinal do módulo de resistência retornado pelo pneu a partir de `sample.treadSpeed`.

Essa API usa **left**. O pacote interno de `CoreChassisBridge` usa **right**, seguindo a convenção do adaptador de pneus existente, e faz sua própria conversão. Não intercambie os dois pacotes de contato sem converter os sinais.

`NR2003RecoveredForces` expõe suspensão dianteira, antiroll, eixo traseiro, acoplamento de embreagem/diferencial e freio. Os coeficientes/curvas devem ser fornecidos explicitamente. `NR2003DrivetrainProjection.matrix(p)` e `.apply(solver, accumulator, p)` expõem a projeção recuperada das velocidades de engine/clutch/outshaft/lrwheel/rrwheel e sua reação no chassi. São ferramentas do núcleo testado, não a transmissão ativa do estágio 5.

## Derivadas e cobertura

`solver.derivatives.coordinates` contém taxas das coordenadas; as acelerações são resolvidas pela etapa de momento. `solver.derivatives.discrete` é a diferença média entre estados por passo, sem desembrulhar ângulos, e não uma função contínua `f(t,y)` recuperada do executável.

`recovery/vehicle_core/state_layout.csv` contém as 45 entradas exatas. `components.csv` registra relações, máscaras e propriedades. O baseline é anterior à aplicação completa de setup; `0055e9b0` ainda não está ligado como carregador completo de calibração. O estágio 5 usa um registro de chassi de 13 estados e inércia declarada pelo tune/caixa de teste.
