# 3.8.0-stage9 — Stage 9: aerodinâmica completa do NR2003 Cup

- Stages 6, 7 e 8 validados manualmente no Studio pelo usuário antes deste estágio. Nenhum módulo gerado 6/7 foi
  alterado (regenerados byte a byte nesta máquina); suspensão, drivetrain e freio intactos.
- **Achado:** o aero original (`00561a80`/`00561b70`/`00410280`) já rodava no núcleo, mas sem entradas: o build não
  executa o início de sessão nem a atualização por quadro, então ρ (`e0b84c`) = 0 e fatores (`car+0x59e/0x5a2/0x5a6`) = 0.
- Novo módulo `Core/NR2003Cup/NR2003CupAero` (porta à mão, bit a bit): sessão `005a3c00` (temperatura, condições, noite,
  vento, norte da pista; densidade úmida `005a3ba0` + `005a3be0`; padrões do construtor `005a38b0`), atualização por
  quadro `005637e0` (fatores 1,0, velocidade do ar, vácuo), vácuo `005afd80` + esteira `005b0230`/`00567818` + gap
  `00516daa`, itens de garagem fita (0x3b) e aerofólio (0x3d), telemetria = `00561b70` original sem efeitos colaterais,
  restauração de 16 células das tabelas de dano aero ausentes da imagem.
- `NR2003CupDriver.drive`: chama `V._aeroFrame` antes de `frameStart` (ordem de `0055bfd0`); sem sessão não faz nada.
- `NR2003CupVehicle`: carrega o módulo (opcional) e expõe `startSession/endSession/weather/setAeroSetup/aeroSetup/
  setTrackNormal/setDraftEnvironment/aeroFactors/aeroState`. Sem `startSession` o núcleo é o pós-build dos Stages 6–8.
- Adaptador Roblox: sessão no `initialize` com atributos de clima/norte/`AeroSession`, fita/aerofólio por atributo,
  normal da pista pelos planos de contato a cada quadro, vácuo de teste `DraftTestGap/DraftTestLateral`, telemetria aero;
  uma linha de Output por sessão. Cliente: linha AERO no painel.
- Validação contra o original executado: clima 1576/1576 e vácuo 3000/3000 bit a bit, densidade 2500/2500, meio vento
  600/600, esteira 3000/3000, aero 5000 vetores (pior 4,5e−6), 44 snapshots (39 estados ≤ 2,8e−4), 17 cenários no
  envelope, telemetria = original. Regressões 6/7 e 8 inalteradas. `tests/stage9/AERO_MAP.txt`: mapa do aero Cup.
- Ferramentas: `recovery/ghidra_tools/` (scripts Jython reutilizáveis + runners + notas de preparação), `recovery/stage9/`
  (harness, gerador, evidências, ferramentas estáticas de memória/ponteiros/constantes/cobertura da imagem).
- Entrega: `PATCH_STAGE9.lua` / `NR2003_Patch_Stage9.rbxmx` (backup, auto-testes 6/7 + 8 + 9, reversão), `Stage9SelfTest`.

# 3.7.0-stage8 — Stage 8: modelo de freio completo do NR2003 Cup

- Stages 6 + 7 validados manualmente no Studio pelo usuário antes deste estágio; nenhum módulo gerado 6/7 foi alterado (o gerador reproduz os 7 módulos byte a byte nesta máquina).
- **Cadeia de entrada original do freio** portada à mão em `NR2003CupDriver` e verificada bit a bit contra o código original executado: tabela de controles (`0057af30/0057af60`), limitador de eixo `00552d00`, velocidade `00554f50`, atitude `005f7570` (`005f6e40`+`005f74c0`), processamento do pedal `00553080` (hold automático abaixo de 0,8 m/s, rampa de tecla 1/12 por quadro, soltura 1/8 ou 1/24, braking help `00550130` desligado por padrão), ramo "não dirigido" de `005524f0` (pedal 1,0), retenção `bf6eb9`. Ordem original preservada: o pedal lê o acelerador do quadro anterior e as somas de escorregamento antes de serem zeradas.
- **Viés de freio da garagem** (item 0x28, 50..90 %, padrão 74): `setBrakeBias` = `00423de0` + bloco de `0055e9b0` → Kb 2812 / 987,99994 N·m (máx. 3800 N·m do spec Cup). Provado que só essas células mudam num rebuild original.
- **Torque por roda / travamento**: já era o código original gerado (`005610b0` ×4 + `00561040`: capacidade = freio·Kb + 10 + 1e−4·ω² + resistência ao rolamento; atrito estático quando a demanda cabe na capacidade); agora documentado, observável (`wheelBrake`) e validado. Âncora do pneu a baixa velocidade escalada pela célula de freio (`0054cab0`) idem.
- **Temperatura do freio** (`0054f260`) mapeada e legível (`brakeTemperature`); continua congelada (Stage 11). As únicas rotinas que comparam a temperatura com limiares/falha (`0054f3d0`, `0054f610`) e o gravador de viés diagonal (`0055e6d0`) não têm referências no executável: o NR2003 entregue não tem fade nem ABS.
- API: `controls.brakeControl/brakeDigital/throttleControl/throttleDigital/driver`; `controls.brake` mantém o contrato 6/7 (injeção direta, usado pelas fixtures de regressão).
- Adaptador Roblox: tecla S = ligação digital original; sem piloto = "não dirigido"; atributo `SetupBrakeBias` no carro (aplicado no reset); telemetria de freio por roda. HUD: pedal processado → núcleo, viés, torque por roda e travamento.
- Recuperação: Ghidra 11.1.2 headless com scripts Jython (Java 26), harness `orig_brake.py`, gerador `gen_fixtures_stage8.py` (3000 vetores de pedal, 1500 de atitude, 11 cenários, 25 snapshots sincronizados).
- Testes: `tests/stage8/run.luau`, adaptador sob mock com checks de freio, `PATCH_STAGE8.lua` sob DataModel simulado (6/7 → 8, reversão, recusa sem 6/7), regressão 6/7 inalterada.

# 3.6.0-stage7 — Stages 6 + 7: núcleo original NR2003 Cup de 45 estados

- Novo modo padrão `NR2003_CUP`: o carro NASCAR/Cup do NR2003 roda com a física original completa — chassi, suspensões dianteiras + cubos + rodas, eixo traseiro rígido + rodas, motor, embreagem, eixo de saída e cabeça (45 estados) — gerada a partir do `NR2003.exe` (Unicorn + tradução): 9 callbacks x87 do emissor do jogo, 86 nativas x86, memória do carro pós-build (spec Cup `0x7238e0`, setup padrão, motor/pneus inicializados).
- Estágio 6: contato pneu–pista pela interface original 0055e1e0 (planos `n·x+d=0`, velocidade do solo, material, grip), consultado duas vezes por tick nas posições atuais das rodas; âncora do pneu reiniciada como em 005778a0.
- Estágio 7: camada do piloto original — rampas por tick (00551e80/005539c0), acelerador/freio ao quadrado, toe do setup, máquina de troca 00553d70 com neutro/blip/corte, embreagem automática 005542f0, limitador 9300 rpm, timer de corte 0051aac0 por frame.
- Numérica: escritas float32 arredondando para −∞ (CW `0x077f` do task de simulação, recuperado em 0055cef0); FIST = floor; intermediários x87 em double (erro de 1–2 ulp).
- Validação contra o código original executado: ticks 1–8 ≤ 4,1e−7 relativo; 8 s dentro do envelope de sensibilidade do próprio original; marchas idênticas; checkpoint bit a bit.
- Módulos divididos (< 200.000 caracteres e < 4 MB de código nativo); codegen nativo ~0,4 ms/tick.
- `CupTune`: geometria de apresentação/consulta do Cup a partir dos registros originais (não alimenta a física).
- Servidor/cliente: ramo `NR2003_CUP`, cliente escolhe `CupTune` pela tag do carro, HUD com entradas/limitador. Snapshot de render (204 B) e interpolação do estágio 5 inalterados.
- `PATCH_STAGE6_7.lua` atualiza o Stage 5 no lugar com backup completo, reversão automática e auto-teste; `NR2003_Patch_Stage6_7.rbxmx` equivalente.
- Provisórios marcados: direção (estágio 12), resposta de colisão de carroceria, plano distante sem geometria, material sem tabelas de pista, estágio 11 congelado. Estágio 8 não iniciado.

# 3.5.2-stage5-validated — READY FOR STAGES 6 + 7

- Stage 5 foi validado manualmente no Roblox Studio pelo usuário em 2026-10-04 após a estabilização de apresentação. O carro agora é percebido como totalmente suave, e os movimentos físicos de suspensão/pitch/roll/heave ficaram mais visíveis em vez de serem mascarados pela apresentação esparsa.
- A validação confirmou que a correção visual não exigiu retune de suspensão: nenhum valor de mola, amortecedor, geometria, pneu ou força do núcleo foi alterado pela estabilização.
- Stages 1–5 são tratados como baseline concluído para continuidade do roadmap. O grafo de 16 componentes/45 estados está reconstruído/testado; no carro em Play o Stage 5 tornou os 13 estados do chassi autoritativos. A ativação integral das massas não suspensas/eixo traseiro pertence ao Stage 6, e a cadeia drivetrain ao Stage 7.
- Próxima dupla autorizada: **Stage 6 — complete suspension / unsprung mass / rear-axle dynamics** e **Stage 7 — complete drivetrain integration**.
- Decisão de produto/calibração: o primeiro carro de referência do jogo será o **NASCAR/Cup car do NR2003**. Sempre que dados originais existirem, parâmetros, tune, setup e calibração relevantes devem ser recuperados e usados exatamente como no NR2003; o `TestTune` atual continua apenas como bancada provisória até ser substituído por valores originais confirmados.
- Continua proibido avançar por feeling: sem inventar grip, spring rate, steering ratio, gearing, differential ou outros valores para “parecer certo”.

# 3.5.1-stage5-stabilized — PRE-STAGE-6

- Stage 6 continua **não iniciado**; este patch estabiliza apenas a apresentação do Stage 5.
- Identificada a causa do efeito visual de ~20–30 Hz: o chassi autoritativo era movido no servidor com `Model:PivotTo()`, mas cliente/cockpit observavam diretamente os transforms replicados esparsos. O solver continuava a 288 Hz.
- Adicionado `RenderState` (`UnreliableRemoteEvent`) com snapshots compactos de 204 bytes a até 60 Hz, sem enviar o grafo completo de 45 estados.
- Adicionados `RenderSnapshot`, `SnapshotBuffer`, `RenderPresentation` e `RenderConfig`: buffer de snapshots, slerp quaternion shortest-path, interpolação por frame, extrapolação limitada, spin de roda desenrolado e flush em reset/teleporte.
- O cliente aplica a apresentação antes da câmera em `BindToRenderStep(Camera-1)`, incluindo chassi, rodas, suspensão, volante e referência da câmera de cockpit. A física permanece exclusivamente no servidor.
- `ROBLOX_ADAPTER` permanece disponível e não recebe override de apresentação.
- Diagnóstico opcional com **H**: Hz do solver inferido, snapshots, recebimento, FPS, delay, buffer, drops/reorder e extrapolação.
- Auditoria de suspensão do Stage 5 encontrou equilíbrio estático coerente: ~65,5 mm dianteira / 65,9 mm traseira, carga total igual ao peso e ~1,18° de pitch em frenagem. Nenhum retune foi feito; dinâmica completa não suspensa/eixo traseiro continua reservada ao Stage 6.
- Nenhum arquivo de `core/` foi alterado nesta estabilização.

# 3.5.0-stage5

- Entrega encerrada no estágio 5, sem avançar o estágio 6.
- Núcleo multibody numérico com 16 componentes/45 estados, restrições recursivas, transformações espaciais, momento, predictor/corrector e commit recuperados.
- Comparações independentes contra execução de rotinas x86 originais; registros de componentes, estados, dispatch e referências de funções.
- Modo padrão `NR2003_CORE` dirigível: 13 estados do chassi integrados numericamente, força de rodas/suspensão/transmissão pelo adaptador uma vez por tick.
- Pose do modelo por CFrame, velocidade numérica nos contatos, varredura translacional, agenda a 288 Hz, saldo temporal e replay por checkpoint.
- Corrigida a montagem `DriverSeatMount`, confirmação/repetição de Sit, mensagens de admissão e entrada no modo numérico ancorado.
- Acrescentados volante animado, coluna e câmera de cockpit; gerador passa a 146 BaseParts conectadas.
- Patch para instalação existente com backup e preservação de tune, carro, meshes e pista. Instalador novo, kits rbxmx e projeto Rojo regenerados.
- `ROBLOX_ADAPTER` mantém disponível o caminho anterior. Tune permanece experimental; direção/FFB e grafo completo ao vivo ficam pendentes. Play no Studio não executado.

# Versão 2 — base preservada

- Curvas de suspensão/pneu, forças combinadas, partes térmicas, motor, transmissão experimental e interface aerodinâmica.
- Adaptador com chassis Roblox e contatos raycast; gerador, tune, pista, rede, HUD, câmera e importação de meshes.
- Módulos e dados recuperados da primeira entrega preservados.
