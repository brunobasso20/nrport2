/* NR2003.exe @ 005b9660 FUN_005b9660 */

void FUN_005b9660(int param_1,int param_2,int param_3)

{
  int iVar1;
  
  if ((param_1 != param_2) && (param_1 != param_3)) {
    iVar1 = param_1 + 0xc;
    (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(iVar1,param_2 + 0xc,param_3 + 0xc);
    FUN_005b7e30(&DAT_00ead174,param_2,param_3);
    (**(code **)(PTR_PTR_FUN_0074fe48 + 8))(iVar1,iVar1,&DAT_00ead174);
    FUN_005b7df0(&DAT_00ead1d0,param_3 + 0xc,param_2);
    FUN_005b7e90(&DAT_00eacfbc,param_2,param_3);
    FUN_005b7df0(param_1,param_2 + 0xc,param_3);
    FUN_005b7d70(param_1,param_1,&DAT_00ead1d0);
    FUN_005b7d70(param_1,param_1,&DAT_00eacfbc);
    return;
  }
  (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00ead180,param_2 + 0xc,param_3 + 0xc);
  FUN_005b7e30(&DAT_00ead174,param_2,param_3);
  (**(code **)(PTR_PTR_FUN_0074fe48 + 8))(&DAT_00ead180,&DAT_00ead180,&DAT_00ead174);
  FUN_005b7df0(&DAT_00ead1d0,param_3 + 0xc,param_2);
  FUN_005b7e90(&DAT_00eacfbc,param_2,param_3);
  FUN_005b7df0(param_1,param_2 + 0xc,param_3);
  FUN_005b7d70(param_1,param_1,&DAT_00ead1d0);
  FUN_005b7d70(param_1,param_1,&DAT_00eacfbc);
  (**(code **)PTR_PTR_FUN_0074fe4c)(param_1 + 0xc,&DAT_00ead180);
  return;
}

