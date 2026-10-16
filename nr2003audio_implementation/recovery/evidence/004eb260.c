/* NR2003.exe @ 004eb260 recovered_004eb260 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __fastcall recovered_004eb260(int param_1)

{
  int iVar1;
  float fVar2;
  char cVar3;
  char cVar4;
  int iVar5;
  float *pfVar6;
  int iVar7;
  int iVar8;
  float fStack_20;
  float *pfStack_1c;
  undefined auStack_10 [4];
  float fStack_c;
  undefined auStack_8 [4];
  float fStack_4;
  
  FUN_004eb1a0();
  iVar7 = *(int *)(param_1 + 0x794);
  fStack_20 = 0.0;
  if (0 < iVar7) {
    iVar5 = getIntCount();
    iVar8 = 0;
    if (0 < iVar7) {
      pfStack_1c = (float *)(param_1 + 0x694);
      do {
        if ((*(int *)(param_1 + 0x790) != 0) &&
           (iVar7 = *(int *)(*(int *)(*(int *)(param_1 + 0x790) + iVar8 * 4) + 0xb9),
           *(int *)(param_1 + 0x610 + iVar7 * 4) != 0)) {
          iVar1 = param_1 + iVar7 * 0xd;
          pfVar6 = (float *)(param_1 + iVar7 * 0xd + 0x478);
          if (*(char *)(iVar1 + 0x47c) == '\0') {
            fVar2 = *pfVar6 - (float)(iVar5 - *(int *)(iVar1 + 0x474)) * *(float *)(iVar1 + 0x470);
            *pfVar6 = fVar2;
            if (fVar2 < _DAT_006ea454 != (NAN(fVar2) || NAN(_DAT_006ea454))) {
              *pfVar6 = 0.0;
            }
          }
          else {
            fVar2 = (float)(iVar5 - *(int *)(iVar1 + 0x474)) * *(float *)(iVar1 + 0x470) + *pfVar6;
            *pfVar6 = fVar2;
            if (_DAT_006e97d8 < fVar2) {
              *pfVar6 = 1.0;
            }
          }
          *(int *)(iVar1 + 0x474) = iVar5;
        }
        iVar7 = *(int *)(*(int *)(param_1 + 0x790) + iVar8 * 4);
        if ((iVar7 == 0) || (*(int *)(param_1 + 0x610 + *(int *)(iVar7 + 0xb9) * 4) == 0)) {
LAB_004eb3e2:
          *pfStack_1c = -1.0;
        }
        else {
          cVar3 = FUN_004e9ce0(auStack_8,*(undefined4 *)(param_1 + 0x18),0);
          cVar4 = FUN_004e9ce0(auStack_10,*(undefined4 *)(param_1 + 0x1c),0);
          *pfStack_1c = fStack_c * fStack_4;
          if ((cVar3 == '\0') && (cVar4 == '\0')) goto LAB_004eb3e2;
          fVar2 = *(float *)((*(int *)(*(int *)(*(int *)(param_1 + 0x790) + iVar8 * 4) + 0xb9) +
                             0x58) * 0xd + param_1) * *pfStack_1c;
          *pfStack_1c = fVar2;
          fStack_20 = fVar2 + fStack_20;
        }
        iVar8 = iVar8 + 1;
        pfStack_1c = pfStack_1c + 2;
      } while (iVar8 < *(int *)(param_1 + 0x794));
    }
    iVar7 = 0;
    fVar2 = _DAT_006e97d8 / (fStack_20 + _DAT_006ea480);
    if (0 < *(int *)(param_1 + 0x794)) {
      pfVar6 = (float *)(param_1 + 0x694);
      do {
        iVar7 = iVar7 + 1;
        *pfVar6 = fVar2 * *pfVar6;
        pfVar6 = pfVar6 + 2;
      } while (iVar7 < *(int *)(param_1 + 0x794));
    }
    if (_DAT_006e97d8 < fStack_20) {
      return (float10)_DAT_006e97d8;
    }
  }
  return (float10)fStack_20;
}

