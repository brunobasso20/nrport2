/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00401b10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_00401b10(undefined4 param_1_00,int param_1)

{
  float fVar1;
  int iVar2;
  float10 fVar3;
  float fVar4;
  
  FUN_00415210(param_1_00);
  iVar2 = FUN_00417fc0();
  if (iVar2 == 1) {
    if (*(int *)(DAT_00760b38 + 0x1b02) < *(int *)(param_1 + 0x1b02)) {
      fVar4 = _DAT_006e9820 -
              (float)(*(int *)(param_1 + 0x1b02) - *(int *)(DAT_00760b38 + 0x1b02)) * _DAT_006e9828
              * _DAT_006e9824;
      fVar1 = *(float *)(param_1 + 0x186a) * _DAT_006e981c;
      fVar3 = (float10)FUN_00516e1a();
      return ((float10)fVar4 - (float10)fVar1 / fVar3) * (float10)_DAT_006e9818;
    }
  }
  return (float10)_DAT_006e9814;
}


