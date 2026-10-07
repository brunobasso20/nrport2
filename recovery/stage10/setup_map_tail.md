
## Dependências entre itens (cadeia original)

- **Ride height RF (0x25)** não é ajustável: `00425a30` = LF + (RR − LR), arredondado na grade do item.
- **Stagger (0x41/0x42)** é só exibição: `00424860` sobrescreve com o raio do pneu RF − LF / RR − LR; ajustar não muda
  nenhuma célula do build (DYN).
- **Barras (0x2b/0x2c)** são índices de bitola; `004257a0` gera as taxas 0x63/0x64 (N/m) e o roll couple 0x5d; o build
  grava as taxas em células variáveis (`0074e788/0074e78c`).
- **Amortecedores (0x04..0x07, 0x0c..0x0f)** passam pela tabela `00721ff0` (`00425900`) → coeficientes 0x81..0x88 →
  curvas de amortecimento do build.
- **Molas, cunha, lastro, ride heights, pressões** alimentam `00424860` (pesos de canto 0x5e..0x61, perches 0x91..0x94,
  camber estático 0x8d..0x90, alturas de referência aero 0xad..0xb0, rake 0xb1, deflexões 0xb2..0xb5) → build.
- **Marchas (0x33..0x38, 0x45, 0x46) e diferencial (0x39)** são índices na tabela de dentes `006ed880`; `00425690` gera as
  relações 0x66..0x6e; o objeto do motor (+0x448..+0x468) é preenchido por `0051a730` a partir da **garagem** `c03350`.
- **Combustível (0x31)**: `00550c60` grava a massa de combustível usada pelo build (massa variável do registro); queima
  em corrida = Stage 11.
- **Itens fixos do carro** (0x70/0x79 dentes do neutro, 0x89..0x8c batentes 2400 lb/pol, 0x95..0x98 folga 8 pol) vêm de
  `00559950`/`00424490` e **não** são recalculados por `00559820`: entram no build como estão no arquivo de setup.

## FPU e precisão

As conversões terminam em FSTP/FISTP com o CW corrente: **0x027f** (arredonda ao par; garagem, arquivos de setup,
inicializadores) ou **0x077f** (para baixo; task de simulação, pit stop). `NR2003CupSetup` reproduz os dois modos bit a
bit (incl. −0 em somas exatas a zero sob 0x077f). O build do carro roda no task de primeiro plano; o port usa o CW do
Stage 6/7 (0x077f), que reproduz a imagem original bit a bit (o CW real desse task não é observável no executável).

## Separação de camadas no port

| Camada | Módulo | Natureza |
|---|---|---|
| Garagem / setup do usuário (unidades de exibição) | `NR2003CupSetup` (+ `NR2003CupSetupData`) | ORIGINAL portado à mão (tabela gerada do exe) |
| Conversão setup → tempo de execução | `NR2003CupBuild` + `NR2003CupBuildCode*` + `NR2003CupBuildData*` | ORIGINAL (x86 erguido para Luau; decisões do emissor por tabela) |
| Parâmetros de tempo de execução | memória do núcleo (`NR2003CupCore`, callbacks `NR2003CupJIT*`/`NR2003CupJITG*`) | ORIGINAL |
| Orquestração, inspeção | `NR2003CupGarage` | ROBLOX ADAPTER |
| Atributos `Setup_<item>`, linha de Output | `CupChassisAdapter` | ROBLOX ADAPTER |
| Uso da relação de direção | cadeia de direção | PROVISIONAL (Stage 12) |
| Térmica/desgaste/combustível/dano | Stage 11 | mapeado, não implementado |
