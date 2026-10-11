/* NR2003.exe @ 00547f20 FUN_00547f20 */

undefined4 FUN_00547f20(byte *param_1,byte *param_2)

{
  int iVar1;
  int iVar2;
  bool bVar3;
  bool bVar4;
  
  iVar2 = 0x10;
  bVar3 = false;
  iVar1 = 0;
  bVar4 = true;
  do {
    if (iVar2 == 0) break;
    iVar2 = iVar2 + -1;
    bVar3 = *param_1 < *param_2;
    bVar4 = *param_1 == *param_2;
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
  } while (bVar4);
  if (!bVar4) {
    iVar1 = (1 - (uint)bVar3) - (uint)(bVar3 != 0);
  }
  return CONCAT31((int3)((uint)iVar1 >> 8),iVar1 == 0);
}

