# OpenNR2003 para Roblox — Stage 13 (torque de direção / force feedback original do NR2003)

## Aplicar o Stage 13 sobre o Stage 12.1

1. Studio, **fora do Play**, na **Command Bar**, sobre a bancada **Stage 12.1 publicada** (se ainda estiver no Stage 12,
   aplique antes o `PATCH_STAGE12_1.lua`, seção abaixo) — escolha UMA das formas:
   - **Um arquivo**: `PATCH_STAGE13.lua` (~315 KB) inteiro na Command Bar, Enter.
   - **Em partes**: `PATCH_STAGE13_PART1.lua`, `PATCH_STAGE13_PART2.lua` (guardam as fontes em
     `ServerStorage.NR2003Stage13Staging`) e por fim `PATCH_STAGE13_INSTALL.lua`.
   - **Arquivo de modelo**: *Insert from File* → `NR2003_Patch_Stage13.rbxmx`; na Command Bar
     `require(workspace.NR2003_Patch_Stage13)()` e apague o ModuleScript inserido.
2. O instalador confere o Stage 12.1 **módulo por módulo** (tamanho + hash da fonte publicada; recusa base diferente ou
   módulo editado localmente — forçar só com `_G.NR2003_PATCH13_FORCE = true`), faz backup **só** dos 6 módulos que muda em
   `ServerStorage.NR2003Backup_Stage13` (criado uma vez; os 2 módulos novos ficam registrados como `ADDED:`), atualiza a
   fonte **na mesma instância** (`Core.NR2003Cup.NR2003CupDriver`, `Core.NR2003Cup.NR2003CupFrame`, `Core.NR2003CupVehicle`,
   `Core.CupTune`, `Roblox.CupChassisAdapter`, `NR2003Client`), cria `Core.NR2003Cup.NR2003CupFFB` e
   `Roblox.Stage13SelfTest`, roda os auto-testes 6/7..13 e **reverte tudo** se algo falhar. Re-executar é seguro. **O
   place não é salvo**: salve você mesmo. Reverter: `PATCH_STAGE13_ROLLBACK.lua` (volta ao Stage 12.1 e apaga os módulos
   novos).
3. Output esperado: auto-testes 6/7..12, `[NR2003 Stage 13 self-test] 11 PASS, 0 FAIL (… s)` e `Stage 13 aplicado`.
4. **O que é o FFB do NR2003** (código original, `STAGE13_RESULT.md`): por tick, médias das forças dos pneus dianteiros
   (`00554d30`); por quadro, um filtro com latência / amortecimento sobre o momento de alinhamento, escalado pela força e
   pela relação do setup (`00554520`) → **uma força constante −1..1 no eixo de direção** (DirectInput: × 10000). Só existe
   com a direção num **eixo analógico** (gamepad) e o FF ligado; com teclado o NR2003 não gera FFB. Nada volta para a
   física.
5. Padrões da bancada (`Core.CupTune.driver`; atributos do `TestCar` mandam, valem no reset **R**):

| O quê | Padrão | Atributo | Original? |
|---|---|---|---|
| FF ligado | **sim** | `ForceFeedback` (true/false) | sem controls.cfg o NR2003 vem desligado; ligar = o que o controls.cfg faz |
| Força | **80** (valor da imagem) | `ForceFeedbackStrength` (0..100) | sim (mensagem 9) |
| Amortecimento | **0** | `ForceFeedbackDamping` (0..100) | sim (mensagem 10) |
| Latência | **0 ms** | `ForceFeedbackLatency` (0..250) | sim (mensagem 11) |
| Dispositivo FF | **presente** | `ForceFeedbackDevice` (true/false) | ADAPTER: o "dispositivo" é o painel + motores do gamepad |
| Vibração do gamepad | **sim** (|força|) | `CupTune.driver.ffbRumble` | apresentação (o Roblox não tem FFB direcional) |

6. Painel **T**, linha `FFB`: `ativo (eixo)` / `suspenso` / `inativo (teclas / sem dispositivo)`, a força −1..1 e o valor
   DirectInput (`DI`), deslize médio, momento, filtro e as opções. Saída para outros scripts: atributos do `TestCar`
   `FFBForce`, `FFBMagnitude`, `FFBActive`. Sair do carro suspende os controles do jogador (`00550070(1)` original): força
   zero.

---

# Histórico — Stage 12.1 (direção original: trava 360°, relação 12:1, momentum por dispositivo)

## Aplicar o Stage 12.1 sobre o Stage 12

1. Studio, **fora do Play**, na **Command Bar**, sobre a bancada **Stage 12 publicada** (se ainda estiver no Stage 11,
   aplique antes o `PATCH_STAGE12.lua`, seção abaixo) — escolha UMA das formas:
   - **Um arquivo**: `PATCH_STAGE12_1.lua` (~275 KB) inteiro na Command Bar, Enter.
   - **Em partes**: `PATCH_STAGE12_1_PART1.lua`, `PATCH_STAGE12_1_PART2.lua` (guardam as fontes em
     `ServerStorage.NR2003Stage12_1Staging`) e por fim `PATCH_STAGE12_1_INSTALL.lua`.
   - **Arquivo de modelo**: *Insert from File* → `NR2003_Patch_Stage12_1.rbxmx`; na Command Bar
     `require(workspace.NR2003_Patch_Stage12_1)()` e apague o ModuleScript inserido.
2. O instalador confere o Stage 12 **módulo por módulo** (tamanho + hash da fonte publicada; recusa base diferente ou
   módulo editado localmente — forçar só com `_G.NR2003_PATCH12_1_FORCE = true`), faz backup **só** dos 5 módulos que
   muda em `ServerStorage.NR2003Backup_Stage12_1` (criado uma vez), atualiza a fonte **na mesma instância**
   (`Core.NR2003Cup.NR2003CupSteering`, `Core.CupTune`, `Roblox.CupChassisAdapter`, `Roblox.Stage12SelfTest`,
   `NR2003Client`; nada é criado nem apagado), roda os auto-testes 6/7..12 e **reverte tudo** se algo falhar.
   Re-executar é seguro. **O place não é salvo**: salve você mesmo. Reverter: `PATCH_STAGE12_1_ROLLBACK.lua` (volta ao
   Stage 12; para ir ao Stage 11, depois rode `PATCH_STAGE12_ROLLBACK.lua`).
3. Output esperado: auto-testes 6/7..11, `[NR2003 Stage 12 self-test] 17 passed, 0 failed (… s)` e `Stage 12.1 aplicado`.
4. Padrões da bancada (`Core.CupTune.driver`, os atributos do `TestCar` mandam, valem no reset **R**):

| O quê | Padrão | Atributo | Original? |
|---|---|---|---|
| Trava do volante | **360°** (180° por lado) | `SteeringLockDegrees` | 360 = a constante π da cauda de `00551e80` (o NR2003 já é 360° com qualquer relação); outro valor = extensão |
| Relação do setup (item 0x30) | **12:1** | `Setup_steeringRatio` (12..32) | sim: garagem original (o setup do Cup vem com 18); 7:1 abaixo de 32 km/h pelo override original (`SteeringLowSpeedOverride`) |
| Momentum das teclas A/D | taxa da imagem **0,033/quadro** + seno (suave) | `SteeringMomentumKeys` (0..100; **0 = 0 → 100 % instantâneo, como no NR2003 com controls.cfg**) | valores do executável; troca por dispositivo = extensão |
| Momentum do eixo (gamepad / mouse) | **0** (direto, sem rampa e sem seno) | `SteeringMomentumAxis` (0..100) | idem |
| Limite do volante desenhado | **a trava** (±180°) | `CockpitWheelClamp` = `"lock"` / `"original"` (±160°, `005662d0`) | `"original"` = original |

5. Painel **T**, linha `DIREÇÃO (+ = dir.)`: todos os ângulos com + = direita (alvo, cubos, rodas e volante). Parado com
   **A** a fundo: `entrada -1.000  relação 7.0:1  alvo -25.71°  cubos -25.59/-25.84°  rodas ≈ -25.4°  volante -180°`;
   acima de 64 km/h: alvo **-15.00°** (π/12), relação 12.0:1, volante -180°.

Por que as teclas são suaves se no NR2003 elas vão de 0 a 100 %: as duas coisas são o NR2003. Sem controls.cfg o
executável usa a taxa da sua imagem (0,033 por quadro + seno); quem salva os controles no menu grava momentum 0, e aí a
entrada pula de 0 a 100 % num quadro. A física depois da entrada é a mesma cadeia original nos dois casos — muda só o
tempo que a entrada leva para chegar. A bancada deixa as teclas suaves e o eixo direto (o futuro volante por mouse entra
como eixo, como o gamepad); para jogar como o NR2003 com controls.cfg: `SteeringMomentumKeys = 0`.

---

# Histórico — Stage 12 (cadeia de direção original)

## Aplicar o Stage 12 sobre o Stage 11

1. Studio, **fora do Play**, na **Command Bar** — escolha UMA das formas (o resultado é o mesmo):
   - **Um arquivo**: abra `PATCH_STAGE12.lua` (~320 KB), copie o arquivo inteiro, cole na Command Bar, Enter.
   - **Em partes**: cole, em ordem, `PATCH_STAGE12_PART1.lua` e `PATCH_STAGE12_PART2.lua` (cada uma imprime
     `PATCH_STAGE12 parte k/2 guardada`; só guardam as fontes em `ServerStorage.NR2003Stage12Staging`) e por fim
     `PATCH_STAGE12_INSTALL.lua`.
   - **Arquivo de modelo**: *Insert from File* → `NR2003_Patch_Stage12.rbxmx`; depois, na Command Bar:
     `require(workspace.NR2003_Patch_Stage12)()` e apague o ModuleScript inserido.
2. Segurança do instalador: confere a bancada Stage 11 **módulo por módulo** (tamanho + hash da fonte publicada) e recusa
   uma base diferente ou um módulo editado localmente (forçar só com `_G.NR2003_PATCH12_FORCE = true`, por sua conta);
   faz backup **só do que muda** em `ServerStorage.NR2003Backup_Stage12` (criado uma vez, nunca sobrescrito); atualiza a
   fonte **na mesma instância** (nenhuma pasta é substituída, nada fora do pacote é apagado); adiciona
   `Core.NR2003Cup.NR2003CupSteering` e `Roblox.Stage12SelfTest`; muda uma linha em cada self-test 6/7..11; roda os
   auto-testes 6/7..12 e **reverte tudo** se algo falhar. Re-executar é seguro (sem duplicatas). **O place não é salvo**:
   salve você mesmo depois de conferir. Reversão manual verificada: `PATCH_STAGE12_ROLLBACK.lua`.
3. Output esperado: os auto-testes 6/7, 8, 9, 10, 11 e `[NR2003 Stage 12 self-test] 13 passed, 0 failed (… s)`, depois `Stage 12 aplicado`.
4. No Play (painel **T**), linha lilás `DIREÇÃO`: tipo do controle (teclas / eixo), entrada processada (`bf63c8`),
   relação atual (`00554fb0`: 18:1 do setup, 7:1 abaixo de 32 km/h com o override, rampa até 64 km/h), alvo da roda,
   ângulos dos cubos (com toe), guinada medida das rodas e ângulo do volante do cockpit (`005662d0`, limite ±160°).
   Teclado A/D = controles digitais 7/8 (taxa 0,033/quadro + seno); gamepad (analógico esquerdo) = eixo analógico.
   Atributos do `TestCar` (valem no reset **R**): `Setup_steeringRatio` 12..32 (garagem), `SteeringLinearity` 0..100
   (valor do controls.cfg), `SteeringMomentum` 0..100 (0 = sem taxa), `SteeringLowSpeedOverride` true/false. Sem
   atributos = valores da imagem do jogo sem controls.cfg (linearidade 0, taxa 0,033, override ligado).
5. Auto-teste completo: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage12SelfTest).run(true)`. Roteiro manual em
   `VALIDACAO.md` (15 itens); o que foi recuperado em `STAGE12_RECOVERY.md`; cada estado em `STAGE12_STEERING_STATE_MAP.md`.

O que muda no comportamento: o volante virtual e as rodas dianteiras seguem a cadeia ORIGINAL do NR2003 — batente de
±10° na relação 18:1 em velocidade (π / relação), ±25,7° parado (7:1), sensibilidade por velocidade só com linearidade,
expoente de linearidade só com eixo analógico, mesma rampa por tick e toe do original, sem Ackermann nem bump steer
(geometria do multicorpo original). Não portados (recusados): assistência de direção (precisa da linha de corrida da
pista) e o modo de condução arcade. Torque de direção / force feedback é o Stage 13.

---

# Histórico — Stage 11 (térmico / desgaste / dano / combustível)

## Aplicar o Stage 11 sobre o Stage 10

1. Studio, **fora do Play**, na **Command Bar** — escolha UMA das formas (o resultado é o mesmo):
   - **Um arquivo**: abra `PATCH_STAGE11.lua` (~1,6 MB), copie o arquivo inteiro, cole na Command Bar, Enter.
   - **Em partes**: cole, um de cada vez e em ordem, `PATCH_STAGE11_PART1.lua`, `PART2`, `PART3` (cada uma imprime
     `parte k/3 guardada`; só guardam as fontes em `ServerStorage.NR2003Stage11Staging`) e por fim
     `PATCH_STAGE11_INSTALL.lua`. Se o INSTALL falhar, tudo é revertido e basta repetir só o INSTALL.
   - **Arquivo de modelo**: *Insert from File* → `NR2003_Patch_Stage11.rbxmx`; depois, na Command Bar:
     `require(workspace.NR2003_Patch_Stage11)()` e apague o ModuleScript inserido.
2. O patch faz backup em `ServerStorage.NR2003Backup_Stage11_*` (pacote + `NR2003Client`), instala em `Core.NR2003Cup`
   `NR2003CupFrame`, `NR2003CupFrameCode1..4`, `NR2003CupFrameData1` (fim de quadro ORIGINAL do NR2003 erguido do x86),
   troca `NR2003CupDriver`, `Core.NR2003CupVehicle`, `Roblox.CupChassisAdapter`, os self-tests 6/7, 8, 9, 10 (comparam no
   modo `"frozen"`) e o LocalScript `NR2003Client` (linha de HUD), instala `Roblox.Stage11SelfTest`, roda os auto-testes
   6/7, 8, 9, 10 e 11 e **reverte tudo** se algo falhar.
3. Output esperado: `Stage 6/7 self-test: 7 passed`, `Stage 8 self-test: 5 passed`, `Stage 9 self-test: 13 passed`,
   `Stage 10 self-test: 6 passed`, `Stage 11 self-test: 4 passed`, `Stage 11 aplicado`.
4. No Play (painel **T**), linha laranja: combustível (kg), água/óleo (°C), potência, dano do motor, vazamentos, dano de
   carroceria, os 4 pneus (temperatura, psi, desgaste, FURADO) e as temperaturas de freio — tudo lido das células do
   código original. Atributos do `TestCar` (valem no reset **R**): `RaceDamageLevel` 0..3 (0 = sem dano), 
   `RaceConsumptionRate` 0..3 (×1..×4), `RosterSeries`, `RandomSeed`, `Stage11Runtime = "frozen"` (A/B com o Stage 10).
   Testes (a bancada não tem paredes nem pit): `DamageTestImpact = <magnitude>` (registro de colisão original no
   para-choque), `PitTyresTest = true` (troca dos 4 pneus pelo `00550f10` original).
5. Auto-teste completo: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage11SelfTest).run(true)`. Roteiro manual em
   `VALIDACAO.md`; o que foi recuperado em `STAGE11_RECOVERY.md`.

O que muda no comportamento: o carro gasta combustível (fica mais leve: a massa do combustível é um componente do
multibody), aquece água/óleo/pneus/freios, desgasta os pneus (aderência = 1 − 0,2·desgaste; estouro raro acima de 66 %),
pode ter falhas aleatórias de componentes e sofre dano de colisão — exatamente o fim de quadro do NR2003. O executável não
tem fade de freio nem geometria de suspensão dependente de dano; esses efeitos não existem no port.

---

# Histórico — Stage 10 (setup completo da garagem → parâmetros de tempo de execução)

## Aplicar o Stage 10 sobre o Stage 9

1. Studio, **fora do Play**, na **Command Bar** — escolha UMA das formas (o resultado é o mesmo):
   - **Um arquivo**: abra `PATCH_STAGE10.lua` (~2,1 MB), copie o arquivo inteiro, cole na Command Bar, Enter.
   - **Em partes** (se a Command Bar não aceitar o arquivo grande): cole, um de cada vez e em ordem,
     `PATCH_STAGE10_PART1.lua`, `PART2`, `PART3`, `PART4` (cada uma imprime `parte k/4 guardada`; só guardam as fontes em
     `ServerStorage.NR2003Stage10Staging`, o jogo não muda) e por fim `PATCH_STAGE10_INSTALL.lua`, que confere as
     partes e instala. Se o INSTALL falhar, tudo é revertido e basta repetir só o INSTALL.
   - **Arquivo de modelo**: *Insert from File* → `NR2003_Patch_Stage10.rbxmx`; depois, na Command Bar:
     `require(workspace.NR2003_Patch_Stage10)()` e apague o ModuleScript inserido.
2. O patch faz backup em `ServerStorage.NR2003Backup_Stage10_*`, instala em `Core.NR2003Cup` os módulos novos
   (`NR2003CupSetupData`, `NR2003CupSetup`, `NR2003CupBuild`, `NR2003CupBuildCode1..6`, `NR2003CupBuildData1..2`,
   `NR2003CupJITG1..4`, `NR2003CupGarage`), troca `NR2003CupCore` (só exportações do host), `NR2003CupDriver`,
   `Core.NR2003CupVehicle`, `Roblox.CupChassisAdapter` e instala `Roblox.Stage10SelfTest`. Roda os auto-testes 6/7, 8, 9 e
   10 e **reverte tudo** se algo falhar. Imagem e callbacks do 6/7, aero, servidor e cliente não mudam.
3. Output esperado: `Stage 6/7 self-test: 7 passed`, `Stage 8 self-test: 5 passed`, `Stage 9 self-test: 13 passed`,
   `Stage 10 self-test: 6 passed`, `Stage 10 aplicado`. No Play, uma linha por setup aplicado:
   `[NR2003 Stage 10] setup aplicado (image, 0.00 s): molas -71344/-71344/-41092/-41092 N/m, freio 2812/988 N*m, ...`.
4. **Setup**: atributos numéricos no `Workspace.NR2003LabWorld.TestCar` com o nome do item (`SETUP_MAP.md`) em unidades da
   garagem do NR2003: `Setup_springLF` (lb/pol), `Setup_shockBumpRF` (1..9), `Setup_camberLF` (graus), `Setup_casterRF`,
   `Setup_toeFront` (pol), `Setup_rideHeightLR` (pol), `Setup_trackBarRR` (pol), `Setup_wedge` (lb),
   `Setup_ballastFrontRear` (lb), `Setup_tirePressureRF` (psi), `Setup_swayBarFrontIndex`, `Setup_gearChoice1..4`,
   `Setup_finalDriveChoice`, `Setup_brakeBias` (%), `Setup_grilleTape` (%), `Setup_spoilerAngle` (graus), `Setup_fuel`
   (gal)... Valem ao reiniciar (**R**) ou no próximo Play: cada valor passa pela função original da garagem (`005581d0`:
   grade do passo + limites) e o carro é **reconstruído pelo build original** (~0,2–0,5 s). `SetupStructure`
   (`image`/`natural`/`generic`), `SetupApplySeconds` e `SetupError` mostram o resultado. Os atributos antigos
   `SetupBrakeBias`, `SetupGrilleTape`, `SetupSpoiler` continuam valendo.
5. Auto-teste completo: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage10SelfTest).run(true)`.

O que muda no comportamento: sem atributos `Setup_*` nada muda (o padrão restaura a imagem entregue bit a bit). Com um
setup, todos os parâmetros que o NR2003 deriva dele (taxas de mola na roda, batentes, curvas de amortecimento, barras,
perches/alturas, camber/caster/toe nos cubos, track bar, lastro, pesos de canto, alturas de referência do aero, relações de
marcha e diferencial, Kb do freio, pressão dos pneus) vêm do próprio build original. Limites: pit stop em corrida não
portado; relação de direção armazenada mas a cadeia de direção é do Stage 12; térmica/desgaste/combustível do Stage 11.

---

# Histórico — Stage 9 (aerodinâmica completa do NR2003 Cup)

## Aplicar o Stage 9 sobre o Stage 8 validado

1. Studio, **fora do Play**. Abra `PATCH_STAGE9.lua`, copie o arquivo inteiro e cole na **Command Bar**. Enter.
   - Alternativa: *Insert from File* → `NR2003_Patch_Stage9.rbxmx`; depois, na Command Bar: `require(workspace.NR2003_Patch_Stage9)()` e apague o ModuleScript inserido.
2. O patch faz backup em `ServerStorage.NR2003Backup_Stage9_*`, instala `Core.NR2003Cup.NR2003CupAero` (novo), troca `Core.NR2003Cup.NR2003CupDriver`, `Core.NR2003CupVehicle`, `Roblox.CupChassisAdapter`, instala `Roblox.Stage9SelfTest` e atualiza o `NR2003Client` (HUD, linha AERO). Roda os auto-testes 6/7, 8 e 9 e **reverte tudo** se algo falhar. Servidor, módulos gerados do 6/7 (Core/Image/JIT) e auto-testes 6/7 e 8 não mudam.
3. Output esperado: `Stage 6/7 self-test: 7 passed, 0 failed`, `Stage 8 self-test: 5 passed, 0 failed`, `Stage 9 self-test: 13 passed, 0 failed` e `Stage 9 aplicado`. No Play, uma linha por sessão: `[NR2003 Stage 9] sessão: 70 F ... rho 1.081192 kg/m3 ...`.
4. Play → **F** → **T** (painel): a linha **AERO** mostra densidade, q, arrasto, downforce (D/T), fatores, altura dianteira, fita, aerofólio e yaw — o `00561b70` original avaliado no estado atual.
5. Atributos no `Workspace.NR2003LabWorld.TestCar` (valem ao reiniciar **R** ou no próximo Play): `WeatherTemperatureF` (40..110), `WeatherWindMph` (0..30), `WeatherWindDirection` (0..7, passos de 45°), `WeatherConditions` (0..3), `WeatherNight` (bool), `TrackNorth` (rad), `SetupGrilleTape` (0..100 %, passo 5), `SetupSpoiler` (45..70°), `AeroSession = false` (estado pós-build sem ar, para comparação A/B), `DraftTestGap` / `DraftTestLateral` (m; **somente teste**: carro fantasma à frente para exercitar o vácuo original — não é recurso do NR2003).
6. Auto-teste completo: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage9SelfTest).run(true)`.

O que muda no comportamento (tudo vindo do código original): até o Stage 8 o núcleo rodava **sem ar** (o build do carro não carrega o clima da sessão: ρ = 0 e fatores 0, portanto nenhuma força aero). Agora a sessão aplica ρ = 1,0812 kg/m³ (70 °F, sol, dia) e fatores 1,0: a ~75 m/s o carro tem ~3,2 kN de arrasto e ~3,2 kN de downforce, a velocidade máxima cai de 75,6 para 74,75 m/s (abaixo do limitador), o carro abaixa ~15 mm, a frenagem a alta velocidade é mais forte no começo e a curva rápida tem mais carga nos pneus. Em derrapagem forte (yaw > ~45°) a sustentação vira para cima (perda de aderência/levantamento, comportamento do próprio NR2003).

---

# Histórico — Stage 8 (modelo de freio completo do NR2003 Cup)

## Aplicar o Stage 8 sobre o Stage 6/7 validado

1. Studio, **fora do Play**. Abra `PATCH_STAGE8.lua`, copie o arquivo inteiro e cole na **Command Bar**. Enter.
   - Alternativa: *Insert from File* → `NR2003_Patch_Stage8.rbxmx`; depois, na Command Bar: `require(workspace.NR2003_Patch_Stage8)()` e apague o ModuleScript inserido.
2. O patch faz backup em `ServerStorage.NR2003Backup_Stage8_*`, troca só `Core.NR2003Cup.NR2003CupDriver`, `Core.NR2003CupVehicle`, `Roblox.CupChassisAdapter`, instala `Roblox.Stage8SelfTest` e atualiza o `NR2003Client` (HUD). Roda os auto-testes 6/7 e 8 e **reverte tudo** se algo falhar. Servidor e módulos gerados do 6/7 não mudam.
3. Output esperado: `Stage 6/7 self-test: 7 passed, 0 failed`, `Stage 8 self-test: 5 passed, 0 failed` e `Stage 8 aplicado`.
4. Play → **F** entra. **S** freia (tecla = ligação digital do NR2003: o pedal sobe 1/12 por quadro, ~0,33 s até 100 %). Parado e sem acelerar, o próprio jogo segura o carro (hold automático).
5. Viés de freio (garagem): atributo numérico `SetupBrakeBias` no `Workspace.NR2003LabWorld.TestCar` (50..90 = % dianteiro; sem atributo = 74, padrão Cup). Vale ao reiniciar (**R**) ou no próximo Play.
6. Auto-teste completo: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage8SelfTest).run(true)`.

O que mudou no comportamento (tudo vindo do código original): rampa da tecla de freio; hold automático parado; carro vazio fica freado (pedal 1,0); com 74 % o freio satura nas rodas sem travar (desaceleração ~1,3 g a 30 m/s); com viés alto as dianteiras travam, com viés baixo trava a traseira. Não há fade nem ABS no NR2003 original.

---

# Histórico — Stages 6 + 7 (núcleo original NR2003 Cup)

## Aplicar os estágios 6 + 7 sobre o Stage 5 validado

1. Studio, **fora do Play**. Abra `PATCH_STAGE6_7.lua`, copie o arquivo inteiro e cole na **Command Bar**. Enter.
   - Alternativa: *Insert from File* → `NR2003_Patch_Stage6_7.rbxmx`; depois, na Command Bar: `require(workspace.NR2003_Patch_Stage6_7)()` e apague o ModuleScript inserido.
2. O patch faz backup completo em `ServerStorage.NR2003Backup_Stage67_*`, instala `Core.NR2003Cup` + módulos novos, atualiza `NR2003Server`/`NR2003Client`, roda o auto-teste e **reverte tudo** se algo falhar.
3. Output esperado: `Stage 6/7 self-test: 7 passed, 0 failed` e `Stage 6/7 aplicado`.
4. Play → **F** entra. **E/Q** marchas (começa em N), **W/S** acelerador/freio, **A/D** direção, **Shift** embreagem, **R** reinicia.
5. Para voltar: `NR2003Lab.Roblox.ModeConfig` → `mode="NR2003_CORE"` (estágio 5) ou `"ROBLOX_ADAPTER"`.
6. Auto-teste completo a qualquer momento: `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage67SelfTest).run(true)`.

Instalação do zero: rode `INSTALL_STUDIO.lua` (Stage 5) e depois `PATCH_STAGE6_7.lua`.

---

# Histórico — Stage 5 estabilizado

Versão de pacote **3.5.2-stage5-validated**. O Stage 5 está **estabilizado e validado em Play**. Os Stages 6 e 7 ainda não foram implementados; são a próxima dupla autorizada do roadmap. Inclui os fontes Lua/Luau, um carro gerado com Parts, tune experimental, pista, volante, cockpit, testes e patch para a instalação anterior.

O modo padrão `NR2003_CORE` já é dirigível: o integrador numérico recuperado calcula posição e orientação do chassi; o Roblox fornece os contatos e recebe os CFrames. Nesse modo são integrados **13 estados do chassi**, com forças de rodas, suspensão e transmissão fornecidas pelo adaptador da bancada. O núcleo multibody de **16 componentes e 45 estados** também está no pacote e tem testes independentes; a ligação de todo esse conjunto ao carro em Play fica para os próximos estágios. Isso ainda não estabelece equivalência do carro completo com o NR2003.


### Correção PRE-STAGE-6 de suavidade

O servidor continua autoritativo e o solver continua a 288 Hz. O efeito visual de ~20–30 Hz vinha do cliente observar diretamente `PivotTo()` replicado. Agora o servidor publica snapshots visuais compactos via `UnreliableRemoteEvent` e o cliente interpola chassi, rodas, suspensão, volante e cockpit no refresh de render. **H** mostra o diagnóstico de render. Isso é apresentação somente; não há prediction/reconciliation e nenhum Stage 14 foi antecipado.

## Atualizar o carro que você já tem

1. Pare o Play no Roblox Studio.
2. Abra `PATCH_STAGE5.lua`, copie **todo o conteúdo** e execute na **Command Bar**.
3. Aguarde a mensagem `Estágio 5 aplicado` no Output.
4. Inicie Play, aproxime-se do banco e pressione **F**. Use **W/S** e **A/D**; **V** alterna as câmeras.

O patch substitui os scripts, corrige a montagem do banco e acrescenta o cockpit/volante. Preserva o código do seu `Core.TestTune`, o carro, meshes importadas e a pista. O modo passa a `NR2003_CORE`. É criado um backup do pacote, scripts e uma cópia do carro em `ServerStorage.NR2003Backup_<data>_<sufixo>`; se houver erro na aplicação, o patch tenta restaurar a instalação anterior.

Alternativa: insira `NR2003_Patch_Stage5.rbxmx` no Workspace por **Insert from File** e execute, com Play parado:

```lua
require(workspace.NR2003_Patch_Stage5)()
```

Use uma das duas formas de patch. Não precisa apagar a instalação anterior nem executar o instalador novo por cima dela.

## Instalar do zero

Em um Baseplate separado, com Play parado, copie todo `INSTALL_STUDIO.lua` para a Command Bar e execute. Ele gera carro e pista no editor. Também pode inserir `NR2003_Install.rbxmx` e executar:

```lua
require(workspace.NR2003_Install)()
```

O instalador interrompe se encontrar a instalação anterior; nesse caso use o patch. O projeto `default.project.json` contém os mesmos fontes para Rojo. Nessa opção, o servidor cria carro e pista quando necessário ao iniciar.

## Controles

| Tecla | Ação |
|---|---|
| F | Entrar no banco; prompt e pedido do cliente usam a validação do servidor |
| W / seta para cima | Acelerar |
| S / seta para baixo | Frear |
| A / D ou setas laterais | Direção |
| E / Q | Subir / descer marcha |
| Shift esquerdo | Desacoplar embreagem |
| Espaço | Freio de mão traseiro |
| X | Sair |
| R | Reposicionar e zerar a simulação |
| G | Mostrar raios de contato |
| T | Expandir/recolher painel |
| H | Mostrar/ocultar diagnóstico de snapshots/interpolação |
| V | Acompanhamento → cockpit → câmera padrão |

Começa em 1ª. Para ré, pare e pressione Q duas vezes, respeitando o intervalo de troca: **1 → N → R**. Há embreagem automática de arrancada e auxílio de marcha lenta; as trocas são manuais. O cliente envia comandos, e o servidor executa os cálculos.

## Banco, volante e diagnóstico

A união permanente banco–chassi agora se chama `DriverSeatMount`; `SeatWeld` fica reservado à união criada pelo Roblox para o avatar. A entrada confirma `VehicleSeat.Occupant`, repete `Sit` por até 3,5 s e informa motivos de recusa. O patch só renomeia a união banco–chassi, preservando a união do avatar.

O volante tem coluna, aro, raios e Motor6D; acompanha o ângulo central das rodas dianteiras pela relação configurada em `Roblox.DriverConfig.steeringRatio` (12 por padrão). A câmera de cockpit tem Attachment próprio. **A direção ainda é a da bancada**: não inclui todo o sistema de direção e force feedback do NR2003.

Se F não funcionar, veja a mensagem na tela, o Output e os atributos do carro `EntryHandlerReady`, `EntryStatus`, `DriverUserId` e `PhysicsFault`. Para executar o diagnóstico:

```lua
local package = game.ReplicatedStorage.NR2003Lab
local car = workspace.NR2003LabWorld.TestCar
local report = require(package.Roblox.Diagnostics).run(car)
print(report)
```

## Modos de física

Edite `ReplicatedStorage.NR2003Lab.Roblox.ModeConfig` com Play parado:

| Modo | Quem integra o chassi | Contato do corpo |
|---|---|---|
| `NR2003_CORE` (padrão) | Núcleo numérico a 288 Hz; CFrame aplicado por `PivotTo` | Varredura de caixa (`Blockcast`) e projeção da velocidade |
| `ROBLOX_ADAPTER` | Solver do Roblox recebe impulsos do adaptador anterior | Colisão nativa do chassi |

No modo numérico, o controlador **ancora intencionalmente o Chassis** durante Play e desativa sua colisão nativa. `NR2003CorePoseOwner` indica essa propriedade; o banco aceita entrada nesse modo. Não altere manualmente essa ancoragem durante o teste. As peças visuais continuam sem massa/colisão adicional. No modo anterior, o chassi fica desancorado.

O corpo numérico usa massa do tune e inércia de caixa, ou `coreChassis.inertia={Ix,Iy,Iz}` em kg·m² nos eixos do núcleo. A varredura protege deslocamentos de translação; ainda não resolve sobreposição inicial, penetração causada apenas por rotação, colisão completa entre carros ou dano. Superfícies móveis fornecem velocidade relativa, mas não recebem a reação física do chassi numérico.

## Gerador, posições e tune

O gerador monta **146 BaseParts conectadas**: chassi, banco, carroceria, gaiola, visuais de motor/transmissão/diferencial, quatro rodas, cubos, aros, braços, amortecedores, molas, volante e coluna. Cada canto tem mount de suspensão, eixo da roda e marcador de contato. `SuspensionMotor.C0` dá curso/esterçamento e `SpinMotor.C0` dá giro. Os CFrames vêm do tune.

| Referência | Convenção |
|---|---|
| Carro no Roblox | frente −Z; direita +X; cima +Y |
| Núcleo numérico | frente +X; esquerda +Y; cima +Z |
| Eixo local da roda | +X no Roblox |
| Escala | 1 stud = 0,28 m |
| Diâmetro / largura do pneu | 0,70 m / 0,30 m |
| Entre-eixos do tune | 2,79 m |

O tune `Core.TestTune` usa **1.500 kg, RWD, quatro marchas e pico de 380 Nm**, como parâmetros de teste. `Tune_Test_Recovered` e os registros de 16 componentes preservam um baseline estrutural separado, anterior à aplicação completa de setup do original.

Edite `TestTune` e reinicie Play para aplicar. Geometria exige também regenerar o carro: por exemplo, remova somente `Workspace.NR2003LabWorld.TestCar` com Play parado, mantendo seus assets de origem, para o servidor recriá-lo no próximo Play. `mass`, `chassisSize`, bitolas, `frontZ`/`rearZ`, `wheelRadius`, suspensão, pneus, motor, freios e aero são configuráveis. O patch mantém seu tune existente.

As molas e braços visuais representam o estado calculado; não são SpringConstraints concorrentes. O contato usa um raycast por roda. A ligação ao multibody completo das massas não suspensas ainda está fora deste estágio.

## Colocar MeshParts depois

Crie um Model `MeuModelo` com filhos `Body`, `FL`, `FR`, `RL`, `RR`; cada filho pode ser Model ou MeshPart. O pivot de `Body` deve ser o referencial do chassi; o de cada roda deve estar no centro, com eixo local +X. Dimensione os assets de acordo com o tune. Com Play parado:

```lua
local package = game.ReplicatedStorage.NR2003Lab
local car = workspace.NR2003LabWorld.TestCar
local count = require(package.Roblox.MeshAdapter).install(car, workspace.MeuModelo)
print("Peças visuais instaladas:", count)
```

O importador clona os assets, remove scripts e constraints das cópias, cria welds e desativa massa/colisão adicional. A origem é preservada. Os atributos Vector3 `MountOffsetStuds` e `MountRotationDegrees` corrigem a montagem antes de importar. Preserve `Chassis`, `DriverSeat`, mounts, eixos e motores da bancada; eles continuam sendo as referências físicas.

A pista precisa de colliders contínuos, na escala correta, com `CanCollide=true`. Os atributos opcionais `NRSurface` (1 asfalto, 2 concreto, 3 zebra, 5 grama, 6 terra, 7 areia, 8 cascalho) e `NRGripMultiplier` selecionam material e aderência. O contato consulta a colisão Roblox, não necessariamente o triângulo visual da malha.

## Primeiro carro de referência: NASCAR/Cup NR2003

O primeiro carro alvo do jogo será o **NASCAR/Cup car do próprio NR2003**. Isso significa que o objetivo não é criar um tune genérico Roblox. `Core.TestTune` continua sendo apenas a configuração provisória da bancada enquanto os dados originais ainda não foram ligados ao runtime.

A partir dos Stages 6 e 7, qualquer massa, inércia, geometria, spring/damper, wheel/tire, engine, clutch, gearing, differential, axle ou outro parâmetro relevante deve usar os valores originais do NASCAR do NR2003 quando recuperados/confirmados. Quando o baseline atual não for suficiente, a implementação deve rastrear o projeto Ghidra/original em vez de inventar números.

## Resultado e limites

Passaram 14.008 comparações com rotinas x86 originais em cenários controlados, 59 verificações do núcleo, 59 do Stage 5, 36 da camada de snapshot/interpolação, 14 de entrada e as regressões anteriores. **Play no Roblox Studio foi executado e aprovado manualmente em 2026-10-04**: o carro ficou visualmente suave e os efeitos físicos de suspensão ficaram mais perceptíveis. Confira `VALIDACAO.md` e `tests/RESULTS.txt`. `STAGE_RESULT.md` delimita a entrega, `CORE_API.md` explica a API e `PORT_MAP.md` registra origem e pendências.
