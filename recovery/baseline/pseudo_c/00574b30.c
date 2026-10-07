/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00574b30 */

void FUN_00574b30(int param_1)

{
  int *piVar1;
  
  if (param_1 != 0) {
    piVar1 = &DAT_00c727e6;
    do {
      if (*piVar1 != 0) {
        (**(code **)(*DAT_00c72160 + 0x94))(*piVar1,param_1,0,0);
      }
      piVar1 = (int *)((int)piVar1 + 0xce);
    } while ((int)piVar1 < 0xc74e86);
  }
  return;
}


