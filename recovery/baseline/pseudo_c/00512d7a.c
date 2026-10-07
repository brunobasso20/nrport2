/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00512d7a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_00512d7a(float param_1,float param_2,float param_3,float param_4,float param_5,float param_6,
            float param_7,float param_8,float *param_9,float *param_10)

{
  float fVar1;
  
  fVar1 = param_3 * param_8 - param_4 * param_7;
  if (fVar1 != _DAT_006ea454) {
    fVar1 = ((param_2 - param_6) * param_7 - (param_1 - param_5) * param_8) / fVar1;
    *param_9 = param_3 * fVar1 + param_1;
    *param_10 = fVar1 * param_4 + param_2;
    return 1;
  }
  return 0;
}


