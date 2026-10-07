/* NR2003.exe @ 00558320 FUN_00558320 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __thiscall FUN_00558320(int param_1_00,int param_1)

{
  short *psVar1;
  float fVar2;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  fVar2 = (float)(**(code **)(psVar1 + 0xb))(*(undefined4 *)(param_1_00 + param_1 * 4));
  if (*psVar1 == 3) {
    return ((int)fVar2 - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
  }
  return (int)ROUND((fVar2 - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) + _DAT_006ea4cc);
}

