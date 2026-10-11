# Stage 12 — cadeia de direção original do NR2003 Cup

**Resumo:** a cadeia de direção do carro do jogador no NR2003 foi recuperada inteira (Ghidra + execução do código
original no Unicorn) e **portada à mão do x86 para Luau** (`core/NR2003Cup/NR2003CupSteering.lua` + linhas do Stage 12 em
`NR2003CupDriver.lua`), rodando sobre a memória do núcleo: controles brutos 7 (esquerda) / 8 (direita) → `00552d00`
(limite de taxa por quadro + seno) → `00552720` (entrada processada; sensibilidade por velocidade só pela linearidade) →
cauda de `00551e80` (expoente de linearidade com eixos analógicos, × π, ÷ relação `00554fb0` = item de setup 0x30 com
override 7:1 de baixa velocidade) → rampa por tick + toe (`005539c0`) → coordenadas prescritas dos cubos (estados 15/21)
→ multicorpo original. O volante do cockpit é a fórmula original `005662d0`. Nenhum Ackermann, batente, multiplicador de
velocidade ou curva foi inventado: o executável não tem Ackermann, bump steer nem taxa de esterço.

| Escopo | Entregue |
|---|---|
| Recuperado | ordem por quadro / por tick (`STAGE12_RECOVERY.md` §2), 20+ funções (§3), mapa de estados (`STAGE12_STEERING_STATE_MAP.md`), achados (§4): dois controles; linearidade só com eixos analógicos; sensibilidade por velocidade só via linearidade; batente π/relação; override 7:1 ≤ 8,94 m/s com rampa até 17,88 m/s; geometria sem Ackermann / bump steer / taxa; bit 25 = modo ARCADE; assistência = linha de corrida da pista; itens 0x3a / 0x9f..0xa4 = diferencial (correção no `SETUP_MAP.md`); FFB não lê a direção |
| Portado (original) | `005524f0` (ramo do jogador / não dirigido), `00552d00` (Stage 8, reutilizado), `00552720`, `00552410`, `00550230`, `0055a770`, `00554f50`, cauda de `00551e80` + `005524b0`, `00554fb0`, setters `005502f0` / `005500c0` / `00550110` / `00550210` + conversão do controls.cfg, `005662d0` |
| Host (ADAPTER, igual no port e na referência) | camada de dispositivos `0057abc0` (controles 7/8, tipo de vínculo; eixo separado pelo sinal); calibração do joystick substituída pela normalização do Roblox |
| Recusado em produção (NOT PORTED) | assistência de direção > 0 (linha de corrida da pista); modo ARCADE (troca o chassi no build `004233a0`) |
| Mudanças em estágios anteriores | `NR2003CupDriver` (alvo da cauda original; C1), `NR2003CupVehicle` (instala a direção), suítes e self-tests 6/7–11 (uma linha: modo `"provisional"`) |
| Roblox | teclas / gamepad → controles; atributos `SteeringLinearity`, `SteeringMomentum`, `SteeringLowSpeedOverride` (+ `Setup_steeringRatio`); volante do cockpit = ângulo original; telemetria e linha `DIREÇÃO` no painel T |
| Entrega | `PATCH_STAGE12.lua` (ou `PART1..2` + `INSTALL`), `NR2003_Patch_Stage12.rbxmx`, `PATCH_STAGE12_ROLLBACK.lua`, `Stage12SelfTest`, relatórios `STAGE12_*.md`, harness / cenários / fixtures do código original, evidências |

## Números do Cup (original)

Relação de setup 18:1 (garagem 12..32). Batente com entrada total: π/18 = 0,1745 rad (10,0°) acima de 17,88 m/s
(64,4 km/h); π/7 = 0,4488 rad (25,7°) até 8,94 m/s (32,2 km/h) com o override (padrão ligado); entre os dois, relação
`r − (17,88 − v)·(r − 7)·0,111856826`. Toe por lado 0,00224 rad (item 0x29 · 0,5). Taxa padrão 0,033 por quadro
(~0,85 s de 0 a 1), × 2,5 abaixo de 0,025; momentum m: `(1/(m·0,01))·0,016663…` (0 = sem limite, sem seno).
Sensibilidade `(1 − 0,15 L) + 0,15 L·exp(−0,000493827 v²)` (L = 0 sem controls.cfg). Eixo de esterço: caster 2,455°,
inclinação 9,215°; guinada da roda ≈ 0,99 × ângulo do cubo; LF−RF 0,0076 → 0,0069 rad (anti-Ackermann leve). Volante:
`−(relação · ângulo médio dos cubos)` limitado a ±2,79 rad (±160°).

## Classificação de fidelidade

| Classe | Itens |
|---|---|
| **EXACT ORIGINAL** (bit a bit contra o original executado) | `00552d00`, `00552720` (ramos simulação e arcade), `00552410`, `00550230`, `00554f50`, cauda de `00551e80` (linearidade `_CIpow`, × π, ÷ relação, alvo, rampas, sinal de zero), `00554fb0`, setters e conversão do controls.cfg, ramo "não dirigido" de `005524f0` |
| **RECOVERED AND VALIDATED** (acoplamento com a física herdada, no envelope do próprio original) | rampa por tick + toe → cubos → multicorpo → pneus (L3 47 reinícios, L4 771 linhas em 10 cenários) |
| **ORIGINAL LOGIC WITH DOCUMENTED NUMERIC DIFFERENCE** | valores x87 entregues adiante em double (≤ 1 ulp double observado; os f32 gravados são idênticos); `_CIpow` = `x ^ y` (idêntico nos 2100 vetores); D3 cancelamento `a8 − a7` (≤ 4·2⁻⁵³), D5 soma de quadrados de `00554f50` (raro); física por tick herdada dos Stages 6–11 (1–4 ulp por quadro) → horizonte documentado `notdriven` 297 |
| **ROBLOX ADAPTER** | camada de dispositivos (`0057abc0`), normalização do eixo do gamepad (no lugar de `005d04d0`), atributos, ângulo do volante na apresentação (`Cockpit.updateAngle`, render snapshot), telemetria |
| **PROVISIONAL** | modo de direção `"provisional"` (só para as suítes de regressão 6–11, nunca em produção) |
| **NOT RECOVERED / NOT PORTED** | assistência de direção > 0 (linha de corrida), especificação de chassi do modo arcade (`004233a0` → spec `8945b8`), replay/rede (`005beac0`), FFB / torque (Stage 13) |

## Fidelidade e validação (automática)

Referência: o código original executado no Unicorn com a mesma fronteira de host (`recovery/stage12/orig_stage12.py`).
Suíte `tests/stage12/run.luau`: **47/47 PASS** (`tests/stage12/RESULTS_STAGE12.txt`; método em `STAGE12_VALIDATION.md`).

- **L1 funções**: 1212 + 3872 + 400 quadros + 192 + 2100 + 215 vetores; todos os f32 gravados bit a bit (exceto 6 quadros de
  cancelamento `a8 − a7` dentro de 4·2⁻⁵³, D3).
- **L2 início de quadro**: 1481 snapshots rastreados do original em 10 cenários, 174 384 dwords, **100 % bit a bit**, nenhuma
  escrita extra do Luau.
- **L3 reinícios**: 47 reinícios de estado completo, 0 células / 0 campos fora de 4× a sensibilidade de um quadro do
  original (12 gêmeos).
- **L4 malha fechada**: 10 cenários, 194 s, 771 linhas × 35 campos dentro de 4× o envelope de 14 gêmeos do original;
  horizonte documentado `notdriven` 297 provado pelo reinício reverso (o código original continuado do estado do port
  segue o ramo do port). O primeiro `brakesteer` (arrancada a fundo em que o próprio original roda antes de qualquer
  direção) foi substituído por um cenário estável — detalhes em `STAGE12_VALIDATION.md` §4.
- **L5**: 5 erros deliberados de mapeamento detectados por L2 e por L3.
- Determinismo / checkpoint bit a bit. Regressão 6/7 16/16, 8 49/49, 9 59/59, 10 23/23 + 61/61, 11 66/66; adaptador sob
  mock 65/65; patch 12 em DataModel simulado 19/19; patches 6/7–11 inalterados.

## Registro de mudança C1 (correção com escopo, código validado dos Stages 7/11)

**O quê:** as somas de composição por tick de `005539c0` (`bf6ea4`, `bf63c0`, `bf6360`, `bf6364`, `bf636c` e a embreagem
`bf6e14 / bf6370`, `@00553a40..00553ab5`) e as rampas da cauda de `00551e80` (`bf6e88`, `bf6394`, `bf6358`, `bf6e50`) passam
a dar **−0** quando o resultado é exatamente zero e o x87 com RC = para baixo dá −0 (`zadd` / `zsub`). **Por quê:** no
L2 o original grava −0 nas rampas da cauda em repouso (`x − x = −0` com arredondamento para −∞) e a aritmética antiga do
port gravava +0: 4554 dwords nos 1481 snapshots, todos −0/+0 — 4246 nas rampas de pedal `bf6394` / `bf6358` / `bf6e50` (445
em `keys`) e 308 na rampa de direção `bf6e88` (83 em `keys`). As somas por tick de `005539c0` (`bf63c0` etc.) não são
executadas pelo L2; o efeito delas aparece só no L3 (células a mais dentro da tolerância, p. ex. `keys` 3301 → 3281). **Efeito:** só o sinal de zeros exatos muda (nenhum valor diferente de zero); as rampas no
modo `"provisional"` mantêm a aritmética antiga (`plainSub`), para que as fixtures dos Stages 6–11 continuem válidas.
**Verificação:** L2 100 % bit a bit depois da correção; regressões 6/7–11 inalteradas (mesmas contagens do baseline).

## Registro de mudança C2 (correção com escopo do port do Stage 8 de `00552d00`, eixos de direção)

Achado pela revisão independente do port contra o x86 executado **no hardware** (`recovery/stage12/evidence/reports/verify-input.md`):
(1) um passo de taxa que dá exatamente zero (`estado − taxa·2,5 = 0` com entrada 0) é −0 com RC = para baixo — o port
gravava +0 (`zsub` agora, como em C1; o caso exige momentum em que `2,5·taxa` é exato, nunca a taxa padrão 0,033);
(2) com estado exatamente 1,0 (tecla segurada / batente analógico com taxa < 1) o `FSIN` do x87 com RC = para baixo devolve
`1 − 2⁻⁶⁴` (valor verdadeiro `1 − 4,5e−25`, arredondado corretamente para baixo), gravado como `3f7fffff`; o `sin` em double
dá 1,0. O port usa `1 − 2⁻⁵³`, que reproduz todo resultado gravado (direita a fundo: entrada `0,99999994`; as duas teclas a
fundo: `−2⁻²⁴` = `b3800000`). Varredura exaustiva (revisão): nenhum outro estado f32 muda o f32 gravado. O Unicorn calcula
`FSIN` com o `sin` do host e dava 1,0: a referência recebeu uma correção pontual equivalente ao hardware (gancho em
`orig_stage12._fsin_fix`, armado no `FSIN` de `00552dd4`), e as fixtures foram regeneradas. **Efeito:** batente à direita
1 ulp de f32 menor que à esquerda, como no jogo original; nenhum outro valor muda.

## Diferenças numéricas documentadas (convenção double dos Stages 6/7, sem mudança de lógica)

- **D3** — quando os dois controles estão ativos e `a8 − a7` se cancela, o resultado expõe os últimos bits do `FSIN`
  estendido: até `4·2⁻⁵³` absoluto (a mesma tolerância de 4 ulp double dos valores x87 do L1); medido: 6 de 44 quadros de
  cancelamento da sequência de teclas; entre hardware e Unicorn esses bits também diferem.
- **D5** — `00554f50`: a soma dos quadrados das velocidades com mantissa de 64 bits arredondada para baixo × double
  arredondado ao mais próximo: em casos raros (~1e−9 por chamada, componentes muito diferentes) o cache de velocidade
  difere 1 ulp de f32.
- **D4** (cosmético) — o adaptador grava o tipo de vínculo 0 para teclas; o original grava 2 (bits de tecla) ou 4; o único
  leitor (`0057af60`) testa só `≠ 1`.

## Política do instalador

`PATCH_STAGE12*` nunca chama `SavePlace` nem salva nada (o usuário decide quando salvar); nunca sobrescreve `.rbxl` ou
backups; nunca apaga pastas não relacionadas nem substitui pastas inteiras; nunca apaga o carro ou o mapa. Confere a
bancada Stage 11 (atributo `NR2003Stage` + tamanho e hash FNV-1a de cada fonte publicada) e recusa bases incompatíveis
ou módulos editados localmente (`_G.NR2003_PATCH12_FORCE = true` força, por conta do usuário). Faz backup só das
instâncias que muda (e marca as que adiciona) em `ServerStorage.NR2003Backup_Stage12`, criado uma única vez. Atualiza a
fonte na mesma instância; adiciona os 2 módulos novos; edita uma linha ancorada em cada self-test 6/7–11. Roda os
auto-testes 6/7–12 e, se algo falhar, restaura as fontes e remove o que adicionou (sem instalação parcial). Re-executar
não duplica nada. Reversão manual verificada (`PATCH_STAGE12_ROLLBACK.lua`: restaura e confere o hash de cada fonte,
remove os módulos adicionados, roda o auto-teste do Stage 11). **Não revertido automaticamente:** os atributos que o
usuário criar no `TestCar` (`Steering*`) e o próprio backup em `ServerStorage` (mantido de propósito).

## Limites explícitos

- **Validação manual no Roblox Studio** pendente (15 itens em `VALIDACAO.md`).
- **Assistência de direção** e **modo arcade**: recusados (ver classificação). O ramo do bit 25 em `00552720` /
  `00552410` é exato, mas só é ativável para validação.
- **Dispositivos**: a curva de calibração do joystick do Windows não existe no Roblox; o eixo do gamepad entra já
  normalizado (zona morta opcional do cliente `Config.gamepadSteerDeadzone`, padrão 0 = como o original).
- **Física herdada**: divergência de longo prazo quase-estática dos pneus (ramos de stick-slip) — do próprio original,
  documentada por horizonte e reinício reverso; não é da cadeia de direção.
- **FFB / torque de direção**: Stage 13 (interface em `STAGE12_RECOVERY.md` §8, `NEXT_PROMPT_STAGE13.txt`).
