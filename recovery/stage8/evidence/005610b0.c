/* NR2003.exe @ 005610b0 FUN_005610b0 */

void FUN_005610b0(int param_1,int param_2)

{
  int iVar1;
  
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00c08288,&DAT_00e84480,&DAT_00c0850c + param_2 * 4)
  ;
  (**(code **)PTR_PTR_FUN_0074fe48)(&DAT_00c08288,&DAT_00c08288,&PTR_DAT_0074e798);
  iVar1 = param_1 + 0x395;
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00c08420,iVar1,iVar1);
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00c08420,&DAT_00c08420,&PTR_DAT_0074e79c);
  (**(code **)PTR_PTR_FUN_0074fe48)(&DAT_00c08288,&DAT_00c08288,&DAT_00c08420);
  (**(code **)PTR_PTR_FUN_0074fe48)(&DAT_00c08288,&DAT_00c08288,&DAT_00c081f4 + param_2);
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00c08498,param_1 + 0x195,iVar1);
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00c08498,&DAT_00c08498,&PTR_DAT_0074fda0);
  (**(code **)PTR_PTR_FUN_0074fe48)(&DAT_00c08498,&DAT_00c08498,param_1 + 0x3ad);
  FUN_005b7fe0(&DAT_00c0863c,&PTR_DAT_006f746c);
  FUN_0057cbd0(&DAT_00c0864c);
  FUN_0057cba0(&DAT_00c08288);
  FUN_0057cba0(&DAT_00c08498);
  FUN_0057cc10(recovered_00561040);
  FUN_005b8040(param_1 + 0x39d,param_1 + 0x39d,&DAT_00c0863c);
  FUN_005b8fd0(&DAT_00c0863c,param_1 + 0x3e5,&DAT_00c0863c);
  iVar1 = *(int *)(param_1 + 0x6d) + 0x39d;
  FUN_005b8080(iVar1,iVar1,&DAT_00c0863c);
  FUN_0057cba0(&DAT_00c0864c);
  FUN_0057cc10((&PTR_LAB_0074e86c)[param_2]);
  return;
}

