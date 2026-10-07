/* NR2003.exe @ 005582d0 FUN_005582d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_005582d0(int param_1)

{
  short *psVar1;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  if (*psVar1 == 4) {
    return (int)ROUND((*(float *)(psVar1 + 3) - *(float *)(psVar1 + 1)) / *(float *)(psVar1 + 5) +
                      _DAT_006ea4cc);
  }
  return (*(int *)(psVar1 + 3) - *(int *)(psVar1 + 1)) / *(int *)(psVar1 + 5);
}

