/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004eac30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_004eac30(int param_1_00,undefined4 param_1,undefined4 param_2,undefined4 param_3,
            undefined1 param_4,undefined4 param_5)

{
  float fVar1;
  float fVar2;
  int iVar3;
  float10 fVar4;
  
  *(undefined4 *)(param_1_00 + 0x18) = param_1;
  *(undefined1 *)(param_1_00 + 0x7c1) = param_4;
  *(undefined4 *)(param_1_00 + 0x1c) = param_2;
  *(undefined4 *)(param_1_00 + 0x20) = param_3;
  *(undefined4 *)(param_1_00 + 0x24) = param_5;
  if (*(char *)(param_1_00 + 0x7c0) == '\0') {
    return;
  }
  FUN_004eb1a0();
  if (*(char *)(param_1_00 + 0x7c0) == '\0') {
    return;
  }
  if (*(int *)(param_1_00 + 0x14) == 0) {
    return;
  }
  iVar3 = *(int *)(param_1_00 + 0x28);
  fVar1 = *(float *)(iVar3 + 0x1824);
  fVar2 = *(float *)(iVar3 + 0x1828);
  if ((_DAT_006ea454 < fVar1) || (_DAT_006ea454 < fVar2)) {
    switch(*(undefined4 *)(*(int *)(param_1_00 + 0x14) + 0x1c)) {
    case 0:
    case 2:
      if ((fVar1 <= _DAT_006ea454) ||
         (*(float *)(param_1_00 + 0x18) < *(float *)(iVar3 + 0x1824) ==
          (*(float *)(param_1_00 + 0x18) == *(float *)(iVar3 + 0x1824)))) {
        if (fVar2 <= _DAT_006ea454) {
          return;
        }
        if (*(float *)(param_1_00 + 0x1c) < *(float *)(iVar3 + 0x1828) ==
            (*(float *)(param_1_00 + 0x1c) == *(float *)(iVar3 + 0x1828))) {
          return;
        }
      }
      if ((*(int *)(param_1_00 + 0x7b4) != 0) &&
         ((float)_DAT_006ea668 < ABS(*(float *)(param_1_00 + 0x24) - _DAT_006ed740))) {
        fVar4 = (float10)FUN_004eebf0();
        FUN_004f02d0(1,(double)fVar4);
        return;
      }
      goto LAB_004eae76;
    case 1:
      if (((fVar1 <= _DAT_006ea454) || (*(float *)(iVar3 + 0x1824) < *(float *)(param_1_00 + 0x18)))
         && ((fVar2 <= _DAT_006ea454 || (*(float *)(iVar3 + 0x1828) < *(float *)(param_1_00 + 0x1c))
             ))) {
        *(undefined1 *)(param_1_00 + 0x7c3) = 0;
        if (*(int *)(param_1_00 + 0x7a4) != 0) {
LAB_004eadf6:
          fVar4 = (float10)FUN_004eebf0();
          FUN_004f02d0(0,(double)fVar4);
          return;
        }
LAB_004eace6:
        fVar4 = (float10)FUN_004eebf0();
        FUN_004f02d0(2,(double)fVar4);
        return;
      }
      break;
    case 3:
      if (((fVar1 <= _DAT_006ea454) || (*(float *)(iVar3 + 0x1824) < *(float *)(param_1_00 + 0x18)))
         && ((fVar2 <= _DAT_006ea454 || (*(float *)(iVar3 + 0x1828) < *(float *)(param_1_00 + 0x1c))
             ))) {
        *(undefined1 *)(param_1_00 + 0x7c3) = 0;
        if (*(int *)(param_1_00 + 0x7a4) != 0) {
          if ((_DAT_006ea454 <= *(float *)(param_1_00 + 0x24)) &&
             (*(float *)(param_1_00 + 0x18) < *(float *)(param_1_00 + 0x24))) goto LAB_004eadf6;
          if (ABS(*(float *)(param_1_00 + 0x24) - _DAT_006ea4a8) < (float)_DAT_006ea668) {
            fVar4 = (float10)FUN_004eebf0();
            FUN_004f02d0(0,(double)fVar4);
            return;
          }
        }
        goto LAB_004eace6;
      }
    }
  }
  else {
    if ((float)_DAT_006ef6d8 < *(float *)(param_1_00 + 0x1c)) {
      *(undefined1 *)(param_1_00 + 0x7c3) = 0;
      goto LAB_004eace6;
    }
LAB_004eae76:
    fVar4 = (float10)FUN_004eebf0();
    FUN_004f02d0(3,(double)fVar4);
  }
  return;
}


