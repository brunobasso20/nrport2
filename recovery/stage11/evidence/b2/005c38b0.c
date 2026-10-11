/* NR2003.exe @ 005c38b0 FUN_005c38b0 */

undefined4 FUN_005c38b0(int param_1,undefined param_2,uint param_3,undefined4 *param_4)

{
  undefined uVar1;
  uint *puVar2;
  int iVar3;
  int *piVar4;
  uint uVar5;
  undefined4 *puVar6;
  
  if (param_3 < 0x101) {
    puVar2 = (uint *)FUN_005cff66(param_1 + 0xb6);
    if (puVar2 != (uint *)0x0) {
      puVar2[5] = 0;
      if (param_3 != 0) {
        iVar3 = 0;
        piVar4 = (int *)(param_1 + 0x1ca);
        do {
          if (*piVar4 == 0) {
            iVar3 = param_1 + iVar3 * 0x104;
            *(undefined4 *)(iVar3 + 0x1ca) = 1;
            puVar2[5] = iVar3 + 0xca;
            break;
          }
          iVar3 = iVar3 + 1;
          piVar4 = piVar4 + 0x41;
        } while (iVar3 < 5);
      }
      if (((undefined4 *)puVar2[5] != (undefined4 *)0x0) || (param_3 == 0)) {
        if (param_3 != 0) {
          puVar6 = (undefined4 *)puVar2[5];
          for (uVar5 = param_3 >> 2; uVar5 != 0; uVar5 = uVar5 - 1) {
            *puVar6 = *param_4;
            param_4 = param_4 + 1;
            puVar6 = puVar6 + 1;
          }
          for (uVar5 = param_3 & 3; uVar5 != 0; uVar5 = uVar5 - 1) {
            *(undefined *)puVar6 = *(undefined *)param_4;
            param_4 = (undefined4 *)((int)param_4 + 1);
            puVar6 = (undefined4 *)((int)puVar6 + 1);
          }
        }
        *puVar2 = param_3;
        puVar2[1] = 0;
        puVar2[2] = 0;
        puVar2[3] = 0;
        puVar2[4] = 0;
        puVar2[6] = 0;
        uVar5 = getIntCount();
        puVar2[7] = uVar5;
        *(undefined *)(puVar2 + 8) = 0;
        *(undefined *)((int)puVar2 + 0x21) = param_2;
        uVar1 = FUN_005c4140(param_1);
        *(undefined *)((int)puVar2 + 0x22) = uVar1;
        iVar3 = *(int *)(param_1 + 0x2a);
        *(undefined *)((int)puVar2 + 0x23) = 1;
        if (iVar3 < 1) {
          *(undefined4 *)(param_1 + 0x2a) = 1;
        }
        FUN_005cff72(param_1 + 0xb6,1);
        return 1;
      }
    }
  }
  return 0;
}

