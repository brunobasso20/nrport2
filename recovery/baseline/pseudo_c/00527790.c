/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00527790 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00527790(int param_1_00,int param_1,float *param_2)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  float10 fVar5;
  
  fVar2 = *(float *)(param_1 + 0x184e) + *(float *)(param_1 + 0x1bad);
  fVar3 = *(float *)(param_1 + 0x1852) + *(float *)(param_1 + 0x1bb1);
  fVar5 = (float10)FUN_0051700a((*(float *)(param_1 + 0x1846) + *(float *)(param_1 + 0x1b8d) +
                                _DAT_006ea62c) * *(float *)(param_1 + 0x1872) +
                                *(float *)(param_1 + 0x186a));
  fVar1 = *(float *)(*(int *)(param_1_00 + 0xc) + 8 +
                    (int)ROUND((float)((float10)_DAT_00bd7914 * fVar5)) * 0x1c);
  iVar4 = (int)ROUND((float)((float10)_DAT_00bd7914 * fVar5)) * 0x40 + *(int *)(param_1_00 + 0x18);
  *param_2 = fVar1 * fVar1 + *(float *)(iVar4 + 0x24) * fVar2 + *(float *)(iVar4 + 0x28) * fVar3;
  if (*(float *)(param_1 + 0x187a) < _DAT_006efac8) {
    fVar5 = (float10)FUN_0051700a(((_DAT_006e97d8 - *(float *)(param_1 + 0x187a)) * _DAT_006f410c +
                                   *(float *)(param_1 + 0x1b8d) + *(float *)(param_1 + 0x1846) +
                                  _DAT_006ea62c) * *(float *)(param_1 + 0x1872) +
                                  *(float *)(param_1 + 0x186a));
    fVar1 = *(float *)(*(int *)(param_1_00 + 0xc) + 8 +
                      (int)ROUND((float)((float10)_DAT_00bd7914 * fVar5)) * 0x1c);
    iVar4 = (int)ROUND((float)((float10)_DAT_00bd7914 * fVar5)) * 0x40 + *(int *)(param_1_00 + 0x18)
    ;
    fVar1 = fVar1 * fVar1 + *(float *)(iVar4 + 0x24) * fVar2 + *(float *)(iVar4 + 0x28) * fVar3;
    if (fVar1 < *param_2) {
      *param_2 = fVar1;
    }
  }
  if (*param_2 < _DAT_006ea450) {
    *param_2 = 0.06204;
  }
  fVar1 = SQRT(*(float *)(param_1 + 0x187a) * *param_2);
  *param_2 = fVar1;
  fVar1 = (fVar1 - *(float *)(param_1 + 0x1872)) * _DAT_006f49d0 - *(float *)(param_1 + 0x1aca);
  if (*(float *)(param_1 + 0x1972) < fVar1) {
    fVar1 = *(float *)(param_1 + 0x1972);
  }
  *(float *)(param_1 + 0x189a) = fVar1;
  fVar1 = *(float *)(param_1 + 0x1b75) * _DAT_006ea62c + *(float *)(param_1 + 0x1872);
  if (*param_2 <= fVar1) {
    return;
  }
  *param_2 = fVar1;
  return;
}


