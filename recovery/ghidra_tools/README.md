# Ferramentas Ghidra (Jython) para os próximos estágios

Scripts convertidos de Java para Jython porque o Ghidra 11.1.2 rodando em Java > 21 (aqui Java 26) não carrega scripts
`.java` (`osgi.ee=UNKNOWN` no carregador OSGi). Todos rodam em modo headless, somente leitura, sem análise.
Os scripts Java originais dos estágios anteriores continuam em `recovery/stage6_7/ghidra_scripts/` (referência).

| Script | Argumentos | Saída |
|---|---|---|
| `ExportMemoryPy.py` | `outDir` | um `.bin` por bloco de memória (não inicializado = zeros) + `blocks.tsv`. É o `NR2003_MEM` dos harnesses Unicorn (`recovery/stage6_7/nrx.py`, `stage8`, `stage9`) |
| `ExportSetPy.py` | `outDir addrFile depth` | pseudo-C (`.c`) e assembly com valores das constantes (`.asm`) das funções listadas + chamadas até `depth`, e `index.tsv` (chamadores/chamados). Endereço dentro de uma função → a função; endereço sem função → cria `recovered_xxxxxxxx`. Não sobrescreve `.c` existentes (use pastas novas por lote) |
| `XrefDataPy.py` | `outFile addrFile` | para cada faixa `inicio [tam]`: instruções/funções que referenciam (leitura/escrita/dado) |
| `ListFuncsPy.py` | `outFile inicio fim` | todas as funções com entrada em `[inicio, fim)`: nome, tamanho, chamadores |
| `ScanOperandPy.py` | `outFile chave...` | toda instrução cujo texto contém uma das chaves (ex.: `"+ 0x59e]"` para um deslocamento de struct, `"e0b84"` para endereços absolutos, `"push 0x3b"`) |

Runner: `run_headless.ps1` (Windows) / `run_headless.sh`. Ex.:

```
powershell -ExecutionPolicy Bypass -File recovery\ghidra_tools\run_headless.ps1 -Ghidra C:\tools\ghidra_11.1.2_PUBLIC `
  -Project C:\nr\proj -JavaHome "C:\Program Files\Java\jdk-26.0.2" `
  -postScript ExportMemoryPy.py C:\nr\mem `
  -postScript ExportSetPy.py C:\nr\ev C:\nr\funcs.txt 1 `
  -postScript ScanOperandPy.py C:\nr\scan.tsv "+ 0x5ae]" "0xe0b84c"
```

## Preparação (o que foi necessário nesta máquina)

1. Ghidra 11.1.2 (`ghidra_11.1.2_PUBLIC_20240709.zip`, github.com/NationalSecurityAgency/ghidra) e um JDK ≥ 17.
2. Copiar `OpenNR2003.gpr` + `OpenNR2003.rep` para um caminho **curto** (o projeto entregue fica em pastas profundas;
   Windows + Java + 260 caracteres falham). O projeto pertence a `TChapman500`: `JAVA_TOOL_OPTIONS=-Duser.name=TChapman500`
   (o runner já faz). Use `-readOnly`: o Ghidra atualiza a linguagem x86 V2→V4 em memória e descarta ao sair.
3. Python ≥ 3.12 com `unicorn==2.1.4` e `capstone==5.0.6` instalados com `pip install --target <pasta curta>`; aponte
   `UNICORN_PY` e `CAPSTONE_PY` para ela e `NR2003_MEM` para a saída do `ExportMemoryPy.py`. No Windows, as DLLs do
   unicorn/capstone **não carregam** de caminhos longos (WinError 206). O Python da Microsoft Store não enxerga as pastas
   virtualizadas do app Claude: use um Python instalado normalmente.
4. Verificação: `python recovery/stage6_7/gen_runtime.py` deve reproduzir os 7 módulos de `core/NR2003Cup` byte a byte.

## Armadilhas conhecidas

* Unicorn guarda blocos traduzidos em cache: não reescreva código num endereço que já executou (stubs com endereço próprio).
* `car+4` (anel de ordem de corrida) ≠ 0 faz o `005539c0` original consultar a pista via `005543f0 → 0051370a`; sem pista
  carregada no emulador isso falha. Escreva o anel só em volta da chamada que precisa dele (`005afd80`).
* Funções chamadas por ponteiro (vtables) não aparecem em `ListFuncsPy` como chamadores: procure o ponteiro com
  `recovery/stage9/tools/findptr.py` / `findtables.py`.
* A imagem do núcleo Luau (`NR2003CupImage*`) só contém as janelas tocadas no trace do Stage 6/7; dados lidos apenas em
  ramos não exercitados (ex.: tabelas de dano aero) podem faltar — compare com `recovery/stage9` (`dbg_img` no README).
