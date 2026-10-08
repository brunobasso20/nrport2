/* NR2003.exe @ 005c3320 FUN_005c3320 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005c3320(int param_1)

{
  int iVar1;
  int iVar2;
  float10 fVar3;
  
  iVar1 = FUN_005c2d40(param_1);
  if ((iVar1 == 2) &&
     ((NAN(*(float *)(param_1 + 0x4a)) || NAN(_DAT_006ea454)) ==
      (*(float *)(param_1 + 0x4a) == _DAT_006ea454))) {
    iVar1 = (**(code **)(*(int *)(*(int *)(param_1 + 9) + 4) + 0x1c))(*(int *)(param_1 + 9));
    iVar2 = taskGetRate();
    fVar3 = ((float10)((iVar2 * 10) / 2) * (float10)iVar1) /
            ((float10)*(int *)(param_1 + 0x4e) + (float10)*(float *)(param_1 + 0x4a));
    if (fVar3 < (float10)_DAT_006ea454 != (NAN(fVar3) || NAN((float10)_DAT_006ea454))) {
      return (float10)_DAT_006ea454;
    }
  }
  else {
    fVar3 = (float10)_DAT_006e97d8;
  }
  return fVar3;
}

