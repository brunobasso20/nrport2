/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5fa0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005f5fa0(int param_1,float param_2,float param_3,float param_4,float param_5)

{
  float fVar1;
  
  fVar1 = _DAT_006e97d8 / param_2;
  *(float *)(param_1 + 0x178) = param_2;
  *(float *)(param_1 + 0x17c) = param_3;
  *(undefined4 *)(param_1 + 0x1a0) = 1;
  *(float *)(param_1 + 0x180) = param_4;
  *(float *)(param_1 + 0x184) = param_5;
  *(float *)(param_1 + 0x188) = fVar1;
  *(float *)(param_1 + 0x18c) = _DAT_006e97d8 / param_3;
  *(float *)(param_1 + 400) = _DAT_006e97d8 / param_4;
  *(float *)(param_1 + 0x194) = _DAT_006e97d8 / param_5;
  return;
}


