/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573af0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00573af0(void)

{
  DAT_00c71fd8 = 0x41f00000;
  DAT_00c71f88 = 0x447a0000;
  FUN_005cfcc6(0x28,s_Graphics_0074f5e0,s_shadow_volume_dist_0074f5cc,&DAT_00c721d8,2,2);
  _DAT_00c71f82 = DAT_00c71fd8;
  _DAT_00c71f7e = DAT_00c71fd8;
  _DAT_00c71f7a = &DAT_00c71fd8;
  FUN_005cfcc6(0x28,s_Graphics_0074f5fc,s_dynlight_dist_0074f5ec,&DAT_00c721d9,2,2);
  _DAT_00c71fbe = DAT_00c71f88;
  _DAT_00c71fba = &DAT_00c71f88;
  _DAT_00c71fc2 = DAT_00c71f88;
  FUN_005cfd26(0x28,s_track_ini_0074f608);
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005d5300(DAT_00c71fd8);
  FUN_005d5330(DAT_00c71f88);
  return;
}


