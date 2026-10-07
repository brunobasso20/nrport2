/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577a20 */

undefined4 __fastcall FUN_00577a20(undefined4 *param_1)

{
  int iVar1;
  int iVar2;
  char cVar3;
  
  cVar3 = (**(code **)(*(int *)*param_1 + 4))(param_1[1],param_1 + 4,param_1 + 10);
  if (cVar3 != '\0') {
    return 1;
  }
  iVar2 = param_1[2];
  while (iVar2 != 0) {
    iVar1 = *(int *)(iVar2 + 0xc);
    FUN_00577860();
    FUN_00577ad0(iVar2);
    iVar2 = iVar1;
  }
  param_1[10] = 0;
  param_1[2] = 0;
  return 0;
}


