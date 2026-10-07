/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00404770 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00404770(int param_1)

{
  float10 fVar1;
  float fVar2;
  float fVar3;
  undefined4 *puVar4;
  char cVar5;
  undefined4 uVar6;
  int *piVar7;
  undefined *puVar8;
  float *pfVar9;
  int iVar10;
  float10 fVar11;
  undefined4 uVar12;
  undefined4 auStack_90 [4];
  undefined1 auStack_80 [124];
  
  fVar3 = _DAT_0074b7d0;
  fVar2 = _DAT_006ea454;
  *(uint *)(param_1 + 0x139f) = *(uint *)(param_1 + 0x139f) | 0x200;
  if (fVar2 < fVar3) {
    iVar10 = 0;
    pfVar9 = (float *)(param_1 + 0x1cce);
    do {
      if (*pfVar9 <= _DAT_006ea480) {
        auStack_90[iVar10] = 0;
      }
      else {
        uVar6 = FUN_006c5018();
        auStack_90[iVar10] = uVar6;
      }
      iVar10 = iVar10 + 1;
      pfVar9 = pfVar9 + 1;
    } while (iVar10 < 4);
    fVar11 = (float10)FUN_00409290();
    fVar1 = (float10)_DAT_006e9854;
    uVar6 = 0;
    if (_DAT_006ea480 < *(float *)(param_1 + 0x54c)) {
      uVar6 = FUN_006c5018();
    }
    piVar7 = (int *)FUN_00538ab0();
    uVar12 = *(undefined4 *)(param_1 + 0x5b2);
    (**(code **)(*piVar7 + 0x30))(uVar12);
    FUN_005443c0(uVar12);
    FUN_00516e1a();
    puVar8 = &DAT_0071ebc8;
    if (*(char *)(param_1 + 0x73d) == '\0') {
      puVar8 = &DAT_0071ebca;
    }
    uVar6 = FUN_006c5018(*(undefined4 *)(param_1 + 0x1a7e),
                         (&PTR_DAT_0071e874)
                         [(-(uint)(*(char *)(param_1 + 0x6f2) != '\0') & 2) +
                          (uint)(*(char *)(param_1 + 0x6f1) != '\0')],
                         (&PTR_DAT_0071e890)[*(int *)(param_1 + 0x6f5)],puVar8,
                         (double)*(float *)(param_1 + 0x1cae),auStack_90[0],
                         (double)*(float *)(param_1 + 0x1cb6),auStack_90[2],
                         (double)*(float *)(param_1 + 0x1cba),auStack_90[3],
                         (double)*(float *)(param_1 + 0x1cb2),auStack_90[1],
                         (double)(float)(fVar11 * fVar1),uVar6);
    FUN_006c4f81(auStack_80,s_AIPIT_IN__d___d__d___s_s_s__LF___0071ebd0,
                 *(undefined4 *)(param_1 + 0x1222),uVar6);
    FUN_004fabc0(1,auStack_80);
  }
  *(undefined4 *)(param_1 + 0x16ba) = 0;
  *(undefined1 *)(param_1 + 0x1b60) = 0;
  puVar4 = DAT_00bd7924;
  if (*(int *)(param_1 + 0x13b7) == 0) {
    *(undefined4 ***)(param_1 + 0x1b91) = &DAT_00bd7924;
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd7924;
    *(undefined4 ***)(param_1 + 0x13b3) = &DAT_00bd7924;
    (*(code *)*puVar4)(param_1);
  }
  else {
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd7924;
    *(undefined1 *)(param_1 + 0x16b9) = 1;
  }
  cVar5 = FUN_00521550();
  if (cVar5 == '\0') {
    *(undefined4 *)(param_1 + 0x1b0a) = 1;
  }
  else {
    *(undefined4 *)(param_1 + 0x1b0a) = 0;
  }
  FUN_004f7680(0x3f800000);
  *(undefined1 *)(param_1 + 0x1fb8) = 1;
  *(undefined1 *)(param_1 + 0x1b37) = 0;
  *(undefined1 *)(param_1 + 0x1b32) = 0;
  return;
}


