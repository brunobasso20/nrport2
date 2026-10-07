/* NR2003.exe @ 0051ef60 FUN_0051ef60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051ef60(int param_1)

{
  if (*(float *)(param_1 + 0x18b6) <= *(float *)(param_1 + 0x1af2)) {
    *(float *)(param_1 + 0x18be) =
         *(float *)(param_1 + 0x18c6) * *(float *)(param_1 + 0x18ba) +
         (*(float *)(param_1 + 0x1af2) - *(float *)(param_1 + 0x18b6)) *
         *(float *)(param_1 + 0x18c2) + *(float *)(param_1 + 0x1ad6);
  }
  else {
    *(undefined4 *)(param_1 + 0x18be) = *(undefined4 *)(param_1 + 0x1ad6);
  }
  *(float *)(param_1 + 0x18b6) =
       *(float *)(param_1 + 0x18be) * _DAT_006ea44c + *(float *)(param_1 + 0x18ba) +
       *(float *)(param_1 + 0x18b6);
  *(float *)(param_1 + 0x18ba) = *(float *)(param_1 + 0x18be) + *(float *)(param_1 + 0x18ba);
  return;
}

