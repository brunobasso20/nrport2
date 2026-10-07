/* Ghidra pseudo-C; NR2003.exe @ 005b7e30 */

void FUN_005b7e30(undefined4 param_1,int param_2,int param_3)

{
  int iVar1;
  
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(param_1,param_2,param_3);
  param_3 = param_3 - param_2;
  iVar1 = 2;
  do {
    param_2 = param_2 + 4;
    (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead168,param_2,param_3 + param_2);
    (**(code **)(PTR_PTR_0074fe4c + 0x18))(param_1,&DAT_00ead168);
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  FUN_0057cb80(param_1);
  return;
}

