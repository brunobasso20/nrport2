/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00407300 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00407300(int param_1)

{
  float10 fVar1;
  float fVar2;
  float fVar3;
  char cVar4;
  int iVar5;
  float10 fVar6;
  
  iVar5 = **(int **)(param_1 + 0x13b3);
  *(undefined4 *)(param_1 + 0x1b2e) = 0;
  fVar6 = (float10)(**(code **)(iVar5 + 0x40))(param_1,*(undefined4 *)(param_1 + 0x186e));
  fVar1 = (float10)_DAT_006ea470;
  *(float *)(param_1 + 0x1b89) = (float)(fVar6 * fVar1);
  *(float *)(param_1 + 0x1b85) = (float)(fVar6 * fVar1);
  FUN_00415210();
  iVar5 = FUN_00417fc0();
  if (((iVar5 == 6) || (iVar5 = FUN_00509b60(0xffffffff), 4 < iVar5)) &&
     (cVar4 = FUN_0052f2c0(*(undefined4 *)(param_1 + 0x186a),DAT_0074b068,
                           *(undefined4 *)(*(int *)(param_1 + 0x21e8) + 0x24)), cVar4 != '\0')) {
    (**(code **)(**(int **)(param_1 + 0x13a3) + 4))(param_1);
  }
  fVar2 = *(float *)(param_1 + 0x1b7d) - *(float *)(param_1 + 0x1b85);
  fVar3 = _DAT_006ea4d4;
  if ((fVar2 <= _DAT_006ea4d4) && (fVar3 = fVar2, fVar2 < _DAT_006ea4d0)) {
    fVar3 = _DAT_006ea4d0;
  }
  *(float *)(param_1 + 0x1b85) = fVar3 + *(float *)(param_1 + 0x1b85);
  fVar2 = *(float *)(param_1 + 0x1b81) - *(float *)(param_1 + 0x1b89);
  if (fVar2 <= _DAT_006ea4d4) {
    if (fVar2 < _DAT_006ea4d0) {
      fVar2 = _DAT_006ea4d0;
    }
    *(float *)(param_1 + 0x1b89) = fVar2 + *(float *)(param_1 + 0x1b89);
    return;
  }
  *(float *)(param_1 + 0x1b89) = _DAT_006ea4d4 + *(float *)(param_1 + 0x1b89);
  return;
}


