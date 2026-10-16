# Parâmetros originais usados por track1

As rotinas de pneus e as tabelas recuperadas são preservadas. O novo código fornece geometria, material e parâmetros da pista a essas rotinas; não implementa uma nova equação de atrito.

| Entrada original | Asfalto | Concreto |
|---|---:|---:|
| Índice NR2003 | 1 | 2 |
| Escalar base de superfície | 0,800000011920929 | 0,7680000066757202 |
| Multiplicador track1 inicial | 1 | 1 |
| Escalar carregado inicial | 0,800000011920929 | 0,7680000066757202 |
| Resistência ao rolamento, termo constante | 0,0024999999441206455 | 0,0024999999441206455 |
| Resistência ao rolamento, termo de velocidade² | 6,999999868639861e-7 | 6,999999868639861e-7 |
| Fator de calor por material | 1 | 0,8999999761581421 |
| Entrada da tabela de rigidez de contato | -1.050.000 | -1.050.000 |
| Entrada da tabela de amortecimento | -25.000 | -25.000 |

As duas últimas linhas são valores assinados de tabelas internas, **não valores para copiar nas propriedades do Roblox**. O código original combina as tabelas dos dois materiais participantes; a tabela de pares e o solver continuam no core existente. A resistência final também considera velocidade e pressão, e o calor final depende do estado térmico e da sessão.

O patch recarrega os escalares em `0x74fb30 + 4*índice`, a partir da tabela base `0x6f6570`. Os parâmetros da pista ficam nas células originais:

| Parâmetro | Endereço |
|---|---|
| Desgaste relativo | `0x74b9d8` |
| Calor relativo | `0x74b9dc` |
| Perda de grip por desgaste | `0x74b9e0` |
| Expoente de desgaste | `0x74b9e4` |

As entradas de configuração são convertidas para float32; o produto base × multiplicador usa o arredondamento para baixo do carregador original. Os testes verificam os bits dos exemplos recuperados de Watkins Glen: asfalto ×1,05 → `0x3f570a3d`; concreto ×1,09 → `0x3f564d7f`. Esses exemplos são testes, não os padrões de track1.

`NRGripMultiplier` é um fator do par de contato, separado do multiplicador geral da tabela. O padrão 1 evita multiplicar o mesmo ajuste duas vezes. O material explícito `NRSurface` é passado ao contato original `0055e1e0` nas duas fases do tick; posições e normais são convertidas com 0,28 m/stud. A consulta usa apenas os descendentes de `col` e mantém o estado de contato existente entre ticks.

O core existente mantém slip combinado, resposta dependente de carga/camber, pressão, resistência ao rolamento, calor, desgaste, falhas e force feedback. Não foram criados valores novos para substituir o patch de bump camber ou as assistências já integradas.

Referências do próprio repositório: `core/RecoveredData.lua`; `watkinsglen_implementation/recovery/evidence/surface_tables.json`; `0050fbd0.c`; `00510080.c`; `00510090.c`; `0054cab0.c`; `0054d610.c`; `0054e9f0.c`; `0054ef10.c`; `watkinsglen_implementation/SURFACE_RECOVERY.md`. Esses arquivos são evidência recuperada do executável e não código-fonte Papyrus.
