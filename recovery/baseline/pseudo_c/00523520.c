/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00523520 */

void __thiscall FUN_00523520(int param_1_00,char param_1,char param_2)

{
  float10 fVar1;
  
  if ((*(char *)(param_1_00 + 0xfc) != '\0') || (param_2 != '\0')) {
    *(char *)(param_1_00 + 0xd3) = param_1;
    if (*(char *)(param_1_00 + 0xfe) == '\0') {
      *(char *)(param_1_00 + 0xd4) = param_1;
    }
    else {
      *(char *)(param_1_00 + 0xd5) = param_1;
    }
    if ((*(char *)(param_1_00 + 0x8d) != '\0') && (param_1 == '\0')) {
      fVar1 = (float10)FUN_00557e40(1);
      *(float *)(param_1_00 + 0xde) = (float)fVar1;
      fVar1 = (float10)FUN_00557e40(3);
      *(float *)(param_1_00 + 0xe6) = (float)fVar1;
    }
  }
  return;
}


