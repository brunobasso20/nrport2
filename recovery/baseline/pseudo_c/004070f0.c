/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004070f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004070f0(int param_1_00,int param_1)

{
  undefined4 uVar1;
  int iVar2;
  float10 fVar3;
  float fVar4;
  undefined4 *puVar5;
  float unaff_ESI;
  float10 fVar6;
  
  uVar1 = *(undefined4 *)(param_1 + 0x186e);
  fVar4 = *(float *)(param_1_00 + 0x20) + _DAT_006e97d8;
  iVar2 = **(int **)(param_1 + 0x13b3);
  *(undefined4 *)(param_1 + 0x1b2e) = 0;
  *(float *)(param_1_00 + 0x20) = fVar4;
  fVar6 = (float10)(**(code **)(iVar2 + 0x40))(param_1,uVar1);
  fVar3 = (float10)_DAT_006ea470;
  iVar2 = *(int *)(param_1_00 + 0xc);
  *(float *)(param_1 + 0x1b89) = (float)(fVar6 * fVar3);
  *(float *)(param_1 + 0x1b85) = (float)(fVar6 * fVar3);
  if (iVar2 == 1) {
    if ((*(float *)(param_1 + 0x1872) < *(float *)(param_1_00 + 0x10)) &&
       (unaff_ESI < *(float *)(param_1_00 + 0x1c))) {
      *(undefined4 *)(param_1 + 0x1b71) = *(undefined4 *)(param_1_00 + 0x14);
      return;
    }
    *(undefined4 *)(param_1_00 + 0xc) = 2;
  }
  else if (iVar2 != 2) {
    *(undefined4 *)(param_1 + 0x1b71) = 0x3bc63bb9;
    return;
  }
  if ((_DAT_0074b080 + _DAT_006e97d8) * _DAT_006e9810 < *(float *)(param_1 + 0x1872)) {
    *(undefined4 *)(param_1 + 0x1b71) = *(undefined4 *)(param_1_00 + 0x18);
    return;
  }
  iVar2 = *(int *)(param_1 + 0x13b7);
  *(undefined4 *)(param_1_00 + 0xc) = 0;
  puVar5 = DAT_00bd78ec;
  if (iVar2 == 0) {
    *(undefined4 ***)(param_1 + 0x1b91) = &DAT_00bd78ec;
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd78ec;
    *(undefined4 ***)(param_1 + 0x13b3) = &DAT_00bd78ec;
    (*(code *)*puVar5)(param_1);
    *(undefined4 *)(param_1 + 0x1b71) = 0x3bc63bb9;
    return;
  }
  *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd78ec;
  *(undefined1 *)(param_1 + 0x16b9) = 1;
  *(undefined4 *)(param_1 + 0x1b71) = 0x3bc63bb9;
  return;
}


