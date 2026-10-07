/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005577d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005577d0(int *param_1,undefined4 param_2,undefined4 param_3)

{
  int iVar1;
  int *piVar2;
  float10 fVar3;
  undefined1 local_18 [4];
  float local_14;
  undefined1 local_10 [4];
  float local_c;
  float local_4;
  
  if (DAT_00bf8a88 != 0) {
    param_1 = (int *)0x0;
    piVar2 = &DAT_00bf8a08;
    do {
      iVar1 = *piVar2;
      if ((((*(int *)(iVar1 + 0x44) != 3) && (*(int *)(iVar1 + 0x44) != 4)) ||
          ((*(int *)(iVar1 + 0x5c) != 3 && (*(int *)(iVar1 + 0x5c) != 4)))) &&
         (*(int *)(iVar1 + 0xa8) == 0)) {
        FUN_004e9ce0(local_10,param_2,0);
        FUN_004e9ce0(local_18,param_3,0);
        local_4 = local_14 * local_c;
        param_1 = (int *)(local_4 + (float)param_1);
      }
      piVar2 = piVar2 + 1;
    } while ((int)piVar2 < 0xbf8a88);
    if ((float)param_1 <= _DAT_006e97d8) {
      if ((float)param_1 < _DAT_006ea454) {
        param_1 = (int *)0x0;
      }
    }
    else {
      param_1 = (int *)0x3f800000;
    }
    return ((float10)_DAT_00bf8ad8 - (float10)_DAT_00bf8ad4) * (float10)(float)param_1 +
           (float10)_DAT_00bf8ad4;
  }
  fVar3 = (float10)(**(code **)(*param_1 + 0x30))();
  return fVar3;
}


