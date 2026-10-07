/* NR2003.exe @ 00550490 FUN_00550490 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00550490(void)

{
  int iVar1;
  float fVar2;
  
  iVar1 = FUN_005b29c0();
  if (iVar1 == 1) {
    DAT_00bf6e1c = FUN_005b2b20(s_chassis_0074c9f8);
    iVar1 = FUN_005b2c40(DAT_00bf6e1c);
    if (iVar1 == 0x2d) {
      FUN_005506b0(0);
      DAT_00bf6ebb = 0;
      FUN_0054fed0();
      fVar2 = _DAT_006e97d8 / _DAT_0074fd74;
      iVar1 = taskGetRate();
      DAT_00bf6e9c = FUN_006c5018(iVar1,fVar2);
      DAT_00bf6eb8 = 1;
      FUN_00550530();
      FUN_00551800();
      return 1;
    }
  }
  return 0;
}

