# Validação — Stage 9 (aerodinâmica)

Executada nesta máquina com Luau CLI 0.741 (codegen nativo), Python 3.14 + Unicorn 2.1.4 + Capstone 5.0.6 e Ghidra
11.1.2. Saídas: `tests/stage9/RESULTS_STAGE9.txt`, mapa do aero `tests/stage9/AERO_MAP.txt`
(`tools/run_stage9_tests.ps1` ou `.sh` roda tudo, incluindo as suítes 6/7 e 8).

## Método

1. **Referência = código original.** `recovery/stage9/orig_aero.py` executa o x86 original (driver dos Stages 7/8 +
   `005a3c00` original na sessão + subconjunto de `005637e0` por quadro; `005afd80` original com anéis de carros falsos)
   e `gen_fixtures_stage9.py` grava constantes, vetores, cenários e snapshots.
2. **Bit a bit** para o código portado à mão (clima, densidade, esteira, vácuo, conversões de garagem) e para as
   nativas geradas (`00561a80`, `00561b70` com todos os ramos), escrevendo as mesmas células de entrada.
3. **Sincronizado:** memória da máquina original (com ar) carregada no Luau, 1 e 2 quadros, comparação estrita; e o
   `00561b70` original no estado do snapshot = `aeroState` do Luau.
4. **Cenários:** cada um reinicia do snapshot original no instante do gêmeo (+1 ulp em z); envelope = 3× a dispersão do
   gêmeo (±36 ticks) + 2 cm / 5 cm/s + 1 %. Comparações físicas entre cenários são verificadas **nas linhas do original e
   do Luau**.

## Resultados automáticos

| Verificação | Resultado |
|---|---|
| Constantes embutidas + células das tabelas de dano = bytes do `NR2003.exe` | PASS — 51/51, tabela da esteira, cabeçalho, qword 0,447 |
| `005a3c00` sessão → vento, densidade, temperaturas | PASS — 1576/1576 bit a bit |
| `005a3ba0` + `005a3be0` densidade | PASS — 2500/2500 bit a bit |
| `00561a80` meio vento (com/sem projeção na normal da pista) | PASS — 600/600 bit a bit |
| `00561b70` força + momento (yaw ±180°, pitch, ω, ρ, fatores, alturas, fita, aerofólio, dano, estol) | PASS — 5000 vetores, 4892 bit a bit, pior 4,5e−6 relativo |
| Contador de 16 chamadas e estado de estol `00410b50` | PASS — 5000/5000 exatos |
| `005b0230` esteira / `005afd80` vácuo | PASS — 3000/3000 e 3000/3000 (1884 com esteira) bit a bit |
| Conversões de garagem fita / aerofólio | PASS — idênticas |
| 44 snapshots × 2 quadros | PASS — 39 estados ≤ 2,8e−4; cabeça do piloto ≤ 1,1e−3 (tolerância 3e−3: estado mais rígido, também o pior no Stage 8); 1 snapshot de deslizamento quase parado: posição ≤ 4 µm |
| Forças dos pneus / fatores / marcha nos snapshots | PASS — ≤ 1,5e−3 / idênticos |
| Telemetria `aeroState` = `00561b70` original no snapshot | PASS — 44/44, 0 ulp |
| 17 cenários dentro do envelope do original | PASS |
| Velocidade máxima com ar < sem ar; chassi mais baixo | PASS — 74,72 vs 75,57 m/s; z 0,4041 vs 0,4190 m |
| Ganho de velocidade 10→15 s menor com ar | PASS |
| Carga total dos pneus a ~74 m/s > parado + 2 kN | PASS — 19130 vs 16003 N |
| Frenagem a 74 m/s: 1º segundo > 4º segundo | PASS — 15,9 vs 13,2 m/s |
| Curva rápida: carro apoiado | PASS |
| Ar mais denso é mais lento (40 °F < padrão < 110 °F; nublado < padrão) | PASS |
| Vento de frente < de cauda; lateral 30 mph → +1,3 kN de força lateral (original e port) | PASS |
| Aerofólio 70° vs 45° (mesmo estado a 10 s): mais baixo, mais compressão traseira, mais lento | PASS |
| Fita 100 % (mesmo estado a 10 s): mais rápido, mais carga dianteira, mais baixo | PASS |
| Fita 100 % desde a garagem: a largada original roda perto de 20 m/s e o port acompanha | PASS |
| Vácuo 8 m: fator 0,874 e mais rápido; deslocado 2 m: esteira menor | PASS |
| Carro único: fatores exatamente 1,0 | PASS |
| Baixa velocidade (cenário do Stage 8): \|força aero\| < 0,1 % do peso | PASS — 1,4 N |
| Sessão, reset, primeiro quadro, `aeroState` sem efeito colateral, checkpoint com vácuo, `endSession` | PASS |
| Regressão Stage 6/7 / Stage 8 | PASS — 16/16 e 49/49, inalterados |
| Adaptador sob mock (9 checks aero + auto-testes 6/7, 8, 9 rápido/completo) | PASS — 39/39 |
| `PATCH_STAGE9.lua` em DataModel simulado (6/7 → 8 → 9, módulos gerados e auto-testes antigos intactos, backup, reversão, recusa sem 8) | PASS — 13/13 |
| `PATCH_STAGE6_7` / `PATCH_STAGE8` (inalterados) | PASS — 11/11, 13/13 |
| Sintaxe | PASS |

Observação: a largada a partir do repouso é descontínua (âncora do pneu a baixa velocidade, embreagem): uma força de
0,06 N já muda a trajetória. Por isso a comparação "com/sem ar" em baixa velocidade é feita pela força, e a trajetória
com ar é comparada ao original com ar.

## Validação manual no Roblox Studio — a fazer

Pista: o asfalto da bancada tem ~112 × 280 m; para velocidade máxima (~1,1 km de aceleração) cole na Command Bar, fora
do Play (só ambiente, opcional):

```lua
local p=Instance.new("Part");p.Name="LongStraight";p.Anchored=true;p.Size=Vector3.new(150,2,6000)
p.CFrame=CFrame.new(0,-1,-3850);p.Material=Enum.Material.Asphalt;p:SetAttribute("NRSurface",1)
p:SetAttribute("NRGripMultiplier",1);p.Parent=workspace.NR2003LabWorld.TestTrack
```

1. Aplicar `PATCH_STAGE9.lua`. Output: self-tests 6/7 (7), 8 (5), 9 (13) sem falhas e `Stage 9 aplicado`.
2. Play → F → T. Uma linha `[NR2003 Stage 9] sessão: 70 F ... rho 1.081192 ...`. Parado: AERO `rho 1.0812`, q 0,
   fatores 1.000/1.000/1.000.
3. **Aceleração:** reta, W, trocando E. q ≈ 417 Pa a 100 km/h, ≈ 1670 Pa a 200 km/h; arrasto ≈ 0,5 / 1,9 kN; downforce
   ≈ 0,4 / 1,6 kN (cresce ~v²); "alt. diant." cai alguns mm; a aceleração em 4ª diminui perto do fim.
4. **Velocidade máxima:** a fundo em 4ª: ~269 km/h, `lim off` (arrasto equilibra antes do limitador); ~3,2 kN de arrasto e
   ~3,2 kN de downforce (D ~1,4 / T ~1,9 kN). Com o atributo `AeroSession=false` + R: ~272 km/h no limitador (`lim ON`),
   AERO "sem sessão".
5. **Suspensão:** a ~250 km/h o carro fica visivelmente mais baixo (≈ 15 mm); cargas dos pneus somam ~3 kN a mais que
   parado (colunas CARGA).
6. **Frenagem a alta velocidade:** de ~260 km/h, S: desaceleração inicial maior que a 100 km/h (arrasto + carga).
7. **Curva rápida:** volante leve a ~250 km/h: as cargas (CARGA) ficam ~3 kN acima das de baixa velocidade e o carro
   sustenta mais aceleração lateral do que com `AeroSession=false` na mesma velocidade e esterço.
8. **Equilíbrio:** `SetupSpoiler=45` + R → menos downforce traseiro (T cai ~1 kN a ~250 km/h), traseira mais leve;
   `SetupSpoiler=70` → mais. `SetupGrilleTape=100` + R → D sobe ~1 kN, arrasto cai ~5 % (largada a pleno pode rodar,
   como no original: acelere progressivamente). Apagar atributos → R → 0 % / 65°.
9. **Altura/pitch:** com o carro baixo a alta velocidade, "alt. diant." < 178 mm aumenta o downforce (efeito solo);
   rodando/derrapando forte (yaw > 45°) a linha AERO mostra downforce negativo (sustentação), como no NR2003.
10. **Clima:** `WeatherTemperatureF=40` + R → rho 1,1489 (mais lento); `WeatherConditions=2` → 1,1963;
    `WeatherWindMph=30`, `WeatherWindDirection=0..7` → velocidade máxima muda com vento de frente/cauda; vento lateral
    empurra o carro.
11. **Vácuo (TESTE):** `DraftTestGap=8` (opcional `DraftTestLateral`) durante a corrida: fatores ~0,87 / 0,88 / 1,00 e
    "(vácuo TESTE)"; velocidade máxima sobe um pouco. Apagar o atributo → 1,00. (Não há outros carros reais ainda.)
12. Regressão: entrada no carro, freio (Stage 8), trocas e suspensão como antes; baixa velocidade inalterada.

---

# Validação — Stage 8 (modelo de freio)

Executada nesta máquina com Luau CLI (codegen nativo), Python 3.14 + Unicorn 2.1.4 e Ghidra 11.1.2. Saída completa:
`tests/stage8/RESULTS_STAGE8.txt` (`tools/run_stage8_tests.ps1` ou `.sh`).

## Método

1. **Referência = código original.** `recovery/stage8/orig_brake.py` executa o x86 original do NR2003 (driver do Stage 7
   + `00553080` original nativo) e `gen_fixtures_stage8.py` grava: vetores unitários, cenários e snapshots.
2. **Bit a bit** para o código portado à mão: as mesmas células de entrada → mesmo resultado float32.
3. **Sincronizado:** a memória da máquina original num instante (janelas da imagem Luau + blocos de contato do host) é
   carregada no Luau, que roda 1 e 2 quadros; comparação estrita com o original.
4. **Fase de frenagem:** cada cenário reinicia do estado original no início da frenagem; envelope = 3× a dispersão do
   gêmeo original (+1 ulp em z pelo import original `005b4560`) numa janela de ±36 ticks + 2 cm (posições) /
   5 cm/s (velocidades, assentamento por atrito estático) + 1 %. No regime de hold (v < 0,8 m/s com pitch a ±0,05° do
   limiar de 0,5°) o pedal original é descontínuo e é verificado pelos snapshots.

## Resultados automáticos

| Verificação | Resultado |
|---|---|
| `00553080` (+`00552d00`, `00554f50`, `00550130`) vs original | PASS — 3000/3000 bit a bit (0 ulp) |
| `005f7570` atitude | PASS — 1500/1500 bit a bit |
| 29 snapshots × 2 quadros (45 estados) | PASS — pior 2,5e−4 (1 quadro) / 3,2e−4 (2 quadros) |
| Torque de freio, Fx, Fy, Fz, vx, escorregamento por roda (snapshots) | PASS — pior 1,07e−3 relativo |
| Pedal processado, célula de freio e marcha (snapshots) | PASS — idênticos |
| 11 cenários de frenagem dentro do envelope do original | PASS — posições finais a 0–7 mm |
| Freio zero: só atrito de arrasto (\|T\| < 120 N·m) | PASS |
| Ordem leve < médio < máximo | PASS |
| 74 %: saturação ~2800/1000 N·m sem travamento | PASS (original e Luau) |
| 85 %: dianteiras travam (ramo estático do `00561040`) | PASS |
| 60 %: traseira trava/desliza | PASS |
| Transferência de carga e mergulho | PASS |
| Alta velocidade (~39 m/s) | PASS |
| Rampa da tecla 1/12 por quadro; recuperação ao soltar | PASS |
| Frenagem em curva | PASS |
| Quase parado: para e fica parado após soltar (hold) | PASS |
| Sem piloto: pedal exatamente 1,0 | PASS |
| `setBrakeBias` 74/60 = células do rebuild original | PASS |
| Checkpoint/restore com travamento | PASS — bit a bit |
| Regressão Stage 6/7 | PASS — 16/16, números idênticos ao pacote 3.6.0 |
| Adaptador sob mock (inclui 10 checks de freio + auto-testes 6/7 e 8 rápido/completo) | PASS — 28/28 |
| `PATCH_STAGE8.lua` em DataModel simulado (6/7 → 8, módulos gerados intactos, backup, reversão forçada, recusa sem 6/7) | PASS — 13/13 |
| `PATCH_STAGE6_7.lua` (inalterado) | PASS — 11/11 |
| Sintaxe | PASS |

## Validação manual no Roblox Studio — a fazer

1. Aplicar `PATCH_STAGE8.lua` (Command Bar, fora do Play). Output: `Stage 6/7 self-test: 7 passed, 0 failed`,
   `Stage 8 self-test: 5 passed, 0 failed`, `Stage 8 aplicado`.
2. Play → F. Parado em N sem acelerar: HUD "pedal freio" > 0 (hold automático; 0,20 ou 0,98 conforme a atitude).
3. Engatar (E), acelerar (W): pedal vai a 0. Atingir ~100 km/h.
4. Segurar S: pedal sobe em degraus (~0,08 por quadro, ~0,33 s até 1,00); "núcleo" = pedal²; carro mergulha a frente,
   cargas dianteiras sobem; torque dianteiro ~2800 N·m, traseiro ~1000 N·m; **sem "TRAV"** com viés 74 %.
5. Soltar S em movimento: pedal desce 0,125 por quadro (com W) ou 1/24 (sem W); rodas voltam a girar livres.
6. Parar com S, soltar S sem acelerar: o carro fica parado (hold).
7. Sair do carro (X) em movimento: o carro freia sozinho (pedal 1,0).
8. Viés: no `TestCar`, atributo numérico `SetupBrakeBias` = 85 → R → frear forte a ~100 km/h: dianteiras "TRAV".
   `SetupBrakeBias` = 60 → traseira trava. Apagar o atributo → R → volta a 74.
9. Regressão 6/7: suspensão, trocas, limitador e direção como antes.

---

# Validação — Stages 6 + 7 (núcleo original NR2003 Cup)

Executada com Luau CLI (codegen nativo) e Python/Unicorn. Saída completa: `tests/stage67/RESULTS_STAGE67.txt` (`sh tools/run_stage67_tests.sh`).

## Método

1. **Referência = código original.** `recovery/stage6_7/gen_fixtures.py` roda o x86 original do NR2003 (Unicorn, CW `0x077f`) com o mesmo host (planos de contato, rampas) e grava trajetórias: cenário `raw` (entradas direto em `bf6360`) e `drive` (camada do piloto + 005539c0 original com 00553d70 e limitador).
2. **Envelope de sensibilidade.** Cada cenário é repetido no original com z inicial +1 ulp (`pert`). A diferença original↔pert é a sensibilidade intrínseca do próprio NR2003; o Luau deve ficar dentro de 3× essa diferença (+2 cm/0,02 m/s).
3. **Curto prazo estrito:** ticks 1–8, todos os 45 estados, erro relativo ≤ 2e−5.

## Resultados automáticos

| Verificação | Resultado |
|---|---|
| Ticks 1–8 vs original (`raw`, `drive`) | PASS — pior erro relativo 4,07e−7 / 2,04e−7 |
| 2304 ticks (8 s) dentro do envelope do original | PASS — `raw`: x final Luau 102,816 m, original 102,799, pert 102,825; `drive`: 46,368 / 46,336 / 46,366 |
| Sequência de marchas (00553d70) | PASS — 0 divergências, chega à 4ª |
| Limitador | PASS — corta aceleração, pico 9385 rpm (limite 9300 + histerese) |
| Checkpoint/restore | PASS — bit a bit |
| Provedor de contato por função / leituras de estado | PASS — sem efeitos colaterais |
| Pose dos registros vs estado/quaternion | PASS |
| Rodas sobre os pontos de contato, cargas | PASS — altura do centro 0,349–0,356 m, cargas 3,2–4,6 kN |
| Import original 005b4560 | PASS — Δx = 1,0001 m |
| Pilhas x86/x87 equilibradas | PASS |
| Adaptador Roblox sob mock de API (raycast, pose, aceleração −Z, trocas, direção à direita → +X, snapshot, colisão, reset, rampa 5 % rolando morro abaixo) | PASS — 15 checks |
| Auto-teste de Studio (`Roblox/Stage67SelfTest`, modo rápido executado pelo patch) | PASS — 7 checks |
| `PATCH_STAGE6_7.lua` executado contra um DataModel de Studio simulado: instalação + auto-teste real, backup, e caminho de reversão forçada | PASS — 11 checks |
| Sintaxe (todos os módulos + patch) | PASS |
| Reprodutibilidade do gerador | PASS — módulos byte-idênticos |

Observação física (do próprio original): em 1ª marcha com acelerador total as rodas traseiras patinam (~45 %) e o carro tende a rodar — comportamento do setup oval assimétrico, não do port; a mesma rodada aparece no original executado.

## Validação manual no Roblox Studio — a fazer

1. Aplicar `PATCH_STAGE6_7.lua` (Command Bar, fora do Play). O Output deve listar o auto-teste com `7 passed, 0 failed` e "Stage 6/7 aplicado".
2. Play → F para entrar. HUD: título "NR2003 Cup / núcleo original 45 estados".
3. Parado em N (gear `N`): carro assenta (~0,418 m), cargas ≈ 3,3–4,6 kN por roda.
4. E (marcha acima) → `1`; W: acelera (Shift esquerdo = pedal de embreagem), rpm sobe até ~9300 e o limitador aparece no status ("limitador ON").
5. Trocas E/Q: neutro breve (~0,09 s) e corte/blip como no original; até a 4ª.
6. Suspensão: frenagem forte (S) → mergulho dianteiro; curvas → rolagem e curso independente LF/RF; eixo traseiro rola como eixo rígido.
7. Rampas/lombadas da pista de teste: rodas seguem o solo (raycast por roda 2× por tick).
8. Barreira: carro não atravessa (fronteira de posição; sem resposta de impacto NR2003 — pendente).
9. Visual suave (interpolação do estágio 5), cockpit/volante (V), diagnóstico (H).
10. R reinicia. `ModeConfig.mode = "NR2003_CORE"` volta ao estágio 5.

---

# Validação — Stage 5 estabilizado e aprovado / READY FOR STAGES 6 + 7

A validação automática foi executada com Lua 5.3 via `luatex --luaonly` e Python. Depois, o build foi testado manualmente em Roblox Studio pelo usuário. O registro automático + manual está em `tests/RESULTS.txt`.

| Verificação | Resultado |
|---|---|
| Sintaxe | 64 arquivos Lua, incluindo instalador, patch e módulos de apresentação |
| Baseline | 16 componentes, 45 estados, hierarquia/ciclos, 20 materiais, overrides, float32 e 300 rotações |
| Física anterior | 93 assertions |
| Rotinas x86 originais | 14.008 comparações intermediárias; máximo erro absoluto 1,1920929e−7 |
| Dinâmica do núcleo | 59 verificações |
| Entrada no banco | 14 verificações |
| Estágio 5 ao vivo no substituto das APIs | 59 verificações |
| Snapshot/interpolação | 36 verificações: codec, quaternion/slerp, spin unwrap, reorder, reset, extrapolação e 30/60/120/144/240 FPS simulados |
| Gerador/rig | 146 BaseParts, 146 conectadas; quatro contatos, eixos, molas, volante e cockpit |
| Distribuição | Source dos kits rbxmx idêntico ao Lua; hashes da memória original conferidos |
| Play no Studio | **PASS manual (2026-10-04): apresentação suave; suspensão física mais visível após remover o gargalo visual** |
| Trajetória do carro completo contra NR2003 | **Não validada** |


## Estabilização de apresentação

`RenderState` é um `UnreliableRemoteEvent` usado apenas para snapshots visuais. O pacote codifica posição/orientação/velocidades do chassi e quatro estados visuais de roda em 204 bytes. O cliente mantém um pequeno buffer, interpola posição e quaternion, interpola curso/steer/spin das rodas e permite extrapolação linear/angular curta e limitada. Reset do carro marca teleporte e limpa o histórico para evitar interpolar através do mapa.

A atualização local ocorre antes da câmera. O modo cockpit lê o `CockpitCamera` já movido pelo transform interpolado no mesmo frame. `ROBLOX_ADAPTER` não ativa esse override.

O teste puro simula perda de 3%, jitter, reorder e diferentes FPS de render. Ele não substitui Play real no Studio e não mede a rede Roblox real.

### Auditoria da suspensão antes do Stage 6

A simulação headless do caminho Stage 5 encontrou equilíbrio estático de aproximadamente 65,5 mm (frente) e 65,9 mm (traseira), exatamente compatível com as taxas/massa do tune; soma de carga 14.710 N para peso 14.710 N. Frenagem a 20 m/s produziu pico de pitch de aproximadamente 1,176°. Não foi identificado multiplicador de studs/metres duplicado, força dividida duas vezes ou regressão inequívoca que justificasse retune. A resposta amortecida/unsprung completa permanece assunto do Stage 6.

## Validação manual no Roblox Studio — 2026-10-04

Após aplicar a estabilização PRE-STAGE-6, o usuário confirmou que o carro ficou **“liso liso”** durante a condução. Os efeitos de suspensão passaram a ficar mais visíveis, o que confirma que o baixo Hz de apresentação anterior estava mascarando movimento físico já existente.

Resultado desta validação:

- PASS — Stage 5 aceito como baseline jogável para continuar o roadmap;
- PASS — suavização visual do veículo completo;
- PASS — movimento de suspensão continua físico e agora é mais legível visualmente;
- PASS — nenhum retune de mola/amortecedor/pneu/geometria foi necessário para obter a suavização;
- PASS — solver autoritativo e caminho físico do Stage 5 foram preservados.

Isto **não** substitui uma futura comparação de trajetória/state-history contra o NR2003 original; essa validação permanece pendente no roadmap.

### Carro de referência/calibração

O primeiro carro alvo do jogo será o **NASCAR/Cup car do NR2003**. Portanto, parâmetros do `TestTune` são apenas placeholders de bancada. Nos Stages 6 e 7 — e nos estágios posteriores — sempre que uma grandeza física relevante puder ser recuperada do original, deve-se usar a calibração/tune/setup do NASCAR do NR2003, não valores inventados para Roblox.

## Comparação independente do núcleo

As fixtures em `tests/fixtures/original_x86.json` e `.lua` foram geradas executando as rotinas x86 originais exportadas da análise Ghidra em Unicorn 2.1.4. O gerador `recovery/original_x86_reference.py` não usa a tradução Lua como referência. Não é executado o jogo inteiro.

São quatro cenários sintéticos: corpo único, árvore, árvore rotacionada e grafo de 16 componentes; quatro passos por cenário, com intermediários de predictor/corrector e dados de restrições, inércia, momento, velocidade e pose. Há também 16 casos da matriz de projeção da transmissão. As massas/entradas desse ensaio são explícitas. O erro tolerado no núcleo combina 3e−7 absoluto ou 2e−5 relativo; a matriz de transmissão usa 3e−7. Isso valida as rotinas exercitadas, sem atestar toda calibração/força do veículo original.

`test_core_dynamics.lua` verifica movimento livre, gravidade, torque, velocidades absolutas/relativas de rotores, reações, conservação de momento nos cenários, projeção de transmissão, forças de pneus no chassi, momento de alinhamento, cargas traseiras simétricas/assimétricas, transferência pela suspensão, replay e acumulador de passos.

## Testes do carro e banco

`test_stage5.lua` executa `CoreChassisAdapter`, `CoreChassisBridge` e `SeatAccess` reais contra substitutos de geometria, Instances e eventos. Bloqueia chamadas de impulso Roblox. O ensaio assenta por 2 s e acelera por 5 s, chegando a **43,19 km/h**; depois testa redução de velocidade por freio e yaw por direção. Essa velocidade descreve apenas o ensaio, não desempenho homologado.

Também verifica: um avanço do motor/roda por tick, 13 estados ativos do chassi, replay exato com acumulador, resultados iguais a 60/144 Hz de atualização, orçamento de 96 passos sem perder saldo, varredura contra parede translacional, entrada/saída no modo de chassi intencionalmente ancorado e restauração da propriedade física ao destruir o controlador.

`test_seat_access.lua` cobre distância, ocupação, cooldown, tentativa repetida, confirmação da autoridade do motorista, timeout, respawn, limpeza e separação entre montagem do banco e SeatWeld do avatar. O aviso `VehicleSeat did not confirm Occupant` em `RESULTS.txt` é esperado no caso que testa timeout.

O substituto não executa a implementação real de Sit, Blockcast, replicação, câmera, inputs ou escrita de Source no Studio. Colisão do estágio 5 cobre translação da caixa; sobreposição inicial, rotação sem deslocamento, reação em objetos dinâmicos e colisões completas entre carros permanecem limitadas.

O teste longitudinal anterior continua passando: pico de 26,26 km/h, frenagem com residual −0,049 km/h e ré de módulo 16,05 km/h. Ele usa cargas constantes e outro integrador de ensaio; não deve ser confundido com o teste do controlador do estágio 5.

## Reexecutar

Na raiz do pacote, com Python 3 e Lua 5.3+ (ou LuaTeX):

```bash
python3 tools/build_package.py
python3 tools/run_tests.py
python3 tools/build_package.py
```

A segunda geração atualiza os hashes do manifesto depois de escrever `RESULTS.txt`. Para regenerar evidências e mapas, quando necessário:

```bash
python3 -m pip install unicorn==2.1.4
python3 recovery/original_x86_reference.py
luatex --luaonly recovery/export_core_maps.lua
python3 recovery/export_dispatch.py
```

Para exportar novamente do projeto Ghidra original, use `recovery/ExportVehicleCore.java` como postScript de `analyzeHeadless`, com o projeto aberto em modo `-readOnly -noanalysis` e o diretório de saída como argumento. Os dados necessários aos testes normais já estão incluídos; não é preciso Ghidra nem Unicorn para repetir `tools/run_tests.py`.

## Continuidade após Play validado

O primeiro Play da revisão estabilizada já foi realizado e aprovado. A próxima validação prática deve acompanhar os Stages 6 e 7, preservando a apresentação interpolada enquanto novas massas/estados passam a integrar o solver ao vivo.

