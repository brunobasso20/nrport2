# Recuperação Stage 8 — modelo de freio do NR2003 Cup

Tudo aqui vem do projeto Ghidra original entregue (`OpenNR2003-main (original nr2003 ghidra)`) e da execução do
`NR2003.exe` original no Unicorn. Nada foi ajustado por feeling.

## Ferramentas (esta máquina)

| Ferramenta | Uso | Observação |
|---|---|---|
| Ghidra 11.1.2 headless | export de memória, pseudo-C/asm, xrefs | Java 26: o carregador OSGi do Ghidra 11.1.2 não aceita scripts `.java` (`osgi.ee=UNKNOWN`); portados para Jython: `ghidra_scripts/ExportMemoryPy.py`, `ExportSetPy.py`, `XrefDataPy.py`. Projeto pertence a `TChapman500`: rodar com `JAVA_TOOL_OPTIONS=-Duser.name=TChapman500` |
| Unicorn 2.1.4 + Capstone 5.0.6 | execução do código original, xrefs por bytes, disassembly | `pip install --target` |
| Luau CLI (luau-lang, release atual) | testes | `luau -O2 --codegen` |

Verificação da cadeia: com a memória exportada nesta máquina, `recovery/stage6_7/gen_runtime.py` regenera os 7
módulos gerados do Stage 6/7 **byte-idênticos** (fim de linha normalizado). O núcleo gerado não foi alterado no Stage 8.

```
analyzeHeadless <proj> OpenNR2003 -process NR2003.exe -readOnly -noanalysis -scriptPath ghidra_scripts \
   -postScript ExportMemoryPy.py <mem> \
   -postScript XrefDataPy.py <out.tsv> stage8_xrefs.txt \
   -postScript ExportSetPy.py <evidence> stage8_funcs.txt 1
set NR2003_MEM=<mem>  UNICORN_PY=<site-packages>
python gen_fixtures_stage8.py ../../tests/stage8/fixtures fixtures_json      (~7 min)
```

## Cadeia recuperada (endereços da imagem do Ghidra)

| Etapa | Rotina / dado | Semântica | Evidência |
|---|---|---|---|
| Dispositivo | `0057af30(n)` = f32 `[d35b18+10n]`; `0057af60(n)` = `[d37cc8+29n] != 1`; `0057af40(n)` = valor == 1.0 | tabela de controles do jogo: valor bruto do controle n (5 acelerador, 6 freio, 7/8 direção) e tipo de ligação (1 = eixo analógico; outro = tecla/botão). Imagem de build: todos 0 (teclado) | `evidence/0057af30.asm`, `0057af60.asm` |
| Limitador de eixo | `00552d00(n)` | taxa por eixo `0074c990` = {0.033 direção, 1.0 acelerador, 1.0 freio}, ×2.5 (`0074c99c`) abaixo de 0.025; estado `bf639c+4k`. Freio com taxa 1.0 = passa direto | `00552d00.asm` |
| Velocidade | `00554f50` | `sqrt((vz²+vy²)+vx²)` do bloco de estado `bf6d40`, cache `bf6f44` invalidado pelo contador de interrupção `getIntCount` (`005f7cd0` → `[7559c4]`) | `00554f50.asm` |
| Atitude | `005f7570` = `005f6e40` (quaternion→3×3, stores f32) + `005f74c0` (ângulos, ramo de gimbal 0.01) | out2 = pitch, out3 = roll usados pelo hold | `005f6e40.asm`, `005f74c0.asm` |
| **Pedal** | **`00553080`** (chamado por `005524f0`, `FSTP [bf6eac]`) | (a) `[c067e0]==1` → 1.0; (b) **hold automático**: v < 0.8 m/s e (acelerador < 0.2 ou neutro): plano (\|pitch\| < 0.5°) → sobe 1/12 por quadro até 0.98; rampa → nível `max(0.2,(1−min(1,\|pitch\|·4/11/\|roll\|))·0.98)`; (c) **ligação digital** (tecla): +1/12 por quadro ao apertar, −1/8 (acelerador ≥ 0.5) ou −1/24 ao soltar, limitado 0..1; (d) **braking help** (`00550130`, opção `bf6f04`, padrão 0 = desligada; desabilitada por flag `0x20000000` em `c0692a+0x4c`): ×0.9 abaixo de 11 m/s; acima, alívio pelas somas de escorregamento combinadas por quadro do pneu (`tire+0x2b4`) | `00553080.asm`, `00553080.c` |
| Não dirigido | `005524f0` (ramo `0055a5c0()!=3` / `bf6eb8` / outro carro) | pedal 1.0, embreagem 0, acelerador 0, teclas de troca limpas; `bf6eb9` (carro retido) → 1.0 | `005524f0.asm` |
| Quadro 36 Hz | `00551e80` (já portado no Stage 7) | alvo = pedal², rampa linear em 8 ticks → `bf636c` | `00551e80.c` |
| Tick 288 Hz | `005539c0` + `005b2b90` (Stage 7) | `bf636c += rampa`; cópia para a célula `e84474[3]` → `ebdd4c` | |
| Setup | item 0x28 (descritor `006edf78`: int 50..90, passo 1, padrão 74) → `00423de0` (`pct*0.01f`, CW padrão = nearest → `0x3f3d70a4`) | viés dianteiro | `brake_key_sites.asm.txt` |
| Setup → runtime | `0055e9b0 @0055f314` | `Kb[LF]=Kb[RF]=fd(maxT·b)`, `Kb[LR]=Kb[RR]=fd(maxT·fd(1−b))`, `maxT` = slot `+0x582` = spec `+0x1bc` = **3800 N·m** → **2812 / 987.99994 N·m** | `0055e9b0.c`, `brake_key_sites.asm.txt` |
| Torque por roda | `005610b0` ×4 (`00561090/1230/1250/1270`, registros lfwheel/rfwheel/lrwheel/rrwheel) emite no build | capacidade `C = brake·Kb[w] + 10 + 1e-4·ω² + τ_rr[w]`; demanda `D = M44·ω·288 + τ_y`; `00561040`: `τ = −clamp(D, ±C)` → roda (+0x39d), reação no pai (cubo/eixo) via `005b8fd0`; gravação `0055e450..80` → `tire+0x268` | `005610b0.c`, `00561040.asm`, `00561090.asm` |
| Resistência ao rolamento | `0054cab0 @0054d0cf` | `c081f4[w] += Fz·Crr·R` (zerado por `0055e3e0` a cada passo) | `0054cab0.c` |
| Âncora de baixa velocidade | `0054cab0` (ramo `DAT_00c08284` 0/1) | força longitudinal de âncora do pneu × célula de freio (`*e84480`) | `0054cab0.c` linhas 195–216 |
| Temperatura do freio | `0054f260` dentro de `0054d610` (por quadro) | `T += dt·(|τ·v_banda|/9200 − (T−T_amb)·(√v+1)·0.0036)`, armazenada com XOR (`tire+0x26c ^ +0x274`), build = 295.0 K | `0054f260.c`, `brake_key_sites.asm.txt` |

### Código morto (sem chamadas e sem ponteiros em toda a imagem)

- `0055e6d0`: grava viés por diagonal (LF/RR ou RF/LR). Não há ajuste de viés dentro do carro.
- `0054f3d0`, `0054f610`: leituras da temperatura do freio contra limiares (`tire+0x64` = 400 K, `+0x68` = 550 K) e
  falha aleatória (`rndUniform`). **Resultado: no executável entregue não existe fade nem falha de freio**; a temperatura
  evolui mas não volta para o torque.

### ABS

O carro Cup não tem ABS no caminho de torque. O único auxílio é o "braking help" do piloto (`bf6f04`), desligado
por padrão, portado exatamente.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `orig_brake.py` | harness Unicorn: driver Stage 7 + `00553080` ORIGINAL nativo; `build_with_bias(pct)` refaz o build original com o item 0x28 alterado |
| `image_windows.py` | janelas de memória do núcleo Luau; diff e snapshots |
| `gen_fixtures_stage8.py` | vetores unitários, 11 cenários de frenagem (+gêmeo +1 ulp no início da frenagem), 25 snapshots sincronizados |
| `fixtures_json/` | mesmos dados em JSON |
| `evidence/` | pseudo-C/asm Ghidra das rotinas acima, índices, xrefs (`xrefs_brake_cells.tsv`, `xrefs_hold_flags.tsv`), `brake_key_sites.asm.txt` |
| `ghidra_scripts/` | scripts Jython + listas de endereços usadas |
| `tools/` | `xref_scan.py` (xref por bytes + `call rel32`), `nrdis.py` (disassembly com valores das constantes), `findval.py` (busca de ponteiros em toda a memória) |

Prova de que o viés só mexe nessas células: build original a 60 % vs 74 % — diferença apenas em `c05660` (item 0x28)
e nas quatro células Kb (`ebbfa4..ebbfb0`).
