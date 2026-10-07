/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004107b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004107b0(int param_1,float param_2,float param_3)

{
  if ((param_3 < _DAT_006ec758) || (_DAT_006ec754 < param_3)) {
    FUN_005677d1(*(undefined4 *)(param_1 + 0x11c),param_2);
    return;
  }
  if ((_DAT_006ec750 <= param_2) && (param_2 < _DAT_006ec74c)) {
    FUN_005677d1(*(undefined4 *)(param_1 + 0x120),param_2);
    return;
  }
  FUN_005677d1(*(undefined4 *)(param_1 + 0x118),param_2);
  return;
}


