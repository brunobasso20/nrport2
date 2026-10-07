/* NR2003.exe @ 0051fdc0 FUN_0051fdc0 */

void __thiscall FUN_0051fdc0(int param_1_00,int param_1,int param_2)

{
  *(int *)(param_1_00 + 0x1d) = param_2;
  *(int *)(param_1_00 + 0xbe) = param_1;
  *(int *)(param_1_00 + 0x5e) = param_1_00;
  *(undefined4 *)(param_1_00 + 0x2d) = 0;
  *(undefined4 *)(param_1_00 + 0x21) = 0;
  if (*(int *)(param_1_00 + 0xc6) < 2) {
    *(undefined4 *)(param_1_00 + 0xc6) = 0;
  }
  *(undefined4 *)(param_1_00 + 0x15) = *(undefined4 *)(param_1_00 + 0x19);
  *(undefined4 *)(param_1_00 + 0xc2) = 0;
  if (*(char *)(param_1 + 0xfe) == '\0') {
    if ((&DAT_00761196)[param_2 * 0xdc] != 0) {
      *(undefined1 **)(param_1_00 + 0xc2) = &DAT_00761080 + param_2 * 0x370;
    }
  }
  else if ((&DAT_007610c0)[param_2 * 0xdc] != 0) {
    *(undefined1 **)(param_1_00 + 0xc2) = &DAT_00761080 + param_2 * 0x370;
    return;
  }
  return;
}

