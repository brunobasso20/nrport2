/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005742e0 */

void FUN_005742e0(int param_1)

{
  int iVar1;
  
  FUN_00563270(param_1);
  DAT_00c74dd0 = 1;
  (&DAT_00c72730)[param_1 * 0xce] = 0;
  iVar1 = FUN_0055a5a0();
  if (iVar1 != 4) {
    FUN_00574330();
  }
  (&DAT_00c72736)[param_1 * 0xce] = 0;
  DAT_00c74e00 = 1;
  return;
}


