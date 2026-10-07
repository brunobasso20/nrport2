/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051eff0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051eff0(int param_1,int param_2)

{
  float fVar1;
  float10 fVar2;
  
  fVar1 = (*(float *)(param_1 + 0x1ac2) + *(float *)(param_2 + 0x1ac2)) * _DAT_006ea44c;
  fVar2 = (float10)FUN_0051700a(*(float *)(param_1 + 0x186a) - *(float *)(param_2 + 0x186a));
  return fVar2 * (float10)fVar1;
}


