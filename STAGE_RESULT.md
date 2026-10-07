# Stage 10 — setup completo da garagem → parâmetros de tempo de execução

**Resumo:** o NR2003 aplica um setup de garagem **reconstruindo o carro**: copia a garagem para o setup ativo, recalcula
os itens derivados (`00559820` → `00425ad0`), reinicializa motor/combustível/pneus/árvore e roda `005b2f20`, onde
`0055e9b0` grava o setup nas células e registros **e o emissor gera de novo os callbacks x87 do carro**, com decisões que
dependem dos valores (dobra de 0 e 1, compartilhamento de células constantes, dedup de literais). O Stage 10 recuperou o
caminho inteiro (tabela de 184 itens, 29 conversores, funções da garagem, validação de arquivo .sto, ordem de aplicação,
dependências), portou a camada da garagem à mão (bit a bit) e **ergueu o build original inteiro do x86 para Luau** (388
funções), rodando sobre a memória do núcleo. O resultado do build configura os sistemas dos Stages 6–9 (suspensão,
drivetrain, freio, aero) — nenhuma física paralela, nenhum parâmetro inventado.

| Escopo | Entregue |
|---|---|
| Recuperado (Ghidra + execução original) | armazenamento do setup (0xefd bytes, garagem `c03350`, ativo `c055c0`); descritores `c05150`; conversores `00423dc0..004241f0`; garagem `005582d0/00558320/00557e40/005581d0/005580f0/005583e0/00558380`; padrões `00557d20`/`00559950`; .sto `00558da0`/`004247e0`; aplicação `00559360` → build; cadeia derivada `00425ad0`; destinos de cada item (estático + dinâmico); decisões do emissor `0057c8d0/0057c900/0057ca60/005b9970`; pit stop `005601c0/00550f10` (mapeado) |
| Portado à mão (bit a bit) | `NR2003CupSetup`: conversores, garagem, padrões, validação de arquivo — nos dois CWs (0x027f / 0x077f) |
| Erguido do x86 (original) | `NR2003CupBuild*`: `00559820`, `00550c40`, `00550c60`, `00550bc0`, `005b29c0`, `005b2f20` (incl. `0055e9b0`, emissor e back-end), `0054d610` ×4 |
| Estruturas de callback | **imagem** (padrão: estado entregue, bit a bit) · **natural** (código do padrão; verificação estrita = exatamente o código original do setup) · **genérica** (`NR2003CupJITG*`: mesmo emissor sem as dobras que variam entre setups; validada em 121 setups novos) |
| Mudanças em estágios anteriores (documentadas) | `NR2003CupCore`: exporta a imagem de reset e a tabela de callbacks (imagem e callbacks 6/7 inalterados); `NR2003CupDriver`: re-liga as células de freio/inércia após um rebuild (a estrutura genérica aloca constantes em outras posições) |
| Roblox | atributos `Setup_<item>` (unidades da garagem, via `005581d0`), rebuild no reset só quando o setup muda, `SetupStructure/SetupApplySeconds/SetupError`, 1 linha de Output |
| Entrega | `PATCH_STAGE10.lua` (ou `PATCH_STAGE10_PART1..4` + `PATCH_STAGE10_INSTALL`) + `NR2003_Patch_Stage10.rbxmx` (backup + auto-testes 6/7, 8, 9, 10 + reversão), `SETUP_MAP.md`, pseudo-C `recovery/stage10/pseudo/stage10_setup.c`, fontes, testes, fixtures do código original, evidências |

## Números do Cup (original)

184 itens no setup; 129 com descritor; **62 ajustáveis** na garagem do Cup (os demais são fixos — passo 0 — ou derivados).
Padrão do Cup (`00559950`): molas 1300/1300/325/325 lb/pol → **−71 344 / −41 092 N/m** na roda (×175 × 0,56² / 0,85²);
amortecedores 4/4/4/4; camber −2,0/−2,0/0/0°; caster 2,5/2,5°; toe dianteiro −0,125 pol; ride heights 5,0/RF derivado/
6,0/6,0 pol; viés de freio 74 % → Kb **2812 / 988 N·m**; barras índice 4 / 0 → −48 912 / 6200 N/m; track bars 10/10 pol;
combustível 22 gal; marchas 2,133 / 1,611 / 1,261 / 1,000 × **4,500**; direção 18:1; fita 0 %; aerofólio 65°; pesos de
canto 900/900/900/900 lb.

Exemplos (build original em Luau, `setupDump`): molas LF/RF 1700 lb/pol → −93 296 N/m (genérica, 0,41 s); 1ª marcha índice
8 → 2,4118 (natural); diferencial índice 110 → 3,3333; viés 60 % → 2280/1520 N·m; barra dianteira índice 19 → −199 850 N/m;
pressão RF 45 psi → objeto do pneu RF = 45; toe 0,1 pol → `c086b0` −0,001792 rad; track bar RR 12 pol → `c085ac` 0,07877;
mola LF 99 999 → 2500 lb/pol (limite do original, `005581d0`) → −137 200 N/m; camber −2,96° → grade −3,0°.
Aplicar um setup leva **0,17–0,45 s** em Luau nativo (mediana 0,17 s) e não acontece por tick.

## Fidelidade e validação (automática)

- Camada da garagem: 184 descritores, padrões CRT/Cup e **todos os conversores e funções da garagem bit a bit** nos dois
  CWs: toInternal 2346/2344, toDisplay 2433/2443, passos 62, índice 2317/2328, grade 2317/2328, set com grade 2314/2313,
  set com limite 2314/2313, ±1 passo 4634/4656, set por índice 1823/1826, validação de arquivo 30/30 setups.
- Build erguido: passos 1–16 da aplicação (tudo antes do solve gerado) = Unicorn em **69 909/69 909 dwords**; imagem
  reconstruída do padrão = imagem entregue exata fora das 1190 células do passo de solve (+ células variáveis, ≤ 1,3e−7
  relativo); `applySetup(padrão)` restaura a imagem bit a bit.
- **Cada item ajustável no mínimo, máximo e ±1 passo (184 builds: 114 naturais, 70 genéricos)**: estrutura, pool de
  constantes, literais, hash de todas as células exatas = original; células do solve ≤ 6,4e−4 relativo / 2e−5 absoluto.
- 9 setups nomeados (padrão, molas+amortecedores, geometria, peso, marchas, freio+aero+pneus, aleatório, tudo no mínimo,
  tudo no máximo): imagem = build original; **corrida de 8 s** com o driver contra o build natural ORIGINAL de cada setup:
  ticks 1–8 ≤ 4,7e−7 relativo, chassi dentro do envelope dos gêmeos do original, marchas idênticas, resposta ao setup
  (x, vx, z vs padrão) com o sinal e tamanho do original (24 sondas).
- Estrutura genérica: 121 setups novos sem violação (código/pool/literais/slots idênticos); com ela 5 dos 9 setups
  nomeados reproduzem o original na posição final em 4 casas decimais.
- Stage 8/9: `setBrakeBias` (50/61/74/90 %) e `setAeroSetup` (3 pares) gravam exatamente as células/itens do build original.
- Setup inválido (NaN) rejeitado pelas duas estruturas, setup anterior mantido; array malformado recusado.
- Regressão: Stage 6/7 16/16, Stage 8 49/49, Stage 9 59/59 **inalterados**; adaptador sob mock 45/45 (inclui atributos
  `Setup_*` e o auto-teste 10 rápido/completo); patches 6/7, 8, 9, 10 em DataModel simulado 11/11, 13/13, 13/13, 17/17 (inclui a instalação em partes).

## Limites explícitos

- **Estrutura genérica**: para setups cujo resultado do emissor difere do padrão (ex.: mola LF ≠ RF quebra o literal
  compartilhado do padrão), o código usado é o do emissor original sem as 181 dobras que variam; ele difere do código que
  o NR2003 geraria para aquele setup apenas por arredondamento float32 nos pontos em que aquele setup dobraria (ex.:
  cosseno exatamente 1,0 do eixo traseiro). Validado pelas trajetórias contra o build natural original de cada setup.
- **Células do passo de solve do build** (`005b3090` executa o callback gerado, depois `0057dcd0(1)` e `0054d610` ×4): 1190
  células + as células variáveis são calculadas em double (como todo o núcleo desde o Stage 6/7), não em x87 de 80 bits:
  ≤ 6,7e−5 relativo, exceto a célula `ebc390` (apontada por `c083f8`) que alterna entre dois níveis (0,0945872 /
  0,0946477: quase-empate do solve) em 4 dos 184 builds de item (6,4e−4).
- Pit stop (`005601c0`, `00550f10`) recuperado e não portado; relação de direção armazenada/convertida, uso = Stage 12;
  combustível/térmica/desgaste/dano = Stage 11 (valores do build).
- Fora do Cup, outros chassis/séries não foram exercitados (a tabela e o build são os mesmos; os padrões vêm de
  `00559950` com o chassis do carro).

**Validação manual no Studio: pendente** (roteiro em `VALIDACAO.md`). Nada do Stage 11 foi iniciado.

---

# Histórico — Stage 9 (aerodinâmica completa do NR2003 Cup)

**Resumo:** o modelo aerodinâmico original (`00561a80` + `00561b70` → `00410280`, registrado pelo build no callback de
forças do chassi) já executava dentro do núcleo gerado do Stage 6/7, mas **sem ar**: o build do carro não roda o início
de sessão nem a atualização por quadro do carro, então ρ = 0 e os fatores aero = 0 — nenhuma força aero até o Stage 8.
O Stage 9 recuperou e portou essas entradas (clima da sessão `005a3c00` → densidade `005a3ba0`/`005a3be0` e vento;
fatores por quadro `005637e0`; vácuo `005afd80`; itens de garagem fita/aerofólio), validou o caminho inteiro contra o
código original executado e ligou tudo ao carro no Roblox. Força e momento aero entram no **mesmo** solver multibody de
45 estados (força espacial do chassi, nos dois passos de forças de cada tick); suspensão, cargas dos pneus, pitch e
velocidade máxima respondem naturalmente. O host não aplica nenhuma força.

| Escopo | Entregue |
|---|---|
| Recuperado (Ghidra + execução original) | cadeia completa do aero: forças/momentos, curvas de yaw/pitch/proximidade do solo, amortecimento angular, estado de estol (`00410b50`), dano (`00410910`), fita/aerofólio, fatores de vácuo; clima da sessão (opções → `005a3c00` → objeto `e0b728` = `e0b840..e0b84c`), thread/ordem por quadro (`0055bfd0`), vácuo (`005afd80`, `005b0230`, `00567818`, `00516daa`), normal da pista (`0051370a`), alturas/rake de referência (`0055e9b0`) |
| Portado (à mão, bit a bit) | `005a3c00` (subconjunto aero), `005a3ba0`, `005a3be0`, `005637e0` (subconjunto), `005afd80` + `005b0230` + `00567818` + `00516daa`, conversões `00423de0`/`004241d0` dos itens 0x3b/0x3d |
| Já original (gerado, intacto) | `00561a80`, `00561b70`, `00410280` + curvas, `00410910`, `00410b50` — agora com entradas reais e validados |
| Corrigido | 16 células das tabelas de dano aero ausentes das janelas da imagem (restauradas pelo módulo; os módulos gerados não mudaram) |
| Roblox | sessão por atributos (clima, norte da pista, `AeroSession=false`), fita/aerofólio, normal da pista pelos planos de contato, vácuo de TESTE (`DraftTestGap`), telemetria e linha AERO no HUD |
| Entrega | `PATCH_STAGE9.lua` (Command Bar: backup + auto-testes 6/7, 8, 9 + reversão), `NR2003_Patch_Stage9.rbxmx`, fontes, testes, fixtures do código original, evidências, `recovery/ghidra_tools/` (scripts Jython reutilizáveis) |

## Números do Cup (original, sessão padrão 70 °F / sol / dia: ρ = 1,0812 kg/m³)

Atitude estática: Fx/v² = −0,614, Fz/v² = −0,510 (Cd·A ≈ 1,136 m², Cl·A ≈ 0,943 m² de downforce); a 70 m/s
3,0 kN de arrasto, 2,5 kN de downforce, −1,2 kN·m de momento de pitch. Em movimento real a ~75 m/s (atitude e altura de
corrida): ~3,2 kN de arrasto e ~3,2 kN de downforce (≈ 1,39 kN dianteira / 1,85 kN traseira). Velocidade máxima 74,75 m/s
(sem ar: 75,6, no limitador). Chassi 15 mm mais baixo a fundo. Abaixo de 7 pol de altura dianteira o arrasto cai e o
downforce sobe. Derrapando, a sustentação inverte (+6,9 kN a 90° de yaw). Vácuo a 8 m atrás: fator de arrasto 0,874,
dianteiro 0,877. Ar frio/nublado é mais denso (40 °F: 1,1489; nublado: 1,1963).

## Fidelidade e validação (automática)

- Clima → ar `005a3c00`: **1576/1576 vetores bit a bit**; densidade `005a3ba0`: 2500/2500; meio vento `00561a80`:
  600/600; esteira: 3000/3000; vácuo `005afd80`: **3000/3000 anéis bit a bit** (1884 com esteira ativa).
- Força/momento `00561b70`: 5000 vetores (velocidade, yaw até ±180°, pitch, ω, ρ, fatores, alturas, fita, aerofólio,
  dano, estol), 4892 bit a bit, pior 4,5e−6 relativo (intermediários x87 de 80 bits avaliados em double).
- 44 snapshots da máquina original com ar → Luau por 1–2 quadros: 39 estados ≤ 2,8e−4 relativo, cabeça do piloto
  ≤ 1,1e−3, forças dos pneus ≤ 1,5e−3, fatores e marchas idênticos, telemetria aero = original 0 ulp.
- 17 cenários (largada até a velocidade máxima, frenagem a 74 m/s, curva rápida, rodada, frio/quente/nublado,
  vento de frente/de cauda/lateral, aerofólio 45/70, fita 100 % (corrida e garagem), vácuo reto e deslocado, baixa
  velocidade) dentro do envelope de sensibilidade do próprio original.
- Regressão: Stage 6/7 16/16 e Stage 8 49/49 **inalterados** (sem sessão o núcleo é o pós-build exato); adaptador
  sob mock 39/39; patches 6/7, 8 e 9 sob DataModel simulado 11/11, 13/13, 13/13.

## Limites explícitos

Clima dinâmico (`005a4cc0`) mapeado e não portado (clima constante da sessão); vácuo depende de outros carros (interface
pronta, bancada sem outros carros; `DraftTestGap` é só teste); dano aero e efeitos térmicos da fita/ar são do Stage 11;
consulta de pista `0051370a` é do host. Mudança de aerofólio "em corrida" usada só nos cenários de teste.

**Validação manual no Studio: pendente** (roteiro em `VALIDACAO.md`).

---

# Histórico — Stage 8 (modelo de freio completo do NR2003 Cup)

**Resumo:** o freio do carro NR2003 NASCAR/Cup agora segue todo o caminho original: dispositivo → tabela de controles
→ `00552d00` → **`00553080`** (hold automático, rampa de tecla, braking help) → pedal² com rampa de 8 ticks → célula de
freio → **código de forças original gerado no build** (`005610b0` ×4 + `00561040`) → giro das rodas → escorregamento →
forças do pneu → suspensão/transferência de carga → chassi de 45 estados. Nenhuma força de frenagem é aplicada pelo host.

| Escopo | Entregue |
|---|---|
| Recuperado (Ghidra + execução original) | cadeia de entrada completa, viés da garagem (item 0x28 → `0055e9b0`), lei de torque por roda e travamento, âncora de baixa velocidade, temperatura do freio, código morto (`0055e6d0`, `0054f3d0`, `0054f610`) |
| Portado (à mão, bit a bit) | `00553080`, `00552d00`, `00554f50`, `005f7570`, `00550130`, ramo "não dirigido" de `005524f0`, bloco de freio de `0055e9b0` (`setBrakeBias`) |
| Já original (Stage 6/7, intacto) | torque/travamento (`005610b0`/`00561040`), resistência ao rolamento e âncora (`0054cab0`), quadrado/rampa do pedal (`00551e80`/`005539c0`) |
| Roblox | tecla S = ligação digital original; carro vazio freado; atributo `SetupBrakeBias`; telemetria e HUD de freio |
| Entrega | `PATCH_STAGE8.lua` (Command Bar: backup + auto-testes 6/7 e 8 + reversão), `NR2003_Patch_Stage8.rbxmx`, fontes, testes, fixtures do código original, evidências |

## Números do Cup (original)

Torque máximo 3800 N·m; viés padrão 74 % → **2812 N·m por roda dianteira / 987,99994 N·m por traseira**; atrito fixo
10 N·m + 1e−4·ω². A 30 m/s com pedal total: dianteiras saturam em ~2800 N·m sem travar (~5 % de escorregamento),
~12,7 m/s². Com 85 % as dianteiras travam (atrito estático do `00561040`); com 60 % a traseira esquerda trava.
Hold automático parado: 0,98 (atitude < 0,5°) ou nível de rampa (mín. 0,2). **Sem fade e sem ABS no original.**

## Fidelidade e validação (automática)

- `00553080` e dependências: **3000/3000 vetores idênticos bit a bit** ao original; atitude 1500/1500.
- **29 snapshots** da máquina original (início da frenagem, travamento, soltura, parada e hold) → Luau por 1–2 quadros:
  estados ≤ 3,2e−4 relativo, torque/forças por roda ≤ 1,1e−3, pedal e marcha idênticos.
- **11 cenários** (zero, leve, médio, máximo, alta velocidade, tecla com soltura, curva, viés 60/85, quase parado,
  sem piloto) a partir do estado original no início da frenagem: dentro do envelope de sensibilidade do próprio
  original; posições finais a 0–7 mm do original.
- Regressão 6/7 inalterada (16/16, mesmos números); patch e adaptador sob mock.

Única aproximação numérica continua sendo a do Stage 6/7 (intermediários x87 em double). Perto da parada (atrito
estático e limiar de 0,5° do hold) o original é descontínuo; ali a validação é feita pelos snapshots sincronizados.

## Limites explícitos

Evolução térmica do freio/pneu (Stage 11), entrada de volante/acelerador/embreagem por dispositivo (Stage 12 / host),
gravação de replay original. Cliente da bancada só tem teclado (`input.brakeAxis = true` habilita eixo analógico).

**Validação manual no Studio: pendente** (roteiro em `VALIDACAO.md`). Nada do Stage 9 foi iniciado.

---

# Histórico — Stages 6 + 7 (validados no Studio pelo usuário)

O núcleo original NR2003 Cup de 45 estados (suspensão, cubos, rodas, eixo traseiro rígido, motor, embreagem,
outshaft, cabeça) gerado do `NR2003.exe` (9 callbacks x87 + 86 nativas + imagem pós-build) roda no modo `NR2003_CUP`.
Detalhes em `PORT_MAP.md` e `recovery/stage6_7/README_RECOVERY.md`.
