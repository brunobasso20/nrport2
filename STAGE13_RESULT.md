# Stage 13 — torque de direção / force feedback original do NR2003 Cup (3.12.0-stage13)

Base: Stage 12.1 publicado (3.11.1-stage12.1, `5d9f5ee`). Física, cadeia de direção e todos os estágios anteriores
**inalterados**: o FFB é uma saída de apresentação, nada volta para a simulação (prova dinâmica, `STAGE13_RECOVERY.md` §9).
Recuperação: `STAGE13_RECOVERY.md`; células: `STAGE13_FFB_STATE_MAP.md`; validação: `STAGE13_VALIDATION.md`.

## O que roda agora (código original portado à mão do x86, `core/NR2003Cup/NR2003CupFFB.lua`)

```
pneus dianteiros (0055e180 -> 00554e70, já no núcleo desde o Stage 6/7): por passada, deslize relaxado c085dc,
   |Fz| + 0.01, Fy, 0.1 (r x F).z + momento de alinhamento c081ec
por tick (005539c0 @00553a64)      00554d30: médias da última passada (n = 2), carga <= 1500, zera os acumuladores
fim de quadro (00554520, bloco FFB) d = (ec4 - ec0) 36 ; q = ec4 + d (latência 0.001) (1 - 20 / (v_ar + 20))
   m = |ec4| > 1e-5 ? q / ec4 ed0 : ed0 ; ecc = (m - amortecimento d + ecc) / 2
   força = clamp(ecc força_opção / (item 0x30 1600), -1, 1) -> 005d08d0 -> DirectInput: _ftol(força 10000)
controles (00550070 / 0054fed0 / 00550680): bf6eb8 suspende o jogador (ramo não dirigido de 005524f0 + FFB desligado);
   o efeito só é adquirido com o controle 7 num eixo analógico, FF ligado e dispositivo capaz
opções (mensagens 8..11 = valores do controls.cfg): liga/desliga, força 0..100 (80), amortecimento 0..100 (0),
   latência 0..250 ms (0)
```

* **Aritmética x87 exata**: o simulador roda o x87 com CW 0x077f (64 bits, arredondamento para −∞). O modelo double dos
  Stages 6–12 erra um bit gravado em 197 das 26 568 chamadas reais rastreadas no original (até 57 / 1728 = 3,3 % no
  cenário `ratio12`, latência 250 e amortecimento 100); por isso `00554d30` e o bloco rodam em aritmética x87 exata (significando de 64
  bits arredondado para −∞ em cada operação, caminho rápido em double quando a operação é exata). A cópia do bloco
  erguida no Stage 11 (modelo double) é saltada.
* **Integração**: `NR2003CupDriver.tickInputs` chama `00554d30` no lugar original; `NR2003CupFrame` avalia o bloco logo
  depois do `00554520` erguido e roda `00550070(0)` na colocação do carro (@00550b07); `NR2003CupDriver.frameStart` toma o
  ramo não dirigido com `bf6eb8`.

## Decisões de host (ADAPTER — não originais, documentadas)

| Item | Original | Port / Roblox |
|---|---|---|
| Dispositivo | DirectInput: `005d0820` capacidade FF do eixo, `005d0840` aquisição, `005d2bb0` efeito ConstantForce, `005d3010` `SetParameters` | `setForceFeedbackDevice{capable, acquire}` + sink(eixo, força, magnitude); no Roblox o "dispositivo" é o painel (linha FFB) + motores do gamepad; atributo `ForceFeedbackDevice` (padrão da bancada: sim) |
| Pedido ao thread de primeiro plano | `005f79a0` espera o FG rodar `00550000` / `00550060` | chamada direta (o mesmo que o caminho `005f79de` do original) |
| Troca de vínculo | menu de controles + fgmsgSelectActiveControls → `00550070(0)` | a camada de dispositivos do Roblox (Stage 12) re-vincula os controles 7/8 a cada quadro; mudou o tipo do controle 7 com FF ligado / adquirido → `00550070(0)` |
| Piloto sai do banco | (o jogo suspende os controles do jogador por `00550070(1)`) | sem piloto = `setControlsSuspended(true)` entre quadros (antes do Stage 13: só `driver = false`; mesmo ramo do `005524f0`, física igual) |
| Vibração do gamepad | força constante direcional no volante | Roblox não tem force feedback direcional: motor grande do gamepad com intensidade |força| (`CupTune.driver.ffbRumble`, só apresentação) |
| Padrões da bancada | sem controls.cfg: FF desligado, força 80, amortecimento 0, latência 0 | `CupTune.driver`: FF **ligado** com os valores da imagem (80 / 0 / 0), dispositivo presente (o original continua desligado no núcleo sem opções) |

## Classificação de fidelidade

| Elemento | Status |
|---|---|
| `00554d30` (estatísticas por tick) | EXACT · LUA VALIDATED (L1 + L2 bit a bit; L3) |
| bloco FFB de `00554520` | EXACT · LUA VALIDATED (L1 + L2 bit a bit; L4) |
| `00550070` / `0054fed0` / `00550030` / `00550680` | EXACT nas decisões e células (L1 1728 casos, sequência de chamadas ao dispositivo); dispositivo ADAPTER |
| setters das mensagens 8..11 + conversão do controls.cfg | EXACT (L1) |
| conversão do dispositivo `_ftol(força × 10000)` | EXACT (L1 507 forças) |
| portão `bf6eb8` no `005524f0` | EXACT (L4 `suspend`: linhas de observação do Stage 12 dentro do envelope) |
| saída no Roblox (atributos, painel, motor do gamepad) | ADAPTER |

## Não comprovado equivalente / limites explícitos

* **DirectInput em si** (enumeração, mapeamento eixo global → dispositivo `005d2370`, criação do efeito, ganho do
  dispositivo, autocentro desligado) não existe no Roblox; a força entregue é o valor que o original passa ao DirectInput.
  A direção física de uma força constante de um eixo depende do driver do dispositivo (convenção DirectInput: sinal da
  magnitude); no port, força > 0 ocorre com o volante virado para a direita (eixo +) — o mesmo sinal que o original envia.
* Os tipos de vínculo 2 / 4 (teclas / botões do dispositivo) passam por formatação de nomes do front end em `0057aff0`
  (não montada na bancada); o `0054fed0` só testa `tipo == 1` — o port grava 0 (teclas) / 1 (eixo), como no Stage 12.
* O L4 (malha fechada) compara dentro do envelope dos gêmeos do original, não bit a bit: a física por tick herdada dos
  Stages 6–11 difere do x87 em poucos ulps por quadro (`STAGE12_VALIDATION.md`); o FFB depende dela. A parte do FFB é
  bit a bit (L1 / L2).
* A unidade física do amortecimento não foi estabelecida (só o valor 0..100 do controls.cfg); latência em ms (fator 0,001).
* Cópia de telemetria `bf643e` (`bf63d8`, sem leitor) não portada.

## Política do instalador

`PATCH_STAGE13.lua` (ou `PART1..2` + `INSTALL`, ou `NR2003_Patch_Stage13.rbxmx`): confere o Stage 12.1 publicado módulo a
módulo (tamanho + FNV-1a), backup só dos 6 módulos alterados (`ServerStorage.NR2003Backup_Stage13`, criado uma vez) +
marcadores `ADDED:` dos 2 módulos novos, fontes atualizadas na mesma instância, auto-testes 6/7..13 no fim, reversão
automática se algo falhar, nunca salva o place. `PATCH_STAGE13_ROLLBACK.lua` restaura o 12.1 (fontes conferidas por hash)
e remove os módulos novos. As entregas do Stage 12 e 12.1 continuam congeladas (refeitas byte a byte dos commits
publicados).
