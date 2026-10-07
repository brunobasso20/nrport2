/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f390 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051f390(int param_1)

{
  int iVar1;
  float10 fVar2;
  
  if (*(float *)(param_1 + 0x1972) < _DAT_006f49d4 ==
      (*(float *)(param_1 + 0x1972) == _DAT_006f49d4)) {
    iVar1 = *(int *)(*(int *)(param_1 + 0x13b3) + 8);
    if ((iVar1 != 0) && (iVar1 != 1)) {
      FUN_0051f440(param_1);
      if ((_DAT_0074b080 * _DAT_006e9810 + _DAT_006ea450 < *(float *)(param_1 + 0x1862)) &&
         ((*(byte *)(param_1 + 0x1d9b) & 2) == 0)) {
        fVar2 = (float10)FUN_0051f030(*(undefined4 *)(param_1 + 0x1982));
        *(float *)(param_1 + 0x195a) = (float)(fVar2 * (float10)*(float *)(param_1 + 0x1972));
        *(undefined4 *)(param_1 + 0x18a2) = *(undefined4 *)(param_1 + 0x195a);
        return;
      }
      goto LAB_0051f3bc;
    }
  }
  else {
    *(undefined4 *)(param_1 + 0x195a) = 0;
  }
  *(undefined4 *)(param_1 + 0x18b2) = 0;
  *(undefined4 *)(param_1 + 0x1982) = 0;
LAB_0051f3bc:
  *(undefined4 *)(param_1 + 0x18a2) = *(undefined4 *)(param_1 + 0x195a);
  return;
}


