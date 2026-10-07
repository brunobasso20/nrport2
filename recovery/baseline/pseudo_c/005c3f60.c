/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005c3f60 */

void FUN_005c3f60(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  
  iVar1 = *(int *)(param_1 + 9);
  FUN_005c32d0(param_1);
  taskGetRate();
  iVar2 = FUN_006c5018();
  iVar3 = (**(code **)(*(int *)(iVar1 + 4) + 0x18))(iVar1);
  iVar4 = (**(code **)(*(int *)(iVar1 + 4) + 0x1c))(iVar1);
  iVar1 = *(int *)(param_2 + 0x10);
  if (*(int *)(param_2 + 0xc) != *(int *)(param_2 + 4)) {
    iVar5 = getIntCount();
    if (((iVar3 - iVar2) + iVar4) * (iVar1 + 1) < iVar5 - *(int *)(param_2 + 0x1c)) {
      FUN_005c3ff0(param_1,param_2);
    }
  }
  return;
}


