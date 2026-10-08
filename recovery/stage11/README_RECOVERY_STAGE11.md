# Recuperação do Stage 11 — como reproduzir

Térmico / desgaste / dano / combustível do NR2003 Cup: o fim de quadro ORIGINAL (`00554520`) e o dano de colisão
(`00549c40`) erguidos do x86 para Luau e validados contra o código original executado no Unicorn. Relatórios na raiz:
`STAGE11_RECOVERY.md` (o que foi recuperado e por quê), `STAGE11_STATE_MAP.md` (cada estado), `STAGE11_VALIDATION.md`.

## Ferramentas

Python 3.12 + Unicorn 2.1.4 + Capstone 5.0.6, Luau CLI (0.6xx, `--codegen`), Ghidra 11.1.2 (headless, JDK 21) sobre o
projeto Ghidra do `NR2003.exe`. Variáveis: `NR2003_MEM` (exportação de memória do projeto, usada pelo harness do Stage
6/7), `PYTHONPATH` com unicorn/capstone.

## Arquivos

| Arquivo | Papel |
|---|---|
| `orig_stage11.py` | harness: `OriginalStage11` = harness dos Stages 6–10 + fim de quadro original, dano de colisão, sessão (blocos do host, árvore de zonas `00433610`, série, opções, semente, `00550a50`), `collision()`, `race_order`, objeto de colisão do host |
| `scenarios11.py` | 12 cenários (sessão, leis de controle, eventos) |
| `lift11.py` | lifter do Stage 11 (sobre `stage10/lift10.py`): raízes, builtins do host, tabelas de salto com instruções neutras, `mul/imul` de 1 operando |
| `gen_stage11.py` | gera `core/NR2003Cup/NR2003CupFrameCode1..4.lua`, `NR2003CupFrameData1.lua` (suplemento da imagem: células tocadas fora das janelas da imagem 6/7) e `NR2003CupFrame.lua` (de `frame_host.luau`); `frame_manifest.json` |
| `frame_host.luau` | host Luau do Stage 11 (ordem do quadro, sessão, eventos, telemetria, modos `original`/`frozen`) |
| `trace11.py` | rastreio de memória (Unicorn) do código do Stage 11 por cenário → `footprint11_<cenário>.pkl`; `--merge` → `footprint11.pkl`; pseudo-cenário `zonetree` (construção da árvore de zonas) |
| `gen_fixtures11.py` | fixtures: linhas a cada 0,5 s, 10 gêmeos, snapshots sincronizados, início de sessão, reinícios de estado completo (com 10 gêmeos de um quadro cada); `--restarts-only` |
| `pseudo/stage11_runtime.c` | pseudo-C limpo das funções recuperadas |
| `evidence/` | exportações do Ghidra (`b1..b4`: `.c`, `.asm`, `index.tsv`), varreduras de xref, grafo do lift, logs de rastreio e de fixtures |
| `dev/` | diagnósticos: `frames.py` (linhas por quadro; gêmeos `noise`/`tnoise`; CW do x87; modo congelado), `memdump.py` (memória por quadro → `tests/stage11/dev/memdiff.luau`), `restart_twin.py` (sensibilidade de um quadro do original), `restart_probe.py` (fixture de reinícios em quadros escolhidos), `excursion_check.py`, `envelope.py`, `twins.py`, `cmp_frames.py`, `dump_steps.py`, sondas antigas |

## Sequência

```
py trace11.py zonetree launch overrev brakes slide impacts pit enter x4 cold   # ~1 h; footprint11_<c>.pkl
py trace11.py --merge                                                          # footprint11.pkl
py gen_stage11.py ../../core/NR2003Cup                                         # código Luau + suplemento + host
py gen_fixtures11.py -j 4 ../../tests/stage11/fixtures                         # ~45 min em 4 núcleos
luau -O2 --codegen ../../tests/stage11/run.luau                                # suíte do Stage 11
py ../../tools/build_stage11.py                                                # self-test + PATCH_STAGE11 + rbxmx
```

`gen_stage11.py` sem argumento escreve em `out/` (ignorado pelo git). Os diagnósticos Luau ficam em `tests/stage11/dev/`.
