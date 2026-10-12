# nr2003carmodel — validação

Referência = o código ORIGINAL do NR2003.exe / rendserv.dll executado no Unicorn 2.1.4 (`recovery/orig_carmodel.py`,
imagem do projeto Ghidra do OpenNR2003 exportada por `ExportMemoryPy.py`) e o rig de referência (`pipeline/nr2003res/rig.py`,
conferido visualmente pelo `preview.py`). Vetores: `recovery/gen_fixtures.py` → `tests/fixtures_carmodel.lua` (e o
subconjunto do Studio `roblox/CarModel/NR2003CarModelGolden.lua`). Suítes: `tests/carmodel_run.luau` (47),
`tests/install_mock.luau` (14). Resultados completos: `tests/RESULTS_CARMODEL.txt`. Nenhuma tolerância foi escolhida
depois de ver um erro: os limites são a precisão f32 do original (1 ulp) ou explicitados abaixo.

**Resultado: 47 / 47 + 14 / 14 PASS; regressão dos estágios 1–13 inalterada.**

## Geometria e escala

| Check | Resultado |
|---|---|
| `NR2003Scale.METRES_PER_STUD` = `TestTune` = `CupTune` (0,28); `Scale.check` recusa outro valor | PASS |
| mapa de eixos (1 m à frente = −Z, à esquerda = −X, acima = +Y); `cframe(t, R) · point(v) = point(t + R v)` (200 poses); inversas | erro máx. 3,2e−14 studs |
| nós 3do das rodas = cubos da física (CupTune `frontZ` / `rearZ` / bitolas, registros de componente originais), sem reescala | 40 nós, erro máx. 4,9e−5 m |
| calibração do import: transformação rígida + escala uniforme arbitrárias recuperadas pelos 4 marcadores | escala 1,700000, erro de centro 5e−15 studs |
| conversão: cada classe 3do lida por inteiro (cursor exato), 14 005 / 26 triângulos concordam / discordam das normais autorais | PASS (conversor) |
| rig Luau = rig de referência em 3 cenários (cockpit com agulhas / volante / câmbio / cabeça e corpo inclinado; chase a 6 m; LOD distante) | 51 peças, 0 divergências de conjunto, posição 2,8e−14 studs, rotação 1e−15 |
| livery: só as geometrias com textura `card` trocam | PASS |

## Grafo (rendserv.dll original)

| Check | Resultado |
|---|---|
| StateSwitch `10011ec0`: todos os conjuntos de valores do modelo, bordas, fora do intervalo | 91 / 91 exatos |
| LodSwitch `100118e0`: os 3 conjuntos de limiares × 28 distâncias × piso 0 / 2 | 202 / 202 exatos (piso só abaixo da contagem de níveis) |
| AnimatedTransform `10012810`: as 8 trilhas do piloto / volante externo, 276 tempos | translação exata, matriz ≤ 1,9e−7 |

## Instrumentos e volante

| Check | Resultado |
|---|---|
| agulhas `0056f040`: 6 calibrações, 276 valores (bordas, fora da faixa, NaN) | 270 idênticos, máx. 0 ulp f32 |
| calibrações = spec do carro na imagem ORIGINAL (`car+0x58a` → +0x148..+0x1a8) | PASS (spec 007238e0) |
| `wheel_speed` `00565b10` (41 taxas, bordas 20 / 60) | 41 / 41 |
| luzes de aviso (faixa de 500 rpm + bit 4 do getBGCount, água > 110, óleo < 30 psi, combustível < 4,5 psi) | PASS |
| volante = clamp(−(relação · esterço), ±2,79); timeValue do piloto | PASS |
| `DrawState.sample` lê as células do fim de quadro ORIGINAL de um núcleo Cup rodando (rpm, esterço, relação, rev limit), sem efeito colateral | rpm 4449, relação 7,0, limite 9300; tick inalterado |
| interpolação `005ba170`: lerp / lerp + wrap / roll pelo caminho curto / giro = prev + taxa · dt · α (wrap 2π) / medidores do registro mais novo | PASS |
| codificação do registro (43 f32, seq, tempo do servidor, getBGCount); rejeita NaN / versão / tamanho | PASS |

## Câmeras

| Check | Resultado |
|---|---|
| `0056a9a0` original vs `NR2003CameraSystem`: 12 poses aleatórias × 14 modos (cockpit, LookLeft/Right com olhar e eixo analógico, F10Near/Far, Chase, Far Chase, Rear chase, Nose, Gearbox, On Car, Roll Bar, F Susp, R Susp) | olho ≤ 1,5e−5 m, rotação ≤ 4,1e−7, FOV / deslocamento / near ≤ 6e−9 |
| suavização do olhar `00569210 / 30 / 50 / 60` (46 valores); conversões de modo `00568e20`; 45° em 0,1 s | exato; contínuo |
| tabelas de ordem `006ec798 / 006ec7f0`; constantes (opção de FOV em graus, limites c5c27c / c5736c, passo, tempo, suavização, zona morta, π/4, 4/π, widescreen 65°, olho, FOV padrão) | idênticas à imagem |
| opção de FOV: 65 → 66° em um passo, satura em 78° / 65° | PASS |
| widescreen (`00587ea2`): cockpit / olhar 65°, demais modos inalterados; FOV vertical Hor+ = 51,077°; FOV horizontal na proporção da tela limitado a 2,5 rad (`00587ed8`, testado em 5:1) | PASS |
| câmeras de pista não substituídas (`compute` → nil) | PASS |
| cliente ponta a ponta (motor Roblox simulado): câmera Scriptable no olho ORIGINAL, FOV vertical do cockpit widescreen, esterço interpolado, V → Roll Bar (FOV do .cam, carro visível), B B → Nose (carro oculto), Z → LookLeft 45° | PASS (erro do olho 0) |

## Instalação no Studio (mock do DataModel)

recusa bancada ≠ Stage 13 e script alterado localmente (nada muda); instalação com os scripts atualizados NA MESMA
instância, pasta CarModel (9 módulos exatos) + DrawState; módulos de física intocados, NR2003Stage = 13; backup só dos
dois scripts + marcadores ADDED; re-execução idempotente; rollback para as fontes publicadas do Stage 13 (CarModel guardado
em ServerStorage); reversão automática com auto-teste falhando; instalador de assets (descritor + modelo importado,
peças ancoradas sem colisão, auto-teste completo com calibração 1,25) e recusa sem marcadores; nunca salva o place —
**14 / 14**. Os scripts do place enviado pelo usuário (`NR2003Client` 18 023 bytes / FNV 4247357387, `NR2003Server`
4742 / 3952310422) conferem com o Stage 13 publicado, então a verificação do instalador aceita esse place.

## Desempenho (Luau CLI 0.741, interpretador, sem codegen nativo)

| Medida | Resultado |
|---|---|
| `rig:update` por quadro (caminhada do grafo + overrides + LOD), cockpit 26 peças / chase 16 peças | 0,19–0,31 ms / 0,18–0,21 ms |
| quadro completo do cliente (registro + medidores + câmera + rig) | 0,24 ms |
| rede | 188 bytes por snapshot (UnreliableRemoteEvent), só servidor → clientes |
| peças por quadro | ≤ 26 MeshParts locais, ancoradas, sem colisão / consulta / toque, movidas por um `BulkMoveTo` |

## Regressão (física e estágios anteriores)

Nenhum arquivo de código do repositório fora de `nr2003carmodel_implementation/` foi alterado (`git diff c64ad5e` só
mostra este diretório e documentação). Execuções nesta máquina:

| Suíte | Resultado |
|---|---|
| Stages 1–5 (`tests/*.lua`, Lua 5.4): check_syntax, baseline, physics, original_core, core_dynamics, geometry, render_snapshots, seat_access, stage5 | 9 / 9 PASS, mesmos números de `tests/RESULTS.txt` (ex.: 14 008 comparações x86, erro máx. 1,19e−7; pico 26,26 km/h) |
| `tools/run_stage13_tests.sh`: rebuild dos entregáveis Stage 12 / 12.1 (sem diferença) e Stage 13 | PASS (byte a byte) |
| Stage 6/7 · 8 · 9 · 10 (setup + build) · 11 · 12 · 13 | 16 · 49 · 59 · 23 + 61 · 66 · 52 · 40 PASS, 0 falhas |
| adapter mock · patch mocks 6/7, 8, 9, 10, 11, 12, 12→12.1, 12.1→13 | 77 · 11, 13, 13, 17, 15, 19, 20, 22 PASS, 0 falhas |
| compilação de sintaxe (core, roblox, PATCH_STAGE13*) | OK; `git status` limpo depois do rebuild (entregáveis 12 / 12.1 / 13 idênticos) |

Log: `tests/REGRESSION_CARMODEL.txt` (saída completa do `tools/run_stage13_tests.sh`, exit 0).

## Checklist manual no Studio (Full HD 16:9)

1. Place do Stage 13 aberto, FORA do Play. Cole `studio/INSTALL_CARMODEL.lua` → "Modelo do carro ORIGINAL instalado",
   auto-teste "9 passed, 0 failed"; `ServerStorage.NR2003Backup_CarModel` com 2 scripts + 2 marcadores.
2. File > Import 3D → `obj/make_a.obj` (Stud). Selecione o modelo, cole `studio/INSTALL_CARMODEL_ASSETS.lua` → "174
   geometrias", auto-teste "11 passed, 0 failed" (escala do import ≈ 1, ortogonalidade ≈ 0, 0 ausentes).
3. Play, entre no carro. O carro da bancada some (só localmente) e aparece o carro #24 original; atributo
   `NR2003CarModelStatus` = "ok".
4. Cockpit: painel, conta-giros e os 5 mostradores no lugar; conta-giros acompanha o rpm do painel da bancada; voltímetro
   ~13,8 V; volante gira com a direção e para no limite do volante do cockpit (opção do Stage 12.1; original 2,79 rad
   ≈ 160°); luz de troca pisca a partir de 500 rpm antes do limite; luz de óleo acende com o motor parado; a agulha de
   água começa no mínimo e sobe com o motor (célula motor+0x4d4, ver CARMODEL_RESULT.md).
5. V percorre cockpit → Roll Bar → F10Near → F10Far → Nose → cockpit; B volta. Em Nose o carro não é desenhado. Em
   F10Near/Far a câmera segue o rumo do carro (não o rolamento), 2,25 m / 4 m acima.
6. Z / C: olha 45° para os lados em 0,1 s e volta. FOV: com `NR2003WidescreenProjection` = true (padrão, 16:9) o cockpit
   fica em 65° como no ramo widescreen do jogo e [ ] não muda a imagem; com false, [ ] / `NR2003CockpitFOV` mudam o FOV
   entre 65 e 78° (e olhar para o lado abre o FOV até 78°, como o original).
7. Rodas: giram com a velocidade, esterçam, sobem/descem com a suspensão; com velocidade alta o borrão das rodas
   (`wheel_speed`) troca de nível.
8. Outro jogador (2 clientes no Studio): vê o carro original do motorista com rodas / esterço / LOD, sem câmera.
9. Saia do carro (X): câmera volta à do jogador; personagem visível de novo.
10. `require(game.ReplicatedStorage.NR2003Lab.CarModel.NR2003CarModelSelfTest).run(true)` → 11 passed;
    `require(game.ReplicatedStorage.NR2003Lab.Roblox.Stage13SelfTest).run(false)` → ok (física intacta).
11. `studio/ROLLBACK_CARMODEL.lua` → "Bancada de volta ao Stage 13 publicado"; Play: a bancada se comporta como antes.
12. Desempenho: com o painel H (render diag) o FPS não cai de forma perceptível em relação ao Stage 13.
