Stage 14 Fix 1 — correção do crash informado no Studio

O pacote anterior enviava os contatos dos pneus (índices 0, 1, 2, 3) e outros
estados numéricos diretamente em tabelas de RemoteEvent. Tabelas mistas e
esparsas não mantêm esse formato ao atravessar a rede. O cliente recebia o
checkpoint sem o contato de índice zero e falhava em `NR2003CupTrack`, nas
linhas 346 e 268, ao acessar `fx`.

A correção serializa as chaves como valores em listas densas. Os contatos,
registradores, pilha x87 e demais estados preservam seus índices e tipos.
O solver e as coordenadas de spawn do V6 não foram alterados.

Também foram corrigidos o ciclo de tentativas após falha, a proteção de
inícios/correções adiados e o envio de snapshots antes de existir um listener.
A suspeita de um módulo de build ausente foi descartada após comparação com
as fontes V6: o módulo já estava correto e permanece como dependência verificada.

Instalação, com Play/Run parado:

1. Insira `NR2003_Stage14_Fix1_Install.rbxmx` em Workspace.
2. Execute na Command Bar:

```lua
local backup=game.ServerStorage:FindFirstChild("NR2003Backup_Stage14")
if backup then require(backup.Rollback)() end
require(workspace.NR2003_Stage14_Fix1.Apply)()
```

O rollback original é usado antes da atualização e conserva o backup arquivado.
O instalador recusa fontes editadas e não salva nem publica o place.

Validação realizada: os dois erros antigos foram reproduzidos com o solver
nativo. A nova passagem pelo formato de rede preserva a trajetória e a memória
inteira após restauração/replay. Os testes também cobrem o posicionamento do
carro no pit original, o transporte do personagem existente para a plataforma,
reset, saída/retorno ao banco, falhas adiadas e rollback do instalador anterior.
Roblox e a rede foram representados por doubles; não houve sessão Studio conectada.

Conferência necessária no seu Studio:

- Carro no pit de Watkins Glen e personagem na plataforma de acesso.
- Ao sentar, `tick` avança, `ack` acompanha e a telemetria recebe dados.
- Sem os erros de `fx` e sem repetição de reinicializações a cada segundo.
- Direção, pedais, marchas, R para reset e X/F para sair/entrar.

Não considero o funcionamento completo no Studio confirmado até essa conferência.
Em caso de regressão, pare Play e use o rollback do novo backup:

```lua
require(game.ServerStorage.NR2003Backup_Stage14.Rollback)()
```
