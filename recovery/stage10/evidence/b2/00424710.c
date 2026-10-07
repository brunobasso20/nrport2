/* NR2003.exe @ 00424710 FUN_00424710 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00424710(undefined4 param_1,int param_2)

{
  int iVar1;
  
  if (param_2 == 1) {
    _DAT_00c05174 = 3;
    _DAT_00c0517a = 3;
    _DAT_00c051a4 = 3;
    _DAT_00c051aa = 3;
    _DAT_00c051d6 = &DAT_006ee1fc;
    _DAT_00c051dc = &DAT_006ee1fc;
    _DAT_00c05176 = &DAT_006ee218;
    _DAT_00c0517c = &DAT_006ee218;
    _DAT_00c051a6 = &DAT_006ee234;
    _DAT_00c051ac = &DAT_006ee234;
    _DAT_00c051d4 = 4;
    _DAT_00c051da = 4;
    _DAT_00c052ca = 4;
    _DAT_00c052cc = &DAT_006ee250;
    iVar1 = FUN_00432cd0(param_1,1);
    if ((iVar1 == 0) || (_DAT_00721fda = *(int *)(iVar1 + 0x1b8), _DAT_00721fda == -1)) {
      _DAT_00721fda = 0x37;
    }
    _DAT_00c052be = 4;
    _DAT_00721fde = _DAT_00721fda;
    _DAT_00721fe6 = _DAT_00721fda;
    _DAT_00c052c0 = &DAT_00721fd8;
    return;
  }
  FUN_00424690();
  return;
}

