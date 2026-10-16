# Validação — integração track1

## Resultado

As verificações de track1 executam o código Luau real com o core numérico original e mocks limitados da API Roblox. Não houve execução do Roblox Studio. Os MeshParts que o usuário importou não estão acessíveis a este ambiente; sua decomposição física e suas posições efetivas precisam de confirmação no place.

| Verificação | Resultado |
|---|---|
| Parâmetros de superfície, células originais, bits float32 e runtime térmico/desgaste | 12/12 PASS |
| Adaptador track1, col exclusivo, normais inclinadas, falta de contato e reset | 12/12 PASS |
| Instalador, falhas, reversão, idempotência e ciclo de respawn | 25/25 PASS |
| Regressão do adaptador nativo de Watkins Glen | 15/15 PASS |
| Sintaxe dos módulos, scripts e payloads XML entregues | PASS |

Os testes incluem configuração de asfalto/concreto misturados, preservação das assistências, preparação do host de cliente com as mesmas referências/parâmetros, jogador já existente, avatar sentado, proteção contra fontes incompatíveis, falha de escrita e preservação de edições posteriores na reversão. O teste do host cliente não é uma sessão de rede real.

## Resultado da bancada anterior

A suíte geral de adaptador apresentou **70 PASS / 7 FAIL**. Para distinguir regressão de problema preexistente, o mesmo corpo de testes, sem os self-tests adicionais finais, foi executado com o `CupChassisAdapter` original do commit base: **57 PASS / 7 FAIL**, com os mesmos sete nomes de falha.

As falhas são expectativas de troca de marcha, rampa do freio e defaults de direção/override na bancada antiga, enquanto a branch base já contém os novos padrões de assistências. Elas não foram corrigidas neste patch e não são apresentadas como testes aprovados. Os self-tests numéricos adicionais chamados pela suíte modificada passaram. A comparação não certifica todos os modos de rede ou todo o projeto.

## Preservação de Watkins Glen e do carro

Nenhum módulo em `watkinsglen_implementation/core`, arquivo original de Watkins Glen, tabela original de pneus, implementação de assistências ou protocolo de predição é alterado pelo patch. O módulo `NR2003WatkinsGlen.lua` e o objeto `WatkinsGlenDriverSpawn` permanecem. O novo modo é selecionado por `NR2003Track="track1"` e não chama `loadTrack()` para carregar a pista anterior.

O adaptador recebe pontos de integração opcionais; com track1 desativado, eles não carregam suas configurações nem mudam os contatos do modo anterior. O HUD existente recebe somente uma escolha dinâmica entre o título WG e TRACK1 quando sua linha de título é reconhecida. Os arquivos Rojo recebem o módulo opcional novo, sem ativar track1 automaticamente.

## Conferência no Studio

1. Instalar com Play parado. Confirmar a mensagem com contagem de peças e resolver eventuais avisos de propriedades de fidelidade.
2. Iniciar o Play, entrar no carro e executar `DIAGNOSE.lua` no contexto Servidor. Confirmar seletor track1, ausência de `PhysicsFault`, quatro rodas em contato sobre uma reta, índice 1 no asfalto e 2 onde houver concreto.
3. Verificar que jogador, carro e comando de reset usam `NR2003LabWorld.track1`, e que o spawn antigo de Watkins Glen continua na cena.
4. Rodar as sondas de raycast fornecidas no pacote V2. Comparar pontos e normais nas quatro curvas, transições de banking e emendas. A colisão do Roblox é aproximada mesmo em PreciseConvexDecomposition.
5. Testar a condução, pressão, temperatura e desgaste, incluindo uma transição entre materiais, com o mesmo setup do carro.
6. Se a sessão usa predição, conferir também faltas de contato e correções cliente/servidor em velocidade e com streaming. O agrupamento persistente da colisão evita sua remoção por distância, mas não prova determinismo das consultas ou desempenho suficiente.

A calibração de grip específica de Indianapolis permanece pendente por falta de um arquivo original de parâmetros dessa pista. Os padrões entregues são os materiais e parâmetros gerais recuperados do NR2003. Funcionalidades nativas de seções, racing line, boxes e barreiras não fazem parte deste host de malha.

## Reproduzir os testes

Requer Python 3 e Luau CLI. Os comandos geram somente mocks locais e o instalador:

```bash
python3 tools/track1_patch_rules.py
python3 tools/build_track1.py
python3 tools/make_adapter_mock.py --track1
luau -O2 --codegen tests/track1/surfaces.luau
luau -O2 --codegen tests/track1/generated_adapter.luau
python3 tools/make_track1_tests.py
luau -O2 tests/track1/generated_installer.luau
python3 tools/make_adapter_mock.py --track
luau -O2 --codegen watkinsglen_implementation/tests/adapter_track.luau
```
