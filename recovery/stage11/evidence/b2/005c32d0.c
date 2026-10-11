/* NR2003.exe @ 005c32d0 FUN_005c32d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005c32d0(int param_1)

{
  float fVar1;
  int iVar2;
  int iVar3;
  
  iVar2 = FUN_005c2d40(param_1);
  if (iVar2 == 2) {
    iVar2 = taskGetRate();
    fVar1 = *(float *)(param_1 + 0x46);
    iVar3 = taskGetRate();
    return (float10)(fVar1 / (float)(iVar2 * 3)) / (float10)iVar3;
  }
  return (float10)_DAT_006ea454;
}

