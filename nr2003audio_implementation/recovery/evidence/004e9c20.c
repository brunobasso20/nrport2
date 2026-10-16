/* NR2003.exe @ 004e9c20 recovered_004e9c20 */

void __fastcall recovered_004e9c20(int param_1)

{
  float fVar1;
  
  if ((NAN(*(float *)(param_1 + 0xc)) || NAN(*(float *)(param_1 + 0x14))) ==
      (*(float *)(param_1 + 0xc) == *(float *)(param_1 + 0x14))) {
    fVar1 = (*(float *)(param_1 + 0x18) - *(float *)(param_1 + 0x10)) /
            (*(float *)(param_1 + 0x14) - *(float *)(param_1 + 0xc));
    *(float *)(param_1 + 8) = fVar1;
    *(float *)(param_1 + 4) = *(float *)(param_1 + 0x10) - fVar1 * *(float *)(param_1 + 0xc);
  }
  return;
}

