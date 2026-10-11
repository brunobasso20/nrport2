# Recuperação do Stage 13 — como reproduzir

Force feedback (torque de direção) do NR2003 Cup: portado à mão do x86 (`core/NR2003Cup/NR2003CupFFB.lua` + linhas do
Stage 13 em `NR2003CupDriver.lua` e `NR2003CupFrame.lua` / `recovery/stage11/frame_host.luau`) e validado contra o código
original executado no Unicorn. Relatórios na raiz: `STAGE13_RECOVERY.md` (o que foi recuperado e por quê),
`STAGE13_FFB_STATE_MAP.md` (cada célula), `STAGE13_VALIDATION.md` (método e resultados), `STAGE13_RESULT.md`.

## Ferramentas e imagem do executável

Python 3 + Unicorn 2.1.4 + Capstone, Luau CLI 0.741 (`--codegen`), Ghidra 11.1.2 headless sobre o projeto Ghidra do
**OpenNR2003** (`github.com/TChapman500/OpenNR2003`: `OpenNR2003.gpr` + `OpenNR2003.rep`, programa `NR2003.exe`, dono
`TChapman500`). Exportação da memória (`NR2003_MEM`), somente leitura:

```
git clone --depth 1 https://github.com/TChapman500/OpenNR2003.git
GHIDRA=/caminho/ghidra_11.1.2_PUBLIC PROJECT=/caminho/OpenNR2003 sh recovery/ghidra_tools/run_headless.sh \
    -postScript ExportMemoryPy.py /caminho/mem
export NR2003_MEM=/caminho/mem
```

Conferência da exportação (feita neste estágio): o `.text` exportado é igual a `recovery/vehicle_core/00400000.bin` byte a
byte e `recovery/stage12/gen_units12.py` refaz `tests/stage12/fixtures/units.lua` byte a byte.

## Arquivos

| Arquivo | Papel |
|---|---|
| `orig_stage13.py` | harness: `OriginalStage13` = harness do Stage 12 + o FFB ORIGINAL rodando no lugar (`00554d30` dentro do `005539c0` original, bloco FFB dentro do `00554520` original, `00550070` / `0054fed0` / `00550680` e setters `00550270` / `00550290` / `005502d0` / `005502b0` originais). Camada de dispositivo (ADAPTER, DirectInput): `005f79a0` → caminho direto `005f79de`, `005d0820` / `005d0840` / `005d0870` = stubs de bytes do host, `005d08d0` = `ret` + gancho que registra cada chamada (eixo, bits da força). Ramo não dirigido de `005524f0` com `bf6eb8`; troca do tipo de vínculo do controle 7 → `00550070(0)` (como o port). `enter_track13` = subconjunto do `00550a50` + `00550070(0)` @00550b07. `run_ffb_block` executa `0055464c..00554778` no lugar |
| `scenarios13.py` | 7 cenários: 6 leis do Stage 12 inalteradas com o FFB ligado (`slalom`, `brakesteer`, `ratio12`, `linear`, `keys`, `notdriven`) + `suspend` (controles suspensos 6–8 s pelo `00550070(1)` / `(0)`, troca de dispositivo eixo → teclas → eixo 11–13 s) |
| `gen_units13.py` | L1: aritmética x87 exata (referência racional `Fraction` + instruções x87 reais no Unicorn), `00554d30`, bloco FFB, `00550070` / `0054fed0` / `00550680` (estado + sequência de chamadas ao dispositivo), setters, conversão `_ftol(força × 10000)` → `tests/stage13/fixtures/units.lua` + `fixtures_json/units.json` |
| `gen_fixtures13.py` | L2 + L4: chamadas originais de `00554d30` (ganchos @00554d30 / @00553a69) e do bloco (@0055464c / @00554778) na malha fechada, linhas FFB por quadro + 14 gêmeos (`PERTURB` do Stage 12), linhas de observação do Stage 12, sequência de chamadas ao dispositivo |
| `dev/nofeedback.py` | prova dinâmica: duas máquinas originais em passo, FFB ligado × desligado; só as células do FFB diferem (`evidence/nofeedback.txt`) |
| `evidence/dis/` | listagens Capstone da exportação (constantes anotadas) de todas as rotinas citadas em `STAGE13_RECOVERY.md` |

O L3 do Stage 13 usa os reinícios de estado completo **do Stage 12** (`tests/stage12/fixtures/scenario_*.lua`): eles
já trazem as células de `00554d30` do original antes e depois do quadro R (o harness sempre executou `00554d30`).

## Sequência

```
cd recovery/stage13
py gen_units13.py                                        # L1 (~3 s)
py gen_fixtures13.py -j 4 ../../tests/stage13/fixtures   # L2/L4: 7 cenários x 15 execuções (~25 min em 4 núcleos)
py dev/nofeedback.py brakesteer 400                      # prova sem realimentação (~3 min)
cd ../..
luau -O2 --codegen tests/stage13/run.luau                # suíte do Stage 13 (~60 s)
py tools/build_stage13.py                                # Stage13SelfTest + PATCH_STAGE13 (+ partes, rollback) + rbxmx
sh tools/run_stage13_tests.sh                            # tudo: entregas 12 / 12.1 congeladas, 13, mocks, suítes 6/7-13
```
