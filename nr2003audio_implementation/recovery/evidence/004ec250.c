/* NR2003.exe @ 004ec250 FUN_004ec250 */

undefined4 FUN_004ec250(int param_1,int param_2,int param_3)

{
  int iVar1;
  undefined4 uVar2;
  undefined3 uVar3;
  bool bVar4;
  
  iVar1 = *(int *)(param_1 + 0xa0);
  if (param_2 == 0) {
    bVar4 = iVar1 == 2;
  }
  else {
    bVar4 = iVar1 == 1;
  }
  uVar2 = CONCAT31((int3)((uint)iVar1 >> 8),!bVar4);
  if (!bVar4) {
    iVar1 = *(int *)(param_1 + 0xac);
    uVar3 = (undefined3)((uint)iVar1 >> 8);
    if (param_3 == 0) {
      return CONCAT31(uVar3,iVar1 != 2);
    }
    uVar2 = CONCAT31(uVar3,iVar1 != 1);
  }
  return uVar2;
}

