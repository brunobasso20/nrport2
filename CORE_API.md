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
