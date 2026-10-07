/* NR2003.exe @ 005bd1a0 FUN_005bd1a0 */

void FUN_005bd1a0(int param_1,int *param_2)

{
  int iVar1;
  undefined4 uVar2;
  
  if (param_2 != (int *)0x0) {
    FUN_005bd210(param_1,param_2);
    iVar1 = FUN_005bd200(param_2);
    if ((iVar1 != 0) && (param_1 == *param_2 >> 2)) {
      (&DAT_00ec02c8)[param_1] = param_2;
    }
    if ((param_2[4] == 0) && (1 < param_2[3])) {
      uVar2 = FUN_005bcd70(param_2);
      FUN_005bd160(uVar2);
    }
  }
  return;
}

