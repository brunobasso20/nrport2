/* NR2003.exe @ 0057af40 FUN_0057af40 */

undefined4 FUN_0057af40(int param_1)

{
  if (*(int *)((int)&DAT_00d35b18 + param_1 * 10) == 0x3f800000) {
    return 1;
  }
  return 0;
}

