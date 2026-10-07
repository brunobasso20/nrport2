# Recuperação — Stage 10 (setup da garagem → parâmetros de tempo de execução)

Ferramentas: Ghidra 11.1.2 headless sobre o projeto OpenNR2003 (scripts Jython em `recovery/ghidra_tools/`), Unicorn
2.1.4 + Capstone (execução do x86 original; harness do Stage 6/7 `recovery/stage6_7/nrx.py`), Luau CLI.
Variáveis: `NR2003_MEM` (exportação de memória do Ghidra), `UNICORN_PY` / `CAPSTONE_PY` (bindings).

## Arquivos

| Arquivo | Papel |
|---|---|
| `pseudo/stage10_setup.c` | pseudo-C limpo de tudo que o Stage 10 recuperou (armazenamento, descritores, conversores, garagem, .sto, aplicação, decisões do emissor, pit stop) |
| `evidence/b1..b4/*.c, *.asm` | exportações do Ghidra (descompilação + assembly) das funções visitadas |
| `evidence/funcs*.tsv/txt`, `xr*.tsv/txt`, `scan_*.tsv` | listas de funções por região, xrefs de dados (descritores, setups), varreduras de `FLDCW`/CW |
| `evidence/setup_dump.json/.txt` | os 184 descritores do Cup com valores decodificados |
| `evidence/item_destinations.json` | análise dinâmica: um passo de garagem por item → build original → diferença de memória por classe (pneu, registro, global, células) |
| `setup_semantics.py` | mapa semântico dos 184 itens (nome, unidade, conversão, grupo, status, evidência) |
| `orig_setup.py` | harness: build original dividido no ponto de aplicação do setup (`APPLY_CALLS`, = `orig_vehicle.build`) |
| `gen_setup_data.py` | gera `core/NR2003Cup/NR2003CupSetupData.lua` (descritores, constantes, padrões) |
| `gen_setup_vectors.py` | fixtures das conversões/garagem nos dois CWs (`tests/stage10/fixtures/setup_vectors.*`) |
| `trace_apply.py` | pegada de memória da aplicação (leitura-antes-de-escrita / escrita) e alvos de chamadas indiretas |
| `emitter_control.py` | controle das decisões do emissor: `FoldControl2` (chaves de contexto), `LiteralControl`, `TableControl` (tabelas globais; espelho exato dos ganchos Luau; modo estrito = estrutura natural) |
| `generic_search.py` | busca da estrutura genérica (dobras forçadas, classes de literais por vetor de valores) + validação |
| `lift10.py` | extensão do lifter do Stage 6/7: switches de dois níveis, `rep` + string ops, x87 extra, prefixo LOCK, sinal de zero em arredondamento para baixo (`ZADD`), tabelas de bytes do `.text`, recursão, **ganchos de decisão** (`pre` / `branch`) |
| `gen_build10.py` + `build_host.luau` | gera `NR2003CupBuild*.lua` (388 funções originais erguidas, ganchos, tabelas natural/genérica, entradas pré-aplicação) |
| `gen_runtime10.py` | callbacks da estrutura genérica (`NR2003CupJITG*`) com o tradutor do Stage 6/7 |
| `gen_fixtures10.py` | fixtures do build e da dinâmica por setup (`tests/stage10/fixtures/build_fixture.lua`, `items_fixture.lua`, `dyn_fixture.lua`) |
| `gen_setup_map.py` + `setup_map_head.md`/`tail.md` | gera `SETUP_MAP.md` |
| `generic_force.pkl`, `generic_tables.pkl`, `natural_tables.pkl` | resultados da busca/tabelas (reprodutíveis; `footprint*.pkl`, 11 MB cada, não versionados) |
| `build_manifest.json` | resumo do último `gen_build10.py` (partes, pegada, eventos, referências) |
| `dev/` | verificação passo a passo (fixture de ~7 MB não versionada): `make_step_fixture.py` + `run_steps.luau` |

## Regerar

```sh
export NR2003_MEM=... UNICORN_PY=... CAPSTONE_PY=...
cd recovery/stage10
python3 gen_setup_data.py                       # NR2003CupSetupData.lua
python3 gen_setup_vectors.py                    # fixtures das conversões
python3 generic_search.py 60 11 23 37           # dobras forçadas (~30 min, 4 núcleos)
python3 generic_search.py literals 60 11 23 37  # classes de literais + validação em 121 setups novos
python3 gen_build10.py <out>                    # NR2003CupBuild*.lua (~35 min na 1ª vez: pegada de 2 x 107 builds)
python3 gen_runtime10.py <out_core>             # NR2003CupJITG*.lua
python3 gen_fixtures10.py ../../tests/stage10/fixtures fixtures_json ../../core/NR2003Cup
python3 gen_setup_map.py ../../SETUP_MAP.md
```

## Achados principais

1. **Armazenamento e descritores**: setup = 184 dwords (bits float32 ou int32) num struct de 0xefd bytes; tabela
   `c05150` de 184 × {kind, descritor}; descritor = tipo de exibição, mín/máx/passo/padrão em unidades de exibição e o
   par de conversores (29 conversores entre `00423dc0` e `004241f0`).
2. **Aplicação = rebuild do carro**: `00559360` copia a garagem para o setup ativo e pede o rebuild ao task de primeiro
   plano; o build roda `00559820` (cadeia derivada `00425ad0`), motor, combustível, pneus, árvore e `005b2f20`, onde
   `0055e9b0` grava o setup nas células/registros e o emissor **gera os callbacks x87 de novo**.
3. **O emissor depende dos valores**: `0057c8d0` (== 0), `0057c900` (== 1), `0057ca60` (reuso/compartilhamento de
   células constantes) e `005b9970` (dedup de literais por valor, com o quirk de nunca comparar o topo). O código do
   Stage 6/7 é a especialização do setup padrão; um setup diferente pode exigir código diferente.
4. **Estrutura natural + genérica** (ver `SETUP_MAP.md`): a aplicação em Luau roda as funções originais erguidas e
   impõe/verifica as decisões do emissor por índice global (ganchos de decisão = espelho exato do `TableControl` em
   Unicorn). Natural (estrito) = exatamente o código original do setup; genérica = mesmo emissor com "não dobra" nos 181
   eventos que variam; diferença só de arredondamento float32 nos pontos em que o setup dobraria. Bisseção: no padrão,
   um único evento (`0057c900` em `0x72a18e`, cosseno 1,0 do eixo traseiro) muda os números.
5. **Itens não recalculados por `00559820`**: 0x70/0x79 (dentes do neutro), 0x89..0x8c (batentes), 0x95..0x98 (folgas):
   vêm do padrão/arquivo e entram no build como estão (testado com valores aleatórios).
6. **Células alocadas pelo build**: o Stage 8 guardava endereços de células (Kb, inércia) do build padrão; a estrutura
   genérica aloca constantes em outras posições (ex.: inércia articulada `d3b0e8` → `d3b0ec`): o driver passa a re-ligar
   as células após cada rebuild (`V._bindDriverCells`).
7. **CW do build**: o task de primeiro plano não fixa o CW no caminho do build; o port mantém o 0x077f do Stage 6/7, que
   reproduz a imagem original bit a bit (e as conversões da garagem usam 0x027f, como a UI).
