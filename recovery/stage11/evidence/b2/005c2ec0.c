/* NR2003.exe @ 005c2ec0 FUN_005c2ec0 */

void FUN_005c2ec0(int param_1,int param_2,int param_3)

{
  ushort *puVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  
  iVar3 = 0;
  if (0 < param_2) {
    do {
      puVar1 = (ushort *)(iVar3 * 0x10 + param_3);
      iVar2 = FUN_005c3650(puVar1);
      if (iVar2 == 0x20) {
        uVar4 = (*puVar1 & 0x3c0) >> 6;
        iVar2 = FUN_005c2e40(param_1);
        if ((int)uVar4 < iVar2) {
          FUN_005cff2a(param_1 + 0xa2,uVar4 + 1,puVar1);
        }
        iVar3 = iVar3 + 1 + ((*puVar1 & 0x3c0) >> 6);
      }
      else {
        iVar2 = FUN_005c3650(puVar1);
        if ((iVar2 != 1) && (iVar2 = FUN_005c2e40(param_1), 0 < iVar2)) {
          FUN_005cff2a(param_1 + 0xa2,1,puVar1);
        }
        iVar3 = iVar3 + 1;
      }
    } while (iVar3 < param_2);
  }
  return;
}

