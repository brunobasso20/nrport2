/* Ghidra pseudo-C; NR2003.exe @ 005b3850 */

void recovered_005b3850(int param_1)

{
  int iVar1;
  int iVar2;
  
  iVar1 = param_1 + 0x3cd;
  FUN_005b9420(iVar1,param_1 + 0x3e5,*(int *)(param_1 + 0x6d) + 0x3cd);
  if (0 < *(int *)(param_1 + 0x79)) {
    FUN_005b8e20(&DAT_00e84738,&PTR_DAT_006f74d0,param_1 + 0x95);
    FUN_005b8fd0(&DAT_00e847cc,&DAT_00e84738,param_1 + 0x36d);
    FUN_005b8ec0(&DAT_00e84ae8,&DAT_00e84738,param_1 + 0x475);
    FUN_005b8fd0(&DAT_00e84bac,&DAT_00e84ae8,iVar1);
    FUN_005b8080(&DAT_00e847cc,&DAT_00e847cc,&DAT_00e84bac);
    if (*(int *)(param_1 + 0x79) == 1) {
      iVar2 = *(int *)(param_1 + 0x7d);
      (**(code **)(PTR_PTR_0074fe4c + 8))(&DAT_00e84ba8,&DAT_00e84ae8 + iVar2 * 0x1c);
      (**(code **)(PTR_PTR_0074fe48 + 0xc))
                (param_1 + 0x385 + iVar2 * 4,&DAT_00e84ba8,&DAT_00e847cc + iVar2 * 4);
    }
    else {
      FUN_005b3490(&DAT_00e844b8,&DAT_00e84ae8,*(int *)(param_1 + 0x79),param_1 + 0x7d);
      FUN_005b36c0(param_1 + 0x385,&DAT_00e844b8,&DAT_00e847cc,*(undefined4 *)(param_1 + 0x79),
                   param_1 + 0x7d);
    }
    FUN_005b8040(iVar1,iVar1,param_1 + 0x385);
  }
  FUN_005b2ef0(param_1,recovered_005b3850);
  return;
}

