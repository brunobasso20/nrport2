/* Ghidra pseudo-C; NR2003.exe @ 005b31e0 */

void recovered_005b31e0(int param_1)

{
  int iVar1;
  int iVar2;
  
  FUN_005b7fe0(param_1 + 0x39d,&PTR_DAT_006f746c);
  FUN_005b8d90(param_1 + 0x475,param_1 + 0x125);
  FUN_005b2ef0(param_1,recovered_005b31e0);
  FUN_005b32e0(param_1);
  FUN_005b8ec0(&DAT_00e84bf8,param_1 + 0x95,param_1 + 0x475);
  iVar1 = param_1 + 0x3e5;
  FUN_005b8ec0(&DAT_00e84bf8,iVar1,&DAT_00e84bf8);
  FUN_005b8fd0(&DAT_00e84714,param_1 + 0x95,param_1 + 0x36d);
  FUN_005b8fd0(&DAT_00e84714,iVar1,&DAT_00e84714);
  FUN_005b8fd0(&DAT_00e846f8,&DAT_00e84bf8,param_1 + 0x385);
  FUN_005b8080(&DAT_00e84714,&DAT_00e84714,&DAT_00e846f8);
  FUN_005b9210(&DAT_00e847f8,&DAT_00e84bf8,iVar1);
  iVar2 = *(int *)(param_1 + 0x6d);
  iVar1 = iVar2 + 0x36d;
  FUN_005b8040(iVar1,iVar1,&DAT_00e84714);
  iVar2 = iVar2 + 0x475;
  FUN_005b8dd0(iVar2,iVar2,&DAT_00e847f8);
  return;
}

