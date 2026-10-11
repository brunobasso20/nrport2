# Recuperação do Stage 12 — como reproduzir

Cadeia de direção do NR2003 Cup: portada à mão do x86 (`core/NR2003Cup/NR2003CupSteering.lua` + linhas do Stage 12 em
`NR2003CupDriver.lua`) e validada contra o código original executado no Unicorn. Relatórios na raiz:
`STAGE12_RECOVERY.md` (o que foi recuperado e por quê), `STAGE12_STEERING_STATE_MAP.md` (cada estado),
`STAGE12_VALIDATION.md` (método, resultados, o que falhou primeiro e por quê), `STAGE12_RESULT.md`.

## Ferramentas

Python 3 + Unicorn 2.1.4 + Capstone, Luau CLI 0.741 (`--codegen`), Ghidra 11.1.2 (headless, scripts somente leitura em
`recovery/ghidra_tools/`) sobre o projeto Ghidra do `NR2003.exe`. Variável `NR2003_MEM` = exportação de memória do
projeto (usada pelo harness desde o Stage 6/7).

## Arquivos

| Arquivo | Papel |
|---|---|
| `orig_stage12.py` | harness: `OriginalStage12` = harness do Stage 11 + o `00552720` original (stub no lugar do call de `005524f0` @`005525c8`; o resto do ramo do jogador / não dirigido de `005524f0` é host Python, com o `00553080` original do Stage 8) e a cauda de `00551e80` (`00552082..00552336`) executados do exe (stubs em `0xf7f060..0xf7f0f0`; resultado x87 guardado com `FSTP tbyte`; `ctl_remove_cache` antes de parar no meio de `00551e80`); `host_steer_devices` (mesmas células de controle do port); `set_steer_options` chama os setters ORIGINAIS |
| `scenarios12.py` | 10 cenários (sessão, duração, lei de controle por quadro, opções) |
| `gen_units12.py` | L1: vetores das funções originais → `tests/stage12/fixtures/units.lua` + `fixtures_json/units.json` |
| `gen_fixtures12.py` | L2–L4: snapshots de início de quadro rastreados (ganchos de memória do Unicorn), reinícios de estado completo (12 gêmeos de um quadro), linhas a cada 0,25 s + 14 gêmeos (`PERTURB`), horizontes (`HORIZON`) |
| `evidence/ev1..ev14` | exportações do Ghidra (pseudo-C + asm com constantes, `FUNCS.txt` = funções da exportação) |
| `evidence/funcs_*.tsv` | listas de funções por faixa |
| `evidence/reports/` | relatórios de pesquisa: `bit25.md` (modo arcade / hardcore), `setupitems.md` (item 0x30, itens 0x3a / 0x9f..0xa4 = diferencial), `hubgeometry.md` (eixo de esterço, sem Ackermann / bump steer), `ffbinterface.md` (interface do Stage 13), `uiconv.md` (conversões do front end, mensagens, CW) |
| `evidence/reverse_restart_notdriven.txt` | prova do horizonte `notdriven` (código original continuado do estado do port) |
| `dev/` | diagnósticos: `probe.py` (sondas), `dumpcells.py` / `cmpcells.py` (células por quadro original × port), `rowdiff.py` / `envcheck.py` (linhas L4 × envelope), `allframe.py` (gêmeos 'all'), `nosteer.py` (mesmo cenário sem direção), `reverse.py` (reinício reverso: original a partir do estado do port; usa `tests/stage12/dev/dumpmem.luau`) |

Diagnósticos Luau: `tests/stage12/dev/` (`rows.luau` linhas do port, `dumpmem.luau` memória do port no quadro R,
`l2diff.luau`, `dumpcells.luau`, `determ.luau`, `design.luau` (desenho de leis de controle no port), `smoke.luau`).

## Sequência

```
py gen_units12.py                                     # L1 (~1 min)
py gen_fixtures12.py -j 4 ../../tests/stage12/fixtures   # L2-L4, 10 cenários x 15 execuções (~25 min em 4 núcleos)
luau -O2 --codegen ../../tests/stage12/run.luau          # suíte do Stage 12 (~70 s)
py ../../tools/build_stage12.py                          # Stage12SelfTest + PATCH_STAGE12 (+ partes, rollback) + rbxmx
sh ../../tools/run_stage12_tests.sh                      # tudo: build, mocks, suítes 6/7-12, sintaxe
```

Reinício reverso (prova de horizonte), a partir da raiz do repositório:

```
cd tests/stage12/dev && luau -O2 --codegen dumpmem.luau -a notdriven 0 > /tmp/m0.txt
luau -O2 --codegen dumpmem.luau -a notdriven 288 > /tmp/m288.txt && cd ../../..
NR2003_MEM=... py recovery/stage12/dev/reverse.py notdriven 288 /tmp/m288.txt /tmp/m0.txt 144 /tmp/rev.json 1 201,202,203,204
```
