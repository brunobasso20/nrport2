/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051e1c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051e1c0(int param_1,float param_2,float *param_3,undefined4 *param_4,float *param_5,
                 undefined4 param_6,float *param_7,float *param_8,float *param_9,float *param_10,
                 float *param_11,float *param_12)

{
  float10 fVar1;
  
  *param_11 = *(float *)(param_1 + 0x34);
  param_11[1] = *(float *)(param_1 + 0x38);
  FUN_005f5ce0(param_11,param_12,(float *)(param_1 + 0x24));
  fVar1 = (float10)FUN_0051700a(*(undefined4 *)(param_1 + 0x3c));
  *param_3 = (float)fVar1;
  *param_4 = *(undefined4 *)(param_1 + 0x40);
  *param_7 = (*(float *)(param_1 + 0xc) * *param_11 +
             *(float *)(param_1 + 0x10) * param_11[1] + *(float *)(param_1 + 0x14) * param_11[2]) *
             _DAT_006efe48;
  *param_8 = (*param_12 * *(float *)(param_1 + 0xc) +
             *(float *)(param_1 + 0x10) * param_12[1] + *(float *)(param_1 + 0x14) * param_12[2]) *
             _DAT_006efe48;
  *param_5 = (*(float *)(param_1 + 8) - (param_2 + *(float *)(param_1 + 0x30))) *
             *(float *)(param_1 + 0x2c);
  *param_9 = (*(float *)(param_1 + 0xc) * *(float *)(param_1 + 0x24) +
             *(float *)(param_1 + 0x10) * *(float *)(param_1 + 0x28) +
             *(float *)(param_1 + 0x14) * *(float *)(param_1 + 0x2c)) * _DAT_006efe48;
  FUN_005f74a0(param_6,param_1 + 0x58);
  *param_10 = *(float *)(param_1 + 0x94) * _DAT_006efe48;
  return;
}


