/* NR2003.exe @ 004ec8d0 FUN_004ec8d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_004ec8d0(int *param_1_00,undefined4 param_1,uint param_2,undefined4 param_3)

{
  undefined uVar1;
  uint uVar2;
  float10 fVar3;
  float fVar4;
  undefined4 local_4;

  fVar4 = 0.0;
  local_4 = 0;
  uVar2 = (**(code **)(*param_1_00 + 0x38))(param_1,param_2,param_3,0x3f800000,0,&local_4);
  if ((param_1_00[5] != 0) && (*(char *)(param_1_00 + 0x1f0) != '\0')) {
    if (uVar2 < param_2) {
      if (fVar4 <= _DAT_006ea504) {
        uVar1 = 0;
      }
      else {
        uVar1 = 1;
      }
    }
    else {
      if (fVar4 <= _DAT_006ea504) {
        return uVar2;
      }
      uVar1 = 1;
    }
    *(undefined *)((int)param_1_00 + 0x7c3) = uVar1;
    fVar3 = (float10)FUN_004eebf0();
    FUN_004f02d0(2,(double)fVar3);
  }
  return uVar2;
}
