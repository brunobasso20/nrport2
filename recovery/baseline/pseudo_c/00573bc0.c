/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573bc0 */

void FUN_00573bc0(void)

{
  FUN_0057dd60();
  FUN_00585510();
  FUN_00525870();
  FUN_005ae210();
  FUN_004530a0();
  FUN_00598560(DAT_00c72160);
  if (DAT_00c72164 != (int *)0x0) {
    (**(code **)(*DAT_00c72160 + 0x3c))(DAT_00c72164);
    (**(code **)(*DAT_00c72164 + 4))();
    DAT_00c72164 = (int *)0x0;
  }
  if (DAT_00c72158 != (int *)0x0) {
    (**(code **)(*DAT_00c72158 + 4))();
    DAT_00c72158 = (int *)0x0;
  }
  if (DAT_00c7215c != (int *)0x0) {
    (**(code **)(*DAT_00c7215c + 4))();
    DAT_00c7215c = (int *)0x0;
  }
  FUN_005b58d0();
  FUN_00573480();
  FUN_00567c60(0);
  if (DAT_00c72160 != (int *)0x0) {
    (**(code **)(*DAT_00c72160 + 4))();
    DAT_00c72160 = (int *)0x0;
  }
  FUN_005729e0();
  thunk_FUN_004531c0();
  FUN_00567e00();
  FUN_0050d050();
  FUN_00550680();
  FUN_0050f7c0();
  FUN_005d34a0(0,1);
  FUN_0056c870();
  return;
}


