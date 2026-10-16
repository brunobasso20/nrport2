/* NR2003.exe @ 004f02d0 FUN_004f02d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f02d0(int param_1_00,undefined4 param_1,double param_3)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;

  iVar1 = *(int *)(param_1_00 + 0x1c);
  switch(param_1) {
  case 0:
    if (iVar1 == 0) {
      return;
    }
    if ((param_3 < _DAT_006ea4b0 == (NAN(param_3) || NAN(_DAT_006ea4b0))) &&
       (param_3 <= *(double *)(param_1_00 + 0x28) + _DAT_006ea668)) {
      return;
    }
    *(double *)(param_1_00 + 0x28) = param_3;
    *(undefined4 *)(param_1_00 + 0x1c) = 0;
    break;
  case 1:
    if (iVar1 == 1) {
      return;
    }
    if ((param_3 < _DAT_006ea4b0 == (NAN(param_3) || NAN(_DAT_006ea4b0))) &&
       (param_3 <= *(double *)(param_1_00 + 0x28) + _DAT_006ea668)) {
      return;
    }
    *(double *)(param_1_00 + 0x28) = param_3;
    *(undefined4 *)(param_1_00 + 0x1c) = 1;
    break;
  case 2:
    *(undefined4 *)(param_1_00 + 0x1c) = 2;
    goto LAB_004f0378;
  case 3:
    *(undefined4 *)(param_1_00 + 0x1c) = 3;
LAB_004f0378:
    *(undefined4 *)(param_1_00 + 0x28) = 0;
    *(undefined4 *)(param_1_00 + 0x2c) = 0xc08f4000;
    break;
  default:
    goto switchD_004f02ea_caseD_4;
  }
  if (*(int *)(param_1_00 + 4) != 0) {
    FUN_004eaea0(iVar1,*(undefined4 *)(param_1_00 + 0x1c));
  }
  iVar3 = *(int *)(param_1_00 + 0x18);
  if (0 < iVar3) {
    uVar2 = *(undefined4 *)(param_1_00 + 0x1c);
    do {
      FUN_004eaea0(iVar1,uVar2);
      iVar3 = iVar3 + -1;
    } while (iVar3 != 0);
    return;
  }
switchD_004f02ea_caseD_4:
  return;
}
