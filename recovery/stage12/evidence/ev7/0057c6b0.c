/* NR2003.exe @ 0057c6b0 FUN_0057c6b0 */

void FUN_0057c6b0(int param_1,int param_2,undefined4 param_3,undefined param_4)

{
  int iVar1;
  
  if (-1 < param_2) {
    iVar1 = FUN_005d0420();
    if (param_2 < iVar1) {
      param_1 = param_1 * 0x1d;
      DAT_00d3b025 = 1;
      *(undefined4 *)((int)&DAT_00d37cc8 + param_1) = 1;
      *(int *)((int)&DAT_00d37ccc + param_1) = param_2;
      *(undefined4 *)((int)&DAT_00d37cd0 + param_1) = 0;
      (&DAT_00d37cd4)[param_1] = param_4;
    }
  }
  return;
}

