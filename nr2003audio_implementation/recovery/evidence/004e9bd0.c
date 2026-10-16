/* NR2003.exe @ 004e9bd0 recovered_004e9bd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall recovered_004e9bd0(int param_1,float *param_2,float param_3)

{
  float fVar1;
  bool bVar2;
  
  *param_2 = param_3;
  if ((NAN(*(float *)(param_1 + 0xc)) || NAN(*(float *)(param_1 + 0x14))) ==
      (*(float *)(param_1 + 0xc) == *(float *)(param_1 + 0x14))) {
    fVar1 = param_3 * *(float *)(param_1 + 8) + *(float *)(param_1 + 4);
  }
  else {
    fVar1 = *(float *)(param_1 + 0x10);
  }
  param_2[1] = fVar1;
  bVar2 = fVar1 < _DAT_006ea454;
  if (bVar2) {
    param_2[1] = 0.0;
  }
  return CONCAT31((uint3)bVar2,1);
}

