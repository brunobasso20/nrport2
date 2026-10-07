/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040db60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0040db60(float param_1)

{
  int iVar1;
  int iVar2;
  float fVar3;
  int iVar4;
  uint uVar5;
  float10 fVar6;
  
  iVar4 = (int)param_1;
  iVar1 = *(int *)((int)param_1 + 0x35);
  iVar2 = *(int *)(*(int *)(iVar1 + 0x89) + 0x5ae);
  if ((iVar2 == 0) || (*(char *)(iVar1 + 100) == '\0')) {
LAB_0040dc88:
    return (float10)_DAT_006ea4a8;
  }
  fVar6 = (float10)FUN_00516daa(*(undefined4 *)(iVar1 + 0x3c),*(undefined4 *)(iVar2 + 0x3c));
  param_1 = (float)fVar6;
  fVar6 = (float10)FUN_00516e1a();
  if (fVar6 * (float10)_DAT_006ea44c < (float10)param_1) {
    fVar6 = (float10)FUN_00516e1a();
    param_1 = (float)((float10)param_1 - fVar6);
  }
  fVar3 = *(float *)(iVar1 + 0x40) - *(float *)(iVar2 + 0x40);
  if (fVar3 < _DAT_006ea454) {
    fVar3 = -fVar3;
  }
  if (((param_1 <= _DAT_006ea4a8) || (_DAT_006ea6a0 <= param_1)) || (_DAT_006ea69c <= fVar3))
  goto LAB_0040dc88;
  fVar6 = (float10)_DAT_006e97d8;
  if (_DAT_006ea494 <= param_1) {
    if (param_1 <= _DAT_006ea62c) goto LAB_0040dc58;
    fVar6 = (float10)_DAT_006ea6a0 - (float10)param_1;
  }
  else {
    fVar6 = (float10)param_1 + (float10)_DAT_006e97d8;
  }
  fVar6 = fVar6 * (float10)_DAT_006ea470;
LAB_0040dc58:
  uVar5 = (uint)*(byte *)(*(int *)(iVar4 + 0x31) + 9);
  iVar1 = *(int *)(*(int *)(iVar4 + 0x39) + 0xc2);
  return ((float10)*(float *)(iVar1 + 500 + uVar5 * 8) -
         (float10)*(float *)(iVar1 + 0x1f0 + uVar5 * 8)) * fVar6 +
         (float10)*(float *)(iVar1 + 0x1f0 + uVar5 * 8);
}


