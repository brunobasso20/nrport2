/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052b120 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0052b120(int param_1,int param_2,float param_3)

{
  float10 fVar1;
  float10 fVar2;
  
  fVar1 = (float10)FUN_0052b070(param_1,param_2);
  fVar1 = fVar1 - (float10)param_3;
  if (fVar1 <= (float10)_DAT_006f1624) {
    if ((float10)_DAT_006ea454 < fVar1) {
      fVar1 = (float10)FUN_0052acd0(param_1,param_2,param_3,*(undefined4 *)(param_2 + 0x1876),
                                    0xbb14accb,0x42480000,0x3dcccccd,0x3e800000,0x3e800000,
                                    0x3ecccccd,0x3f800000,1);
      param_3 = (float)fVar1;
      goto LAB_0052b268;
    }
    param_3 = (*(float *)(param_1 + 0x1872) - (_DAT_0074b080 * _DAT_006ea500 + _DAT_006ea450)) *
              _DAT_006f51ac;
    if (param_3 < _DAT_006f51a8) {
      param_3 = -0.0015124;
      goto LAB_0052b268;
    }
    if (param_3 <= _DAT_006ea49c) goto LAB_0052b268;
  }
  else {
    fVar2 = (float10)*(float *)(param_1 + 0x1872) - (float10)*(float *)(param_2 + 0x1872);
    if ((float10)_DAT_006ea454 <= fVar2) {
      param_3 = (float)-((fVar2 * fVar2) / (fVar1 + fVar1));
      if (param_3 <= _DAT_006f51b4) goto LAB_0052b268;
      if (param_3 <= _DAT_006f51b0) {
        param_3 = (param_3 - _DAT_006f51b0) * _DAT_006ea494;
        goto LAB_0052b268;
      }
    }
  }
  param_3 = 0.0022686;
LAB_0052b268:
  fVar1 = (float10)FUN_00401b10(param_1,param_2,param_3);
  if (fVar1 <= (float10)param_3) {
    fVar1 = (float10)param_3;
  }
  return fVar1;
}


