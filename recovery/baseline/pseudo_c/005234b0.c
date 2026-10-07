/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005234b0 */

void __thiscall FUN_005234b0(int param_1_00,char param_1,char param_2)

{
  float10 fVar1;
  
  if ((*(char *)(param_1_00 + 0xfc) != '\0') || (param_2 != '\0')) {
    *(char *)(param_1_00 + 0xd2) = param_1;
    if (*(char *)(param_1_00 + 0xfe) == '\0') {
      *(char *)(param_1_00 + 0xd5) = param_1;
    }
    else {
      *(char *)(param_1_00 + 0xd4) = param_1;
    }
    if ((*(char *)(param_1_00 + 0x8d) != '\0') && (param_1 == '\0')) {
      fVar1 = (float10)FUN_00557e40(0);
      *(float *)(param_1_00 + 0xda) = (float)fVar1;
      fVar1 = (float10)FUN_00557e40(2);
      *(float *)(param_1_00 + 0xe2) = (float)fVar1;
    }
  }
  return;
}


