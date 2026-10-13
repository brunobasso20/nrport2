# Watkins Glen V4: manter o carro e iniciar o jogador junto à pista

O estado funcional enviado em now.rbxm mantém as fontes originais do carro, com momentumKeys=0. O NR2003Client de ue.rbxm é idêntico ao cliente original. O patch anterior preparava o spawn depois de iniciar o núcleo, sem trazer um personagem que já tivesse nascido no ponto antigo. Esse caso foi reproduzido nos testes e deixava o F fora do alcance do banco.

V4 prepara o carro e o spawn no próprio CupChassisAdapter antes de retornar ao servidor existente. Reposiciona o personagem que já nasceu, configura os próximos spawns, preserva quem já está sentado e limpa as conexões na finalização. O script principal do servidor e o NRClient são preservados, incluindo personalizações. Os módulos do cockpit, modelo, câmeras e controle de entrada também são preservados. A mudança do avatar não entra no cálculo da física do carro.

1. Use o estado que voltou a funcionar. Pare Play/Run e espere comandos anteriores terminarem. Mantenha a pista já organizada e o TestCar.
2. Extraia este ZIP e insira NR2003_WatkinsGlen_Install.rbxmx no Workspace por Insert from File. O nome do Model será **NR2003_WatkinsGlen_InstallV4**.
3. Execute uma vez na Command Bar e espere a mensagem final:

```lua
require(workspace.NR2003_WatkinsGlen_InstallV4.Apply)()
```

Após sucesso, inicie Play. O jogador deve aparecer perto do carro no primeiro pit stall original; aproxime-se do banco e pressione F. Não é necessário reimportar a pista nem substituir o TestCar.

Mantenha qualquer backup existente. Um backup incompleto reconhecido só é arquivado intacto quando o estado anterior foi completamente restaurado. Para backups antigos, isso inclui verificar o antigo alvo do servidor. Uma instalação anterior concluída exige rollback dessa versão antes de atualizar. Se houver recusa, os dados são preservados; copie o erro do Output.

CupTune, momentumKeys=0 e a escala comum de 0.28 metros por stud são preservados. Os dados da pista, código de contato original, superfícies, grip e ondulações não foram alterados por esta correção. São 36 fontes de módulos, sem escrita nos scripts principais do servidor/cliente. O pacote mantém as verificações de origem/escala, integridade, backup e recuperação.

Validação headless: 57 testes do instalador em cada referência (original e estado funcional atual), 15 de spawn/respawn/entrada pelo SeatAccess real e dez com o núcleo original da pista, inicialização, contatos e reset. Isso ainda precisa ser confirmado no Roblox Studio; aparência, direção e desempenho reais não foram executados neste ambiente.
