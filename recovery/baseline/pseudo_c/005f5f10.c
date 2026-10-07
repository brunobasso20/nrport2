/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5f10 */

void FUN_005f5f10(int param_1)

{
  float fVar1;
  float local_c;
  float local_8;
  float local_4;
  
  fVar1 = *(float *)(param_1 + 0x178);
  *(float *)(param_1 + 0x130) = fVar1 * *(float *)(param_1 + 0xc);
  *(float *)(param_1 + 0x134) = fVar1 * *(float *)(param_1 + 0x10);
  *(float *)(param_1 + 0x138) = fVar1 * *(float *)(param_1 + 0x14);
  local_c = *(float *)(param_1 + 0x17c) * *(float *)(param_1 + 0x8c);
  local_8 = *(float *)(param_1 + 0x180) * *(float *)(param_1 + 0x90);
  local_4 = *(float *)(param_1 + 0x184) * *(float *)(param_1 + 0x94);
  FUN_005f6d20(param_1 + 0x148,param_1 + 0x58,&local_c);
  return;
}


