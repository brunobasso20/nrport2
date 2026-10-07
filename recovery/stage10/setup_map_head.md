# Mapa de setup — Stage 10 (garagem → parâmetros de tempo de execução)

Carro de referência: NASCAR/Cup do NR2003 (spec `0x7238e0`, chassis type 2 "spdway", série 0). Setup assimétrico de oval
mantido como no original (nada foi neutralizado). Gerado por `recovery/stage10/gen_setup_map.py` a partir da tabela de
descritores original (`c05150`), do mapa semântico (`recovery/stage10/setup_semantics.py`), da análise dinâmica de
destinos (`recovery/stage10/evidence/item_destinations.json`: um passo de garagem → build original → diferença de
memória) e das fixtures de teste (`tests/stage10/fixtures`).

Legenda de status: **ORIGINAL** (lógica do NR2003: tabela, conversão, build, recuperados do executável e executados em
Luau), **ROBLOX ADAPTER** (fronteira do host: atributos, orquestração, telemetria), **PROVISIONAL** (estágio futuro).
Confiança = quão firme é o **nome/semântica** do item (a conversão e o destino numérico são sempre os do original):
alta = rótulo da UI/telemetria + uso em tempo de execução; média = uso + unidade sem rótulo; baixa = só armazenado.

## Caminho original recuperado (pseudo-C resumido; evidências em `recovery/stage10/evidence`)

```c
/* armazenamento: struct de setup de 0xefd bytes = 184 dwords (item i em +4*i; float = bits IEEE single, int = int32)
   + nome/notas + chassisInfo (+0xef1). Garagem = c03350, ativo = c055c0 (00557d60(i) = &ativo[i]).               */
struct SetupItemDesc { u16 type; /* 3 int, 4 float */ u32 min, max, step, deflt; /* unidades de exibição */
                       u32 (*toInternal)(u32 display); u32 (*toDisplay)(u32 raw); };   /* c05150: {u16 kind, desc*}[184] */

/* padrões */ 00557d20: for i: s[i] = desc ? desc->toInternal(desc->deflt) : 0;      /* inicializador CRT, CW 0x027f */
              00559950(chassisInfo): completa o padrão do carro (004254d0 combustível = spec+0x24, marchas,
                                     00424490 batentes, ride heights...)                 /* s[0x31], s[0x89..0x98] */
/* garagem */ 005582d0 passos = fist((max-min)/step + 0.1f); 00558320 índice = fist((disp-min)/step + 0.1f)
              (float: FSTP float32 + FISTP com o CW corrente: 0x027f arredonda ao par, 0x077f para baixo; int: idiv);
              00557e40 valor na grade; 005581d0 set = toInternal(clamp(grade(disp))); 005580f0 idem (retorno sem clamp);
              005583e0 ±1 passo (clamp; muda só se o índice muda); 00558380 set por índice (sem clamp)
/* arquivo .sto */ 00558da0: for item com desc: s[i] = toInternal(clamp(toDisplay(s[i]), min, max)) (sem grade);
                   004247e0 (modos 1/5 em 00871ad4): trackBar LR <= RR
/* aplicação (00559360 no início da sessão): ativo = garagem (cópia 0xefd); bgRequestFGAction(00559400);
   00559820 -> 00425ad0; 00550c60. O build do carro (task de primeiro plano) roda a sequência abaixo:          */
00425690(c03350); 00425690(c055c0)            /* índices de marcha -> relações (ré negativa, neutro 0)            */
0051a730(slot+0xc, spec[0], spec[0x26])        /* conjunto motor/marchas (lê a GARAGEM c03350)                    */
00559950(c055c0); 00559950(c03350)             /* completa o padrão Cup                                            */
00559820(c03350); 00559820(c055c0)             /* 00425ad0: 0x5b, 0x5c = 0x31*k, temperaturas 0x4b..0x56 = 295,37 K,
                                                  0x47..0x4a = pressões, 0x57..0x5a = 0, 0x62 peso total; depois
                                                  00425690 marchas, 004257a0 barras (0x63/0x64, 0x5d), 00425900
                                                  amortecedores (0x81..0x88, tabela 00721ff0), 00425a30 ride RF =
                                                  LF + (RR - LR) na grade, 00424860 pesos de canto, perches, camber
                                                  estático, alturas de referência aero, deflexões (0x8d..0xb5)      */
00550c40()                                     /* 0051a020(motor, 10.0): torque/atrito do motor, limitador         */
00550c60()                                     /* massa de combustível (item 0x31) no double ofuscado              */
00550bc0(slot)                                 /* 0054c1c0 x4 + 0056ed60 perfil: objetos de pneu (pressão +0)      */
005b29c0()                                     /* árvore de 16 componentes                                         */
005b2f20(raiz, bf6d40):                        /* setup -> células + geração dos callbacks x87                    */
    0057dcd0(0); 0057c930(); 0055e9b0();       /* 0055e9b0: lê c055c0 e grava molas 0074e0a0, batentes 0074e0b0/
                                                  0074e0d0, borrachas 0074e0c0, amortecedores 0074e0e0/0074e0f0 +
                                                  curvas, barras (células var. 0074e788/c), freio Kb (c0850c..),
                                                  toe c086b0.., track bar c085ac, perches c083b0.., caster/camber nos
                                                  registros dos cubos, lastro, alturas aero c084c8/cc, rake c083c4  */
    0057c990(e84474..e84494, 0); 005b4060(raiz); 005b4560(raiz); 005b3f50(raiz); 005b2fb0(raiz); 005b9ce0();
    0057dcd0(2); 005b3090(raiz) /* executa o callback de solve gerado */; 0057dcd0(1);
0054d610() x4                                  /* propriedades do pneu por quadro (térmica = Stage 11)             */
/* tempo de execução: só 0x29/0x2a (toe, via c086b0 por 005539c0), 0x3b/0x3d (fita/aerofólio, 00410280), 0x30
   (relação de direção, 00554fb0 = Stage 12) e combustível/temperaturas/desgaste (Stage 11) são lidos do setup ativo;
   o resto chega à física pelas células gravadas no build. Pit stop: 0040e1c0 -> 005581d0/005580f0 -> 005601c0
   (track bar/cunha: c085ac/registros + células c08490/c081f0/c08534/c08664) e 00550f10 (pressão: pneu +0,
   reinício térmico) = mudança em corrida sem rebuild (mapeado, não portado: pit stop é de estágio posterior).    */
```

**Reinicialização:** toda mudança de garagem exige o rebuild do carro no original (garagem → pista); só os itens de
pit stop (track bar, cunha, pressões, combustível, fita) mudam em corrida pelo caminho `005601c0`/`00550f10`.
No port: `applySetup` = rebuild original + reset do carro (como sair da garagem).

## Estrutura dos callbacks (por que existem duas)

O emissor original gera o código x87 dos callbacks em **todo** build e decide pelos **valores** do setup:
`0057c8d0` (célula == 0 → elimina o termo), `0057c900` (== 1 → elimina a multiplicação), `0057ca60` (constante: reusa
a célula / compartilha a célula 0,0 ou 1,0 / cria célula) e `005b9970` (dedup de literais por valor; quirk original:
a busca começa abaixo do topo, nunca casa com o último literal). Logo, o código de um setup pode diferir do código do
padrão. O port tem:

- **natural** — as 60.358 decisões e 1.690 literais do padrão (o código do Stage 6/7, `NR2003CupJIT*`). Um setup cujo
  próprio resultado do emissor é idêntico ao do padrão (verificado decisão a decisão durante o build, modo estrito)
  usa esse código com as células reconstruídas: **é exatamente o código original desse setup**.
- **genérica** — o mesmo emissor com o resultado "não dobra" nos 181 eventos cujo resultado varia entre setups
  (busca em 281 setups: padrão, cada item no mínimo e no máximo, aleatórios; literais por classes de valor: 187;
  pool de constantes 4711/5000; literais até `ebf8fc` < `ebfc7c`). Validada em 121 setups novos: código, pool,
  literais e slots idênticos, 0 violações. Difere do código original do setup só por arredondamento float32 nos
  pontos onde esse setup dobraria (ex.: `0057c900` em `0x72a18e` = cosseno 1,0 do eixo traseiro: o original mantém o
  intermediário estendido, a genérica o grava em float32). Usada só quando a natural não representa o setup.
- **imagem** — o padrão aplicado restaura a imagem entregue bit a bit (estado exato dos Stages 6–9).

## Itens

