# nr2003carmodel — relatório de implementação (1.1.0-carmodel)

Base: Stage 13 publicado (3.12.0-stage13, `c64ad5e`). Etapa entre o Stage 13 e o Stage 14; **Stage 14 não iniciado**.
Física, direção, FFB e estágios 1–13 **inalterados**: nenhum arquivo do repositório fora de `nr2003carmodel_implementation/`
foi modificado; a instalação no Studio troca só `NR2003Client` / `NR2003Server` (ganchos opcionais, com backup e
verificação por hash) e adiciona `NR2003Lab.CarModel` + `NR2003Lab.DrawState`. Dano: fora do escopo (carro sem dano).

## O que roda agora

```
servidor (por snapshot de render, mesma seq / tempo)   NR2003DrawState.sample: células ORIGINAIS 0x1508..0x15b0 do carro
   (escritas pelo 00551990 do Stage 11; só leitura) + rev limit, getBGCount, relação 00554fb0, limite do volante
   -> UnreliableRemoteEvent DrawState (188 bytes)
cliente (depois de RenderPresentation:update)          registro no tempo de render do corpo, regras de 005ba170
   -> 005662d0: variáveis 3do (cockpitView, luzes, wheel_speed, roof flap, backfire, timeValue), agulhas 0056f040,
      volante clamp(-(relação · esterço), ±2,79), câmbio, cabeça, rodas (z, esterço + π/2, giro)
   -> NR2003CarModelRig: grafo 3do original (switches 10011ec0, LOD 100118e0, animação 10012810), peças locais
      ancoradas sem colisão movidas por workspace:BulkMoveTo
   -> NR2003CameraSystem: 0056a9a0 (cockpit / olhar / F10 / chase / on-car do .cam), 00569450 / 005697e0 / 00568e20,
      opção de FOV em graus (00411850 / 00411860), projeção 4:3 horizontal -> Hor+ (FieldOfView vertical exato)
```

* **Modelo**: `make_a.3do` original do `cup.dat` (174 geometrias únicas, 993 instâncias, 1361 nós, 11 LODs externos,
  cockpit com 34 instâncias), texturas originais (23 MIP DXT1 / DXT3 → PNG), pintura do .car (CTEX → card) — nenhum
  modelo genérico.
* **Escala exata**: `NR2003Scale` (0,28 m/stud = `TestTune` / `CupTune`), sem reescala; os marcadores de calibração
  medem qualquer transformação do 3D Importer; nós das rodas = cubos da física a 5e−5 m.
* **Instrumentos funcionais**: conta-giros, pressão de óleo, temperaturas, pressão de combustível, voltímetro, luzes de
  aviso (troca de marcha piscando com getBGCount, água, óleo, combustível) e volante animado — todos com as equações e
  constantes do original, alimentados pelas células do núcleo (sem dados inventados).
* **Câmeras originais**: cockpit, LookLeft / LookRight (45° em 0,1 s, eixo analógico com zona morta e suavização),
  F10Near, F10Far, Chase, Far Chase, Rear chase, Nose, Gearbox, On Car, Roll Bar, F Susp, R Susp; ordem original
  (V / B); carro oculto em Nose / Gearbox / F Susp / R Susp; FOV do cockpit 65..78° em passos de 1°; 16:9 Full HD pelo
  ramo widescreen do jogo (cockpit 65° em 4:3 → 51,07° vertical).
* **Integração**: aditiva e reversível (INSTALL / ROLLBACK verificados, backup, auto-teste, nunca salva o place);
  sem o pacote de assets a bancada se apresenta como no Stage 13.

## 1.1.0 — correções do teste no Studio

* **Para-brisa / vidros**: o "asfalto" cinza no para-brisa era o `G144_GLASS` (opção "windshield buildup", textura
  `glass.png` com alfa médio 9,8/255: sujeira quase toda transparente) desenhado opaco — o GLB do Blender marcou todos
  os materiais OPAQUE e o Roblox pôs a SurfaceAppearance em AlphaMode Overlay. No NR2003 o alfa da textura base é
  transparência (as áreas com alfa 136 do `card` / `bottom` são exatamente o para-brisa, o vidro traseiro e as janelas;
  a máscara de reflexo é outra textura, `shiny*.mip`). Agora: o conversor classifica cada textura (`alphaTransparent`,
  descritor `g.alpha`), gera **`make_a.glb` direto** (texturas embutidas, `alphaMode` BLEND nas transparentes — sem
  Blender), `map_d` no MTL; o instalador de assets e o novo `FIX_CARMODEL_MATERIALS.lua` põem `AlphaMode =
  Transparency` onde é transparência (para um place já instalado, sem reimportar).
* **Câmera de fora girável** (extensão NÃO original, pedida): botão direito + arrastar / roda / analógico direito giram
  e aproximam as câmeras F10Near / F10Far / Chase / Far Chase / Rear chase em volta do carro; sem entrada = câmera
  original exata; V / B voltam ao original.
* **Retrovisor**: a câmera de espelho ORIGINAL do `0056a9a0` (segundo argumento) foi recuperada e portada
  (`computeMirror`, idêntica ao original em 60 poses) e desenhada no polígono do portal `rearView` por um ViewportFrame
  com o mundo estático refletido (imagem espelhada como um espelho). Aproximações: mapeamento do FOV de 120° no
  retângulo do portal (o código do portal do rendserv não foi recuperado), só peças ancoradas (Terrain não aparece em
  ViewportFrame; formas não simétricas como MeshPart não são espelhadas).
* OBJ com linhas `g` (o importador do Roblox juntava os objetos num "default").

## Desvios e aproximações (documentados, nenhum altera a física)

| Item | Original | Port | Por quê |
|---|---|---|---|
| Deslocamento de frustum (0, −0,125) | projeção fora do eixo | câmera inclinada atan(0,125 · tan(vfov/2)) (`NR2003CameraShift`) | Roblox não tem frustum assimétrico; mesma linha do horizonte no centro, perspectiva levemente diferente |
| Intervalo entre registros | 1 / taskRate (ticks consecutivos) | intervalo entre snapshots (servidor) | o registro chega por snapshot; a regra de 005ba170 é a mesma |
| Suavização do olhar analógico | relógio de CPU entre quadros | dt do quadro de render | mesma fórmula 0,5^(T/dt) |
| Transparência dos vidros | alfa de material × textura (D3D) | `Transparency` = 1 − opacidade 3do + alfa da textura | MeshPart |
| Fator do MIP / cores de material | aplicados pelo renderizador | não aplicados (guardados no descritor) | sem equivalente no MeshPart |
| Retrovisor | câmera de espelho renderizada no portal `rearView` | mesma câmera (exata) num ViewportFrame com o mundo refletido; FOV 120° na largura do portal | sem render target; portal do rendserv não recuperado |
| Câmeras de fora | fixas | fixas por padrão + órbita opcional (mouse / analógico) | pedido do usuário (atributo `NR2003OrbitCamera`) |

## Não feito (com motivo)

* Noite / SelfLighting / faróis: só dia (`day_night` 0). Retrovisor: ver 1.1.0 (aproximações na projeção do portal).
* Câmeras de pista (Sky, Zeppelin, Pit Lane, TV1..3): dependem do sistema de pista — não há substituto (o modo fica sem
  mudança, nunca uma câmera padrão do Roblox).
* Fator de LOD da opção de detalhe do renderizador: 1 (padrão). `make_a_light_cockpit` e `make_a_shadow`: convertidos,
  não ligados. Controle 3 (segurar o conta-giros no valor de pico, `car+0x1518`): não ligado.
* Carros de IA / outros jogadores: só o carro do jogador (foco). Dano: fora do escopo.

## Observação sobre as temperaturas

O caminho de desenho ORIGINAL liga a agulha e a luz de **água** a `car+0x1524` = motor+0x4d4, que o
`STAGE11_STATE_MAP.md` rotula como "temperatura do óleo" (começa em 0 °C na sessão); a agulha de óleo lê motor+0x4a4. O
port segue o original (a agulha de água começa no mínimo e sobe com o motor); os rótulos do Stage 11 não foram mudados
(física intocada) — ver `recovery/CARMODEL_RECOVERY.md` §4.

## Arquivos

Novos (todos neste diretório): `pipeline/**`, `roblox/CarModel/*` (10 módulos), `roblox/Bench/*` (Client / Server com
ganchos), `studio/*`, `recovery/*` (harness, gerador, relatório, evidências), `tests/*`, `tools/build_carmodel.py`,
documentos `*.md`. Alterados fora do diretório: `PORT_MAP.md`, `ROADMAP_STATUS.md`, `CHANGELOG.md` (só documentação). O ZIP
`OpenNR2003_Roblox_CARMODEL_changed_files.zip` (raiz do repositório) traz exatamente esses arquivos, sem nenhum asset
original.
