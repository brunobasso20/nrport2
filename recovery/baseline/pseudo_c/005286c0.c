/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005286c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005286c0(float param_1,float *param_2)

{
  undefined4 *puVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  bool bVar5;
  int iVar6;
  int iVar7;
  float10 fVar8;
  float10 fVar9;
  
  iVar4 = (int)param_1;
  bVar5 = inServer();
  if (bVar5) {
    iVar7 = **(int **)((int)param_1 + 0x21e8);
    iVar6 = FUN_00538ae0();
    puVar1 = (undefined4 *)(iVar6 + 0x85 + iVar7 * 0xc);
    if ((*(int *)(iVar6 + 0x89 + iVar7 * 0xc) == 0) && (puVar1[2] == -0x40100000)) {
      fVar8 = (float10)_DAT_006ea4b8;
    }
    else {
      fVar8 = (float10)(**(code **)*puVar1)();
      if (fVar8 <= (float10)*(double *)(puVar1 + 1)) {
        fVar8 = (float10)(**(code **)*puVar1)();
        fVar8 = (float10)*(double *)(puVar1 + 1) - fVar8;
      }
      else {
        fVar8 = (float10)_DAT_006ea4b0;
      }
    }
    if (fVar8 != (float10)_DAT_006ea4a8) {
      iVar7 = FUN_00536260(**(undefined4 **)((int)param_1 + 0x21e8));
      fVar9 = (float10)FUN_00516d3a(*(undefined4 *)((int)param_1 + 0x186a),
                                    *(undefined4 *)(iVar7 + 0xf));
      param_1 = (float)(fVar9 - (float10)_DAT_006e97d8);
      if (((float10)_DAT_006ea4a4 <= fVar9 - (float10)_DAT_006e97d8) || (param_1 <= _DAT_006f5110))
      {
        if (param_1 < _DAT_006ea4a4) {
          return;
        }
      }
      else {
        param_1 = 0.01;
      }
      fVar9 = (float10)FUN_004fff80();
      fVar9 = fVar9 - (float10)_DAT_006e9810;
      if (fVar9 < (float10)_DAT_006f3fe8) {
        fVar9 = (float10)_DAT_0074b080 * (float10)_DAT_006e9810;
      }
      if ((float10)(float)fVar8 * (float10)_DAT_006f410c <
          (float10)param_1 / fVar9 + (float10)_DAT_006e97d8) {
        fVar2 = (*(float *)(iVar4 + 0x1872) * *(float *)(iVar4 + 0x1872)) / param_1;
        fVar3 = _DAT_006e9818;
        if ((param_1 < _DAT_006ea4cc) || (fVar3 = fVar2, _DAT_006f510c < fVar2)) {
          fVar2 = *(float *)(iVar4 + 0x1872) - fVar3 * _DAT_006ea62c;
          if (fVar2 < _DAT_006ea454) {
            fVar2 = _DAT_006ea454;
          }
          if (fVar2 < *param_2) {
            *param_2 = fVar2;
            *(undefined4 *)(iVar4 + 0x1b2e) = 0;
            return;
          }
        }
        *(undefined4 *)(iVar4 + 0x1b2e) = 0;
      }
    }
  }
  return;
}


