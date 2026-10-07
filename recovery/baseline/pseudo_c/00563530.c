/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563530 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00563530(int param_1,int param_2)

{
  float10 fVar1;
  float10 fVar2;
  
  if (param_2 == 0) {
    param_2 = FUN_00592db0(param_1);
  }
  fVar1 = (float10)*(float *)(param_2 + 0x58) + (float10)*(float *)(param_2 + 0x4c);
  if (fVar1 <= (float10)_DAT_006e97d8) {
    if (fVar1 <= (float10)_DAT_006ea470) goto LAB_005635a8;
  }
  else {
    fVar1 = (float10)_DAT_006e97d8;
  }
  if (_DAT_006ea454 < *(float *)(param_1 + 0x1510)) {
    fVar2 = (float10)*(float *)(param_1 + 0x1510);
    if (fVar2 < (float10)_DAT_006e9824) {
      fVar2 = (float10)_DAT_006e9824;
    }
    return fVar2 * fVar1;
  }
LAB_005635a8:
  return (float10)_DAT_006ea454;
}


