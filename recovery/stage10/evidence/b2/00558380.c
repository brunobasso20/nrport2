/* NR2003.exe @ 00558380 FUN_00558380 */

void __thiscall FUN_00558380(int param_1_00,int param_1,int param_2)

{
  short *psVar1;
  undefined4 uVar2;
  
  psVar1 = *(short **)((int)&DAT_00c05152 + param_1 * 6);
  if (*psVar1 == 4) {
    uVar2 = (**(code **)(psVar1 + 9))
                      ((float)param_2 * *(float *)(psVar1 + 5) + *(float *)(psVar1 + 1));
    *(undefined4 *)(param_1_00 + param_1 * 4) = uVar2;
    return;
  }
  uVar2 = (**(code **)(psVar1 + 9))(*(int *)(psVar1 + 5) * param_2 + *(int *)(psVar1 + 1));
  *(undefined4 *)(param_1_00 + param_1 * 4) = uVar2;
  return;
}

