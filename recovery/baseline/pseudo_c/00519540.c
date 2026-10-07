/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00519540 */

void __thiscall
FUN_00519540(int *param_1_00,float param_1,float param_2,float *param_3,float *param_4)

{
  float fVar1;
  float10 fVar2;
  float10 fVar3;
  
  if (*param_1_00 == 1) {
    *param_3 = param_2 * (float)param_1_00[0x10] +
               param_1 * (float)param_1_00[0x11] * (float)param_1_00[2] + (float)param_1_00[0xc];
    *param_4 = param_2 * (float)param_1_00[0x11] +
               ((float)param_1_00[0xd] - param_1 * (float)param_1_00[0x10] * (float)param_1_00[2]);
    return;
  }
  fVar3 = (float10)(param_1 * (float)param_1_00[0x14] + (float)param_1_00[0x13]);
  fVar2 = (float10)fcos(fVar3);
  fVar3 = (float10)fsin(fVar3);
  fVar1 = (float)param_1_00[0x11];
  *param_3 = (float)fVar3 * (fVar1 - param_2) + (float)param_1_00[0xc];
  *param_4 = (float)param_1_00[0xd] - (float)fVar2 * (fVar1 - param_2);
  return;
}


