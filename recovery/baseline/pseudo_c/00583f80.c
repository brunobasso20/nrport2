/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00583f80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_00583f80(float *param_1,float param_2)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float *pfVar5;
  float fVar6;
  bool bVar7;
  float *pfVar8;
  float10 fVar9;
  int local_18;
  
  bVar7 = false;
  local_18 = 3;
  pfVar8 = param_1 + 0x2c;
  do {
    pfVar5 = (float *)*pfVar8;
    if (pfVar5 != (float *)0x0) {
      if (pfVar5[10] == param_1[10]) {
        pfVar1 = pfVar5 + 0xb;
        fVar2 = SQRT((pfVar5[0xb] - param_1[0xb]) * (pfVar5[0xb] - param_1[0xb]) +
                     (pfVar5[0xc] - param_1[0xc]) * (pfVar5[0xc] - param_1[0xc]) +
                     (pfVar5[0xd] - param_1[0xd]) * (pfVar5[0xd] - param_1[0xd]));
        if (fVar2 <= _DAT_006ee5b0) {
          if (fVar2 < _DAT_006ea4cc) {
            fVar2 = _DAT_006ea4cc;
          }
          fVar2 = (param_1[5] + pfVar5[5]) / fVar2;
          if (_DAT_006f6868 < fVar2) {
            fVar3 = pfVar5[5] / param_1[5];
            if (_DAT_006e97d8 <= fVar3) {
              fVar2 = fVar2 / fVar3;
            }
            else {
              fVar2 = fVar3 * fVar3 * fVar3 * fVar2;
            }
            fVar6 = fVar2 * param_2 * _DAT_006f6880;
            fVar2 = pfVar5[2];
            pfVar5[2] = fVar6 + fVar2;
            fVar9 = (float10)FUN_006c5c40();
            pfVar5[3] = (float)fVar9;
            fVar9 = (float10)FUN_006c5c40();
            fVar9 = ((float10)_DAT_006e97d8 - fVar9) * (float10)_DAT_006f3814;
            pfVar5[4] = (float)fVar9;
            *pfVar5 = (float)((fVar9 - (float10)_DAT_006efe7c) * (float10)_DAT_006ea44c);
            fVar3 = param_1[0xc];
            fVar4 = param_1[0xd];
            fVar2 = (_DAT_006ea44c / (fVar6 + fVar2)) * fVar6;
            *pfVar1 = *pfVar1 + fVar2 * (param_1[0xb] - *pfVar1);
            pfVar5[0xc] = pfVar5[0xc] + (fVar3 - pfVar5[0xc]) * fVar2;
            pfVar5[0xd] = pfVar5[0xd] + (fVar4 - pfVar5[0xd]) * fVar2;
            fVar2 = param_1[2];
            param_1[2] = fVar2 - fVar6;
            if (fVar2 - fVar6 < _DAT_006f3fe8) {
              param_1[2] = 0.0;
            }
            bVar7 = true;
          }
        }
        else {
          *pfVar8 = 0.0;
        }
      }
      else {
        *pfVar8 = 0.0;
      }
    }
    pfVar8 = pfVar8 + 1;
    local_18 = local_18 + -1;
  } while (local_18 != 0);
  if (bVar7) {
    fVar9 = (float10)FUN_006c5c40();
    param_1[3] = (float)fVar9;
    fVar9 = (float10)FUN_006c5c40();
    fVar9 = ((float10)_DAT_006e97d8 - fVar9) * (float10)_DAT_006f3814;
    param_1[4] = (float)fVar9;
    *param_1 = (float)((fVar9 - (float10)_DAT_006efe7c) * (float10)_DAT_006ea44c);
  }
  return;
}


