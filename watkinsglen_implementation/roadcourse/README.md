# Watkins Glen — correção road course V6

Requer V5 já instalado (instalador completo ou atualização HandlingV5). Não
reimporte pista ou carro. Esta atualização preserva seus backups anteriores.

1. **Pare o Play** e extraia `WatkinsGlen_RoadCourse_Patch_V6.zip`.
2. Insira **NR2003_WatkinsGlen_RoadCourseV6.rbxmx** no **Workspace**.
3. Execute na **View → Command Bar**, uma vez, e aguarde a confirmação **V6**:

```lua
require(workspace.NR2003_WatkinsGlen_RoadCourseV6.Apply)()
```

4. Inicie Play. A HUD deve mostrar **chassi 4** e **pneus 8/8/8/8**.

O V5 mantinha a especificação speedway do carro da bancada, mesmo ao carregar
fast/easy da pista. O original seleciona o chassi road course através do
`chassis_type=4` do track.ini, com outro perfil de pneu. V6 seleciona essa
especificação original e os callbacks correspondentes. Os coeficientes de
asfalto/concreto e a escala de 0,28 m/stud permanecem os do port original.

## Trocar setup

**Fora do Play**, execute, por exemplo:

```lua
local car = workspace.NR2003LabWorld.TestCar
car:SetAttribute("WatkinsGlenSetup", "easy")
print("Setup para o próximo Play:", car:GetAttribute("WatkinsGlenSetup"))
```

O comando imprime a confirmação. Inicie Play novamente para aplicar.

| Nome | Pressão fria dos quatro pneus | Relação de direção |
| --- | --- | --- |
| `fast` (padrão) | 22,5 psi | 16:1 |
| `easy` | 23 psi | 20:1 |
| `qualify` | 24 psi | 16:1 |
| `jasper` | 21 psi | 28:1 |

Também é possível selecionar TestCar no Explorer e editar seu atributo String
`WatkinsGlenSetup` em Properties → Attributes. Atributos individuais `Setup_*`
continuam tendo precedência sobre os itens do arquivo. A HUD mostra o setup
aplicado ao carro; mudar um atributo durante Play não equivale a reconstruí-lo.

Na HUD, `gSolo` é o escalar de superfície. Fx/Fy/Fz são forças no quadro do pneu.
Fxy/Fz é o uso instantâneo de força horizontal/carga vertical, não o limite
máximo de aderência disponível. Sem contato, as forças dessa tabela são zero.

## Desfazer somente o V6

Pare o Play e execute:

```lua
require(game.ServerStorage.NR2003Backup_WatkinsGlenRoadCourseV6.Rollback)()
```

Isso restaura exatamente o V5 anterior. Os backups V5/V4 continuam disponíveis;
para desfazer todos, use os rollbacks na ordem V6, V5 e V4. Não apague backups.

Esta correção resolve a seleção errada demonstrada. **Ainda não certifica
feeling/forças 100% idênticos.** Veja as diferenças numéricas e os testes reais
em `VALIDATION.md`. O pacote não foi pilotado no Roblox Studio neste ambiente.
