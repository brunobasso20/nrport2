/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c190 */

undefined4 FUN_0056c190(undefined4 param_1,int *param_2)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  
  iVar3 = 0;
  iVar1 = FUN_0056c030();
  if (0 < iVar1) {
    do {
      uVar2 = FUN_0056c0c0(iVar3);
      iVar1 = FUN_006c6530(param_1,uVar2);
      if (iVar1 == 0) {
        *param_2 = iVar3;
        return 1;
      }
      iVar3 = iVar3 + 1;
      iVar1 = FUN_0056c030();
    } while (iVar3 < iVar1);
  }
  return 0;
}


