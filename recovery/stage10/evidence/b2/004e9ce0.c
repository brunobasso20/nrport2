/* NR2003.exe @ 004e9ce0 FUN_004e9ce0 */

uint __thiscall FUN_004e9ce0(int param_1_00,uint param_1)

{
  uint uVar1;
  
  if (*(int **)(param_1_00 + 0x14) != (int *)0x0) {
                    /* WARNING: Could not recover jumptable at 0x004e9cf9. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    uVar1 = (**(code **)(**(int **)(param_1_00 + 0x14) + 4))();
    return uVar1;
  }
  *(undefined4 *)(param_1 + 4) = 0x3f800000;
  return param_1 & 0xffffff00;
}

