# Recuperação Stages 6–7 — como o núcleo NR2003 Cup foi gerado

Tudo em `core/NR2003Cup/` (exceto `NR2003CupDriver.lua`, portado à mão) é **gerado** a partir do `NR2003.exe` original do projeto Ghidra entregue (`OpenNR2003_Lua_Port_Parcial_Baseline_and_GhidraRealNR2003version.zip`). Nada foi ajustado por feeling.

## Cadeia

1. **Ghidra headless** (`ghidra_scripts/`, `run_headless.sh`): `ExportMemory.java` exporta todos os blocos de memória do programa (`NR2003_MEM`); `ExportSet.java`/`ExportSymbols.java`/`XrefData.java` geram as evidências pseudo-C/asm de `evidence/`.
2. **Execução do código original** (`nrx.py`, `orig_vehicle.py`, `orig_runtime.py`): Unicorn 2.1.4 executa o x86 original a partir da memória exportada. `boot()` roda os 3.560 inicializadores CRT, troca os wrappers SecuROM/APIs por stubs mínimos, `_ftol`/`_CIpow` (criptografados) por equivalentes x87. `build()` repete o caminho do jogo para montar o carro **Cup (série 0, chassis type 2 "spdway")**: spec `0x7238e0`, setup padrão dos descritores (`c03350`/`c055c0`, 00559950/00559820/00425ad0/00425690), motor 00550c40, combustível 00550c60, pneus 00550bc0 + térmica inicial 0054d610, grafo 005b29c0, geração das callbacks 005b2f20/005b3090 (emissor x87 modo 2).
3. **Tradução** (`gen_runtime.py`):
   - `jit2lua.py`: as 9 callbacks x87 que o próprio NR2003 gera (predictor, solve, tire×4, forces, corrector, commit) → Luau linha a linha, quebradas em chunks para codegen nativo;
   - `lift.py`: 86 funções nativas x86 → Luau (blocos básicos, flags com liveness, pilha x87 estática em locais, switch tables, x86 stack virtual);
   - imagem de memória (23 janelas, 163.264 bytes) capturada **depois** do build original → `NR2003CupImage1..2`.
4. **Fixtures** (`gen_fixtures.py`): trajetórias de referência produzidas pelo código original no Unicorn (normal e com perturbação de 1 ulp).

## Fatos recuperados usados no host

| Fato | Evidência |
|---|---|
| CW da FPU do task bg (simulação) = `0x077f` (round toward −∞, 64 bits) reaplicado todo loop | `evidence/0055cef0.c` (bg main de `taskStart(fg=57e070, bg=55cef0, sv=546f80, 36)`), `00567704.asm` |
| Ordem do tick | `005b2190.c`: 005539c0 / 00578da0 / 005544d0 / 005544e0 / 00578de0 / 005544d0 / 00554510, `e843fc` predictor flag |
| Entradas do núcleo `bf6360` | `005539c0.asm`: rampas por tick, toe `c086b0/c086b4`, 00553d70, marcha, limitador `engine+0x438` (9300 rpm) com histerese `006f5a3c` |
| Camada de frame | `00551e80.asm`: acel²/freio², rampas /N (`bf6e9c`=8), cópia `bf6e28→bf6e58`, pedidos de marcha 00552450/00552480 |
| Contato pneu | `00576e00.asm`: `0055e1e0(outF, grip0x1ac·0x1ac, outP, groundVel|d35910, bloco, roda, nx,ny,nz,d, material&0x3fffffff)`; material >16 sem contato |
| Bloco de contato | `005778a0.c`: (re)inicialização do par: âncora = posição do contato, estados = 0 |
| Pose dos componentes | registro +0x32d (posição mundo) / +0x339 (rotação 3×3) — mesmos ponteiros do export/render |
| Import de estado | `005b4560.c` (posições primárias; velocidades são derivadas do momento e não mudam por este caminho) |
| Estado 45 → células | `state_cells.json` (capturado do export 005b2cd0) |

## Reproduzir

```
export NR2003_MEM=<saída do ExportMemory.java>  UNICORN_PY=...  CAPSTONE_PY=...
python3 trace_cells.py        # opcional: refaz cells.pkl (células tocadas por 3 cenários)
python3 gen_runtime.py        # -> out/NR2003Cup*.lua (byte-idênticos aos de core/NR2003Cup)
python3 gen_fixtures.py       # -> tests/stage67/fixtures/*.lua + fixtures_json/
```
