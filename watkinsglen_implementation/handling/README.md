# Watkins Glen — correção de dirigibilidade V5

**Após instalar V5, aplique a [correção road course V6](../roadcourse/README.md).** V5 mantinha a especificação speedway da bancada; trocar o setup não corrigia essa seleção.

Para o place com o Watkins Glen V4 instalado. Pare o Play, extraia o ZIP e insira
**NR2003_WatkinsGlen_HandlingV5.rbxmx** no Workspace. Execute na Command Bar:

```lua
require(workspace.NR2003_WatkinsGlen_HandlingV5.Apply)()
```

O modelo, arquivo e comando usam o mesmo nome V5. Aguarde a mensagem final antes
de iniciar Play. A atualização verifica a instalação V4 e preserva seu backup;
mantém modelos, cockpit, pistas importadas e o Script principal do servidor.
Atualiza o LocalScript original NR2003Client para ampliar a HUD existente.
Fontes com modificações locais desconhecidas fazem a operação recusar antes de
escrever. Não apague backups para contornar essa verificação.

O padrão agora é o arquivo original **fast.cup.sim** da pista, com 22,5 psi nos
quatro pneus e direção 16:1. Para escolher outro setup, fora do Play:

```lua
workspace.NR2003LabWorld.TestCar:SetAttribute("WatkinsGlenSetup", "easy")
```

Opções: `fast`, `easy`, `qualify`, `jasper`. Atributos `Setup_*` existentes continuam
sobrescrevendo os respectivos itens. A direção da bancada 12:1 deixa de substituir
a direção do arquivo da pista. O carregamento reinicializa os campos internos do
setup como o leitor original; os valores do arquivo são carregados sem arredondar
para os passos da interface da garagem. O processamento original do acelerador e
da embreagem é executado no caminho de Watkins Glen, inclusive a progressão do
teclado com controle de tração desligado.

Na HUD, cada pneu mostra o material do contato original, `gSolo` (coeficiente de
superfície carregado pelo jogo), `Fx/Fy/Fz` em newtons e `Fxy/Fz` (força horizontal
produzida dividida pela carga vertical). **Fxy/Fz é o uso naquele instante; não é
o pico de aderência disponível nem um controle de tração.** As forças assinadas
usam o quadro do pneu original. Pneus sem suporte
aparecem como SEM CONTATO e suas forças nesta tabela ficam zeradas.

Compare usando o mesmo setup no NR2003, condições meteorológicas, combustível,
pneus e opções dos controles. O padrão de sessão permanece 70 °F e sem vento;
`WeatherTemperatureF`, `WeatherWindMph` e os demais atributos existentes permitem
igualar a sessão. `SteeringMomentumKeys` permite igualar o momentum dos controles
do original. A HUD informa o setup aplicado e o atraso acumulado da física. O diagnóstico H mostra
frequência de simulação e atraso de apresentação. O piloto ativo usa um buffer
visual menor; a física continua no servidor, sujeita à latência da conexão.

Para desfazer somente esta atualização, fora do Play:

```lua
require(game.ServerStorage.NR2003Backup_WatkinsGlenHandlingV5.Rollback)()
```

Isso restaura o V4. Seu rollback original continua no backup
`NR2003Backup_WatkinsGlen`. Faça o rollback da atualização antes do rollback V4.

Esta correção cobre falhas demonstradas de entrada, setup e apresentação. A
comparação numérica e os limites restantes estão em `VALIDATION.md`; a igualdade
completa de dirigibilidade ainda exige comparação dentro do Studio e do jogo.
