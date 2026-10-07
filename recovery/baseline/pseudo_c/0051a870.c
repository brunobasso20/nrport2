/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051a870 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0051a870(int param_1_00,float *param_1,float param_2,float param_3)

{
  bool bVar1;
  float fVar2;
  float fVar3;
  float10 fVar4;
  
  bVar1 = param_3 < _DAT_006ea454;
  *(float *)(param_1_00 + 0x484) = param_3;
  if (bVar1) {
    *(undefined4 *)(param_1_00 + 0x484) = 0;
  }
  if (_DAT_006ea454 < *(float *)(param_1_00 + 0x550)) {
    param_2 = _DAT_006ea454;
  }
  *(float *)(param_1_00 + 0x488) = param_2;
  fVar4 = (float10)FUN_005677d1(param_1_00 + 0x10,*(undefined4 *)(param_1_00 + 0x484));
  fVar4 = fVar4 * (float10)*(float *)(param_1_00 + 0x554);
  *(float *)(param_1_00 + 0x48c) = (float)fVar4;
  fVar2 = param_3;
  if (param_3 < _DAT_006f0e78) {
    fVar2 = _DAT_006f0e78;
  }
  fVar2 = (_DAT_006f0e78 / fVar2) * *(float *)(param_1_00 + 0x554) * _DAT_006f4738;
  fVar3 = (float)fVar4 - fVar2;
  *(float *)(param_1_00 + 0x48c) = fVar3;
  if (fVar3 < _DAT_006ea454) {
    *(undefined4 *)(param_1_00 + 0x48c) = 0;
  }
  *(float *)(param_1_00 + 0x48c) =
       *(float *)(param_1_00 + 0x48c) * *(float *)(param_1_00 + 0x488) + fVar2;
  fVar4 = (float10)FUN_005677d1(param_1_00 + 0x224,*(undefined4 *)(param_1_00 + 0x484));
  *(float *)(param_1_00 + 0x490) = (float)fVar4;
  if (_DAT_006ea454 < *(float *)(param_1_00 + 0x560)) {
    *(float *)(param_1_00 + 0x490) = (float)(fVar4 + (float10)*(float *)(param_1_00 + 0x560));
  }
  if (param_3 < _DAT_006ea454) {
    *(float *)(param_1_00 + 0x490) = -*(float *)(param_1_00 + 0x490);
  }
  *param_1 = *(float *)(param_1_00 + 0x48c) - *(float *)(param_1_00 + 0x490);
  return;
}


