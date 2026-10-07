/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b3390 */

void FUN_005b3390(int param_1)

{
  int iVar1;
  
  if (0 < *(int *)(param_1 + 0x79)) {
    FUN_005b8e20(&DAT_00e84a38,&PTR_DAT_006f74d0,param_1 + 0x95);
    FUN_005b8fd0(&DAT_00e84be0,&DAT_00e84a38,param_1 + 0x36d);
    FUN_005b8ec0(&DAT_00e84550,&DAT_00e84a38,param_1 + 0x475);
    if (*(int *)(param_1 + 0x79) == 1) {
      iVar1 = *(int *)(param_1 + 0x7d);
      (**(code **)(PTR_PTR_0074fe4c + 8))(&DAT_00e84650,&DAT_00e84550 + iVar1 * 0x1c);
      (**(code **)(PTR_PTR_0074fe48 + 0xc))
                (param_1 + 0x385 + iVar1 * 4,&DAT_00e84650,&DAT_00e84be0 + iVar1 * 4);
    }
    else {
      FUN_005b3490(&DAT_00e84668,&DAT_00e84550,*(int *)(param_1 + 0x79),param_1 + 0x7d);
      FUN_005b36c0(param_1 + 0x385,&DAT_00e84668,&DAT_00e84be0,*(undefined4 *)(param_1 + 0x79),
                   param_1 + 0x7d);
    }
    FUN_005b7fe0(param_1 + 0x3cd,param_1 + 0x385);
  }
  FUN_005b2ef0(param_1,&LAB_005b3850);
  return;
}


