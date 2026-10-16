# track1 — Indianapolis V2 no port NR2003

**Instalador 1.0.1:** corrige o erro de backup com mais de 200.000 caracteres. O registro agora usa blocos de até 150.000 bytes e a reversão remonta esses blocos. Para substituir uma tentativa que falhou, pare o Play, remova **somente o módulo instalador antigo `Workspace.NR2003_Track1`**, insira o novo `NR2003_Track1.rbxmx` e execute novamente o mesmo comando. Preserve `vis`, `col`, o carro e os backups existentes; não é necessário reimportar a pista. A mensagem de sucesso identifica `track1 v1.0.1`.

Patch para a pista já importada em pastas chamadas `vis` e `col`. Base: branch `assist_implementation`, commit `0731d03ce0086a0b68025ed600ff4957a426f933`, que inclui Watkins Glen, o patch 1.2.0.1 e as assistências atuais. Nenhum arquivo de física de pneus, carro, assistências, predição ou mundo nativo de Watkins Glen é substituído.

## Instalar no Studio

1. Pare o Play. Abra a cópia de teste que já contém o carro, `NR2003Lab`, `NR2003LabWorld` e a nova pista.
2. Extraia este ZIP e insira `NR2003_Track1.rbxmx` no **Workspace**.
3. Na barra de comando, execute:

```lua
require(workspace.NR2003_Track1)()
```

4. Inicie o Play. O carro passa a iniciar/resetar em `track1`; o jogador também usa esse respawn.
5. Entre no carro e execute `DIAGNOSE.lua` na barra de comando em contexto **Servidor**. Confira no HUD o nome TRACK1, contato das quatro rodas e superfícies 1/2.

O instalador procura exatamente um grupo `vis` e um `col`, incluindo pastas aninhadas. Se houver nomes duplicados, ele recusa a alteração. É possível passar referências explícitas: `require(workspace.NR2003_Track1)({visual=SEU_GRUPO_VIS, collision=SEU_GRUPO_COL})`.

O instalador faz inserções pequenas e verificadas no `CupChassisAdapter`, preservando o restante de sua fonte, inclusive as alterações locais de predição. Um adaptador incompatível é recusado antes das escritas. Fontes e propriedades alteradas ficam em `ServerStorage.NR2003Backup_Track1`; uma falha de instalação reverte as alterações feitas. O patch não salva nem publica o place. Após conferir, salve sua cópia de teste conforme preferir.

## O que é criado e configurado

- `Core.NR2003Track1Surface`: carrega os parâmetros de pista nas células usadas pelos cálculos originais.
- `Roblox.NR2003Track1`: contato por raycast restrito a `col`, origem do carro, respawn do jogador e telemetria.
- `NR2003Lab.Track1Config`: parâmetros independentes e referências para os grupos reais da cena.
- `Workspace.NR2003LabWorld.track1`: um `SpawnLocation` próprio, invisível e fora das consultas dos pneus.
- `Workspace.NR2003Track1Collision`: Model persistente que passa a conter a pasta `col`. Isso preserva suas instâncias e CFrames e mantém a colisão disponível para clientes com streaming. A pasta `vis` fica em seu local atual.

As peças de `vis` ficam ancoradas, visíveis, sem colisão e sem consulta. As de `col` ficam ancoradas, invisíveis, consultáveis e colidíveis, com `NRSurface=1` para asfalto ou `2` para concreto. Marcas de concreto existentes são preservadas; peças sem classificação recebem asfalto. O multiplicador de contato `NRGripMultiplier` é preservado quando válido e recebe 1 quando ausente.

O instalador tenta definir `RenderFidelity=Precise` no visual e `CollisionFidelity=PreciseConvexDecomposition` na colisão. Se o Studio recusar essas propriedades, ele imprime os objetos afetados para ajuste manual. A decomposição continua sendo aproximada e precisa de conferência no Studio.

## Posição e direção do respawn

O instalador procura uma região quase plana da malha importada, preferindo o oval, e verifica apoio sob a posição inicial das quatro rodas. Não depende da posição antiga de Watkins Glen nem de coordenadas absolutas do scan.

Para mudar o ponto, mova e gire `NR2003LabWorld.track1` sobre uma reta de `col`, mantendo sua direção horizontal. O carro inicia 8 studs à esquerda do marcador, alinhado à sua direção. O próximo reset relê esse marcador. O referencial numérico conserva o eixo vertical do mundo; o banking vem das normais reais de contato, sem inclinar artificialmente a gravidade.

`WatkinsGlenDriverSpawn` e o módulo original são mantidos. O seletor `NR2003Lab.NR2003Track` passa a `track1`; por isso o mundo nativo de Watkins Glen não é carregado neste modo. Ao encerrar o controlador, a preferência anterior de respawn do jogador é restaurada.

## Ajustar asfalto, concreto, calor e desgaste

Edite os atributos de `ReplicatedStorage.NR2003Lab.Track1Config` e resete o carro:

| Atributo | Padrão track1 | Papel |
|---|---:|---|
| `TrackAsphaltGrip` | 1 | Multiplicador do escalar original de asfalto |
| `TrackConcreteGrip` | 1 | Multiplicador do escalar original de concreto |
| `TrackTireHeat` | 1 | Aquecimento relativo da pista |
| `TrackTireWear` | 1 | Desgaste relativo da pista |
| `TrackTireWearLoss` | 0,20 | Perda de grip na curva original de desgaste |
| `TrackTireWearExponent` | 1 | Expoente dessa curva |

São padrões recuperados do NR2003, **não uma calibração comprovada de Indianapolis**. Não há um `track.ini` original de Indianapolis nesta entrega. O patch não transfere silenciosamente os multiplicadores específicos de Watkins Glen (asfalto 1,05; concreto 1,09; calor 1,12; expoente 1,11).

Para marcar setores de concreto, selecione somente as peças de colisão correspondentes e execute `APPLY_SURFACE_SELECTED.lua`. Altere sua variável `SURFACE` para `asphalt` para voltar a asfalto. A classificação é lida na consulta seguinte; mudanças dos parâmetros gerais exigem reset. As peças visuais podem receber materiais visuais separadamente.

O escalar de superfície não é o coeficiente completo de atrito do pneu. Temperatura, pressão, desgaste, carga, camber e slip continuam sendo avaliados pelas rotinas originais. `CustomPhysicalProperties.Friction` não é usado para substituir esse cálculo. Os relevos já presentes na geometria V2 entram pelos contatos; não há aplicação adicional dos bumps próprios de Watkins Glen.

O modo de malha usa o setup Cup padrão mais os atributos `Setup_*` já existentes no carro. O seletor `WatkinsGlenSetup`, seus presets e a tecla K continuam pertencendo ao modo nativo de Watkins Glen; eles não são transferidos automaticamente para track1. Para uma comparação de dirigibilidade, confira e iguale os itens de setup usados nos dois testes. O patch não altera esses atributos nem os valores das assistências.

## Reverter

Pare o Play e execute `ROLLBACK.lua`. Ele restaura o seletor de pista anterior, as fontes modificadas e as propriedades/organização dos grupos. Os modelos importados não são apagados. Os objetos criados exclusivamente pelo patch são removidos.

A reversão recusa sobrescrever campos que você tenha alterado depois da instalação, incluindo fontes, materiais ou o novo marcador. Nesse caso, a mensagem identifica o campo para que você preserve sua edição antes de decidir como restaurá-lo. Não apague a pasta de backup antes de reverter. Reexecutar o instalador já aplicado é uma operação sem alterações.

## Alcance

Este é um host de contato da nova malha com os pneus originais, e não uma conversão de Indianapolis para o formato de seções nativo do NR2003. Não inclui setores, cronometragem, AI/racing line, boxes funcionais ou resposta nativa de barreiras. O recuo provisório de chassis por Blockcast da bancada é desativado apenas em track1 para não criar correções artificiais contra o pavimento. Watkins Glen conserva seu caminho nativo.

Os testes automáticos não executam o Studio nem certificam a decomposição importada, emendas, desempenho, streaming ou sincronismo cliente/servidor numa corrida real. Consulte `VALIDACAO.md` e use as sondas de raycast do pacote V2 para comparar a colisão com a geometria prevista.
