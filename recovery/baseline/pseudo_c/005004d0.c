/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005004d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005004d0(int param_1,char param_2)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int local_4;
  
  local_4 = 0;
  if (param_1 != 0) {
    do {
      iVar1 = FUN_005cfce4(&local_4,param_1);
      if ((iVar1 == 0) && (param_2 != '\0')) {
        param_1 = (param_1 >> 2) * 3;
      }
    } while (((local_4 == 0) && (param_2 != '\0')) && (0x400000 < param_1));
  }
  DAT_00b70da8 = 0;
  if ((param_1 != 0) && (DAT_00b70da8 = local_4, local_4 == 0)) {
    return 0;
  }
  iVar1 = FUN_005ad630(DAT_00b70da8);
  DAT_00b70db0 = DAT_00b70da8 + iVar1;
  DAT_00b70db4 = param_1 - iVar1;
  DAT_00b70dbc = 0;
  _DAT_00b70dc0 = 0;
  DAT_00b715c4 = 0;
  DAT_00b70dac = param_1;
  DAT_00b70db8 = DAT_00b70db0;
  iVar1 = taskGetRate();
  DAT_00b71de8 = 1;
  DAT_00b715c8 = 0;
  DAT_00b715cc = 0;
  DAT_00b71dd0 = 0;
  DAT_00b715c0 = _DAT_006e97d8 / (float)iVar1;
  DAT_00b71dd1 = 0;
  _DAT_00b71dd5 = 0;
  DAT_00b71dd9 = 0;
  _DAT_00b71ddd = 0;
  _DAT_00b71de1 = 0;
  DAT_00b71de5 = 0;
  DAT_00b71de6 = 1;
  DAT_00b71de7 = 1;
  DAT_00b71de9 = 0;
  uVar2 = FUN_005cfd1a(s_lesson_00748f54);
  FUN_006c4f81(&DAT_00b71dea,s__s__s_00748f5c,uVar2);
  uVar2 = FUN_005cfd1a(s_exports_imports_00748f64);
  FUN_006c4f81(&DAT_00b721ee,s__s__s_00748f74,uVar2);
  thunk_FUN_00507890();
  FUN_005080a0();
  FUN_005086e0();
  FUN_005087e0();
  DAT_00b8e921 = 0;
  _DAT_00b8e922 = 0x3f800000;
  _DAT_00b8e926 = 0x3f800000;
  _DAT_00b8e92a = 0x13;
  _DAT_00b8e92e = FUN_0055ab00();
  DAT_00b8e932 = 1;
  DAT_00b8e936 = 0;
  DAT_00b8e939 = 0;
  _DAT_00b8e937 = 0x100;
  DAT_00b8e586 = 0;
  DAT_00b8e596 = DAT_00b70db0;
  DAT_00b8e58a = 0;
  DAT_00b8e58e = 0;
  DAT_00b8e592 = 0;
  DAT_00b8e59a = 0;
  DAT_00b8e59e = 0;
  DAT_00b8e5a2 = 0;
  DAT_00b8e5aa = 0;
  DAT_00b8e5ae = 0;
  DAT_00b8e5b3 = 0;
  DAT_00b8e5b4._0_1_ = 0;
  ram0x00b8e5b5 = 0;
  DAT_00b8e5b9 = 0;
  DAT_00b8e915 = 0;
  DAT_00b8e919 = FUN_0055ab00();
  DAT_00e56d24 = 0xffffffff;
  DAT_00b8f15c = 1;
  FUN_005aaef0();
  uVar3 = 2;
  uVar2 = FUN_0055ab00(2);
  uVar2 = FUN_005aa360(uVar2);
  FUN_00568a20(&DAT_00e4d4b8,uVar2,uVar3);
  return 1;
}


