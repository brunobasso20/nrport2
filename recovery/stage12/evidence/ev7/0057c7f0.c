/* NR2003.exe @ 0057c7f0 FUN_0057c7f0 */

void FUN_0057c7f0(void)

{
  uint uVar1;
  uint *puVar2;
  uint *puVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  
  iVar4 = 0;
  iVar6 = 0;
  puVar3 = &DAT_00d35b1e;
  do {
    iVar5 = *(int *)((int)&DAT_00d37cc8 + iVar6);
    *puVar3 = 0;
    if (iVar5 == 2) {
      uVar1 = *(uint *)((int)&DAT_00d37ccc + iVar6);
      iVar5 = 0;
      *puVar3 = uVar1;
      puVar2 = &DAT_00d37ccc;
      do {
        if ((((iVar4 != iVar5) && (puVar2[-1] == 2)) &&
            (puVar2[-5] == *(uint *)((int)&DAT_00d37cb8 + iVar6))) && ((*puVar2 & uVar1) != 0)) {
          *puVar3 = *puVar3 | *puVar2;
        }
        puVar2 = (uint *)((int)puVar2 + 0x1d);
        iVar5 = iVar5 + 1;
      } while ((int)puVar2 < 0xd39527);
    }
    puVar3 = (uint *)((int)puVar3 + 10);
    iVar4 = iVar4 + 1;
    iVar6 = iVar6 + 0x1d;
  } while ((int)puVar3 < 0xd36384);
  return;
}

