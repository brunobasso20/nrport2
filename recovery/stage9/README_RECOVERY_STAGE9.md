# Recuperação Stage 9 — aerodinâmica do NR2003 Cup

Tudo aqui vem do projeto Ghidra original entregue (`OpenNR2003-main (original nr2003 ghidra)`) e da execução do
`NR2003.exe` original no Unicorn. Nada foi ajustado por feeling.

## Ferramentas (esta máquina)

| Ferramenta | Uso | Observação |
|---|---|---|
| Ghidra 11.1.2 headless | export de memória, pseudo-C/asm, xrefs, varredura de operandos, lista de funções | Java 26 → scripts Jython (`recovery/ghidra_tools/`); `JAVA_TOOL_OPTIONS=-Duser.name=TChapman500`; projeto copiado para um caminho curto |
| Unicorn 2.1.4 + Capstone 5.0.6 | execução do código original, disassembly, busca de ponteiros/constantes | `pip install --target <caminho curto>` (DLLs não carregam em caminhos longos do Windows) |
| Luau CLI 0.741 | testes | `luau -O2 --codegen` |

Verificação da cadeia: com a memória exportada nesta máquina, `recovery/stage6_7/gen_runtime.py` regenera os 7 módulos
gerados **byte-idênticos**. Nenhum módulo gerado foi alterado no Stage 9.

```
analyzeHeadless <proj> OpenNR2003 -process NR2003.exe -readOnly -noanalysis -scriptPath ../ghidra_tools \
   -postScript ExportMemoryPy.py <mem> \
   -postScript ExportSetPy.py evidence ghidra_scripts/stage9_funcs.txt 1      (e stage9_funcs2..7 em evidence/b2..b7)
   -postScript XrefDataPy.py evidence/xrefs_aero_globals.tsv ghidra_scripts/stage9_xrefs.txt
   -postScript ScanOperandPy.py evidence/scan_aero_operands.tsv "+ 0x59e]" "+ 0x5a2]" ... 
   -postScript ListFuncsPy.py evidence/funcs_0040f000_00411000.tsv 0040f000 00411000
set NR2003_MEM=<mem>  UNICORN_PY=<pylib>  CAPSTONE_PY=<pylib>
python gen_fixtures_stage9.py ../../tests/stage9/fixtures fixtures_json            (~15 min)
STAGE9_SCENARIOS=a,b python gen_fixtures_stage9.py ...   regenera só esses cenários (os outros vêm de fixtures_json)
STAGE9_ONLY=units|smoke                                  só vetores / verificação rápida do harness
```

## Como a cadeia foi achada

1. `00561b70`/`00410280` já estavam no núcleo gerado (Stage 6/7). Probe no emulador após o build original:
   **ρ (`e0b84c`) = 0, fatores `car+0x59e/0x5a2/0x5a6` = 0, objeto de pista `car+0x5ae` = 0** → o núcleo nunca teve
   força aero. Mesmo resultado na imagem Luau.
2. Escritores: varredura de operandos `+ 0x59e]` etc. → `005637e0` (por quadro, zera para 1,0), `005afd80` (vácuo),
   `00529c70`/`0052c640` (inicialização/outros carros). Leitores de `e0b84c`: só `00561b70` e `00554520`.
3. `e0b840..e0b84c` não têm escritor direto: são os campos `+0x118..+0x124` do objeto de clima `e0b728` (o `this` que
   `0055a830` e `0055bfd0` passam a `005a3c00`/`005a4cc0`). Strings das opções (`Temperature`, `WindSpeed`,
   `WindDirection`, `WeatherConditions`, `RealisticWeather`) → registradores `004cc9e0..004ccbe0` → variáveis e getters
   com limites `004cd250..004cd2d0`. Constantes de conversão (`273.15`, `5/9`, `0.447` double) → `005a3c00` →
   `005a3ba0` (densidade) → `005a3be0` (pressão de saturação).
4. Thread: `0055a830 ← 0055b140 ← 0055af80 ← 0055d3ec` e `0055bfd0 ← 0055b450 ← 0055d3f4`, ambos dentro de
   `0055d390`, chamado pelo laço do task de simulação `0055cef0` (CW `0x077f`).
5. Ordem por quadro em `0055bfd0`: clima dinâmico `005a4cc0` → para cada carro: objeto de pista, `005637e0` →
   re-ordenamento do anel por distância na volta → `005b2190` (os 8 ticks).
6. Vetor `+0x24` do objeto de pista: `005f58d0` → `0051370a` grava `(−∂h/∂x, −∂h/∂y, 1)/norma` = normal da superfície.
7. Itens de setup do aero: `00410280` lê 0x20/0x21/0x3b/0x3d por `00557d60`; textos de ajuda do jogo identificam 0x3b =
   fita no radiador e 0x3d = aerofólio traseiro; nenhuma conversão de build os usa (só garagem, IA, `00554520`,
   `0055c830` leitura).
8. Lacuna da imagem: 16 células das tabelas de dano aero (`0071fa00..0071fa3c`) fora das janelas (o trace do Stage 6/7
   rodou sem dano). Detectada pelos vetores com dano; corrigida no `NR2003CupAero` (valores originais restaurados em cada
   reset), sem regenerar os módulos gerados.

## Harness e armadilhas

* `orig_aero.py`: `weather_init` executa o `005a3c00` ORIGINAL no objeto `e0b728` com as settings `c0692a`;
  `car_frame_aero` faz o subconjunto de `005637e0`; `OriginalAero` = `OriginalBrake` + sessão + fatores por quadro.
* Vácuo no emulador: carros falsos no heap com anel `car+4/car+8`, objeto de pista e spec. **Os elos do anel do carro
  do jogador só são escritos em volta da chamada a `005afd80`**: `car+4 ≠ 0` também habilita a cópia de render
  `005543f0` dentro do `005539c0` original, que então consulta a pista (não carregada) e falha.
* **Unicorn mantém blocos traduzidos em cache**: código reescrito no mesmo endereço não é retraduzido. Cada stub de chamada
  tem endereço próprio (`stub_call`).
* Mudança de setup "em corrida" (`setup.at`): aplicada no início do último quadro antes do snapshot, para que o snapshot e
  o gêmeo a contenham (a largada a pleno com 100 % de fita na garagem faz o carro original rodar perto de 20 m/s —
  cenário `tape100build`, mantido).

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `orig_aero.py` | harness Unicorn (sessão original, subconjunto 005637e0) |
| `gen_fixtures_stage9.py` | constantes, vetores unitários, 17 cenários (+ gêmeo +1 ulp), 44 snapshots sincronizados com aero original |
| `fixtures_json/` | mesmos dados em JSON |
| `evidence/` | pseudo-C/asm (`*.c/*.asm`, `b2..b7/`), `index.tsv`, xrefs (`xrefs_aero_globals.tsv`, `xrefs_weather_*.tsv`), varreduras (`scan_*.tsv`), listas de funções (`funcs_*.tsv`) |
| `ghidra_scripts/` | listas de endereços usadas (os scripts Jython estão em `recovery/ghidra_tools/`) |
| `tools/` | `nrmem.py` (leitura/disassembly da memória exportada), `findptr.py`, `findrange.py`, `findtables.py`, `findconst.py` |
