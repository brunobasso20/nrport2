/* Ghidra pseudo-C; NR2003.exe @ 005b9590 */

void FUN_005b9590(int param_1)

{
  int iVar1;
  
  FUN_005b7e30(&DAT_00ead154,param_1,param_1);
  iVar1 = param_1 + 0xc;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead15c,iVar1,iVar1);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00ead154,&DAT_00ead154,&DAT_00ead15c);
  (**(code **)(PTR_PTR_0074fe4c + 0xc))(&DAT_00ead154,&DAT_00ead154);
  (**(code **)(PTR_PTR_0074fe4c + 8))(&DAT_00ead154,&DAT_00ead154);
  FUN_005b7df0(param_1,&DAT_00ead154,param_1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(iVar1,&DAT_00ead154,iVar1);
  return;
}

