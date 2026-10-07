# OpenNR2003 para Roblox — Stage 9 (aerodinâmica completa do NR2003 Cup)

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
