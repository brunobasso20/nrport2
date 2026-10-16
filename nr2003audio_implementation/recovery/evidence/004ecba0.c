/* NR2003.exe @ 004ecba0 recovered_004ecba0 */

float10 __fastcall recovered_004ecba0(int param_1)

{
  int iVar1;
  
  iVar1 = *(int *)(param_1 + 0x28);
  return ((float10)*(float *)(iVar1 + 0x1870) - (float10)*(float *)(iVar1 + 0x186c)) *
         (float10)*(float *)(param_1 + 0x1c) + (float10)*(float *)(iVar1 + 0x186c);
}

