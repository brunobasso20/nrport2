/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004044a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004044a0(int param_1)

{
  float fVar1;
  float fVar2;
  undefined4 *puVar3;
  char cVar4;
  undefined4 uVar5;
  undefined *puVar6;
  float *pfVar7;
  int iVar8;
  float10 fVar9;
  float10 extraout_ST1;
  undefined4 local_90 [4];
  undefined1 local_80 [124];
  
  fVar2 = _DAT_0074b7d0;
  fVar1 = _DAT_006ea454;
  *(uint *)(param_1 + 0x139f) = *(uint *)(param_1 + 0x139f) | 0x200;
  if (fVar1 < fVar2) {
    iVar8 = 0;
    pfVar7 = (float *)(param_1 + 0x1cce);
    do {
      if (*pfVar7 <= _DAT_006ea480) {
        local_90[iVar8] = 0;
      }
      else {
        uVar5 = FUN_006c5018();
        local_90[iVar8] = uVar5;
      }
      iVar8 = iVar8 + 1;
      pfVar7 = pfVar7 + 1;
    } while (iVar8 < 4);
    fVar9 = (float10)FUN_00409290();
    fVar9 = fVar9 * (float10)_DAT_006e9854;
    uVar5 = 0;
    if (_DAT_006ea480 < *(float *)(param_1 + 0x54c)) {
      uVar5 = FUN_006c5018();
      fVar9 = extraout_ST1;
    }
    puVar6 = &DAT_0071eb6a;
    if (*(char *)(param_1 + 0x73d) == '\0') {
      puVar6 = &DAT_0071eb6c;
    }
    FUN_006c4f81(local_80,s_AIPIT_IN__d___d___s_s_s__LF___2f_0071eb70,
                 *(undefined4 *)(param_1 + 0x1222),*(undefined4 *)(param_1 + 0x1a7e),
                 (&PTR_DAT_0071e874)
                 [(-(uint)(*(char *)(param_1 + 0x6f2) != '\0') & 2) +
                  (uint)(*(char *)(param_1 + 0x6f1) != '\0')],
                 (&PTR_DAT_0071e890)[*(int *)(param_1 + 0x6f5)],puVar6,
                 (double)*(float *)(param_1 + 0x1cae),local_90[0],
                 (double)*(float *)(param_1 + 0x1cb6),local_90[2],
                 (double)*(float *)(param_1 + 0x1cba),local_90[3],
                 (double)*(float *)(param_1 + 0x1cb2),local_90[1],(double)fVar9,uVar5);
    FUN_004fabc0(1,local_80);
  }
  *(undefined4 *)(param_1 + 0x16ba) = 0;
  *(undefined1 *)(param_1 + 0x1b60) = 0;
  puVar3 = DAT_00bd7924;
  if (*(int *)(param_1 + 0x13b7) == 0) {
    *(undefined4 ***)(param_1 + 0x1b91) = &DAT_00bd7924;
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd7924;
    *(undefined4 ***)(param_1 + 0x13b3) = &DAT_00bd7924;
    (*(code *)*puVar3)(param_1);
  }
  else {
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd7924;
    *(undefined1 *)(param_1 + 0x16b9) = 1;
  }
  cVar4 = FUN_00521550();
  if (cVar4 == '\0') {
    *(undefined4 *)(param_1 + 0x1b0a) = 1;
  }
  else {
    *(undefined4 *)(param_1 + 0x1b0a) = 0;
  }
  *(int *)(param_1 + 0x1b06) = *(int *)(param_1 + 0x1a7a) + 5;
  FUN_004f7680(0x3f4ccccd);
  *(undefined1 *)(param_1 + 0x1fb8) = 1;
  *(undefined1 *)(param_1 + 0x1b37) = 0;
  *(undefined1 *)(param_1 + 0x1b32) = 0;
  return;
}


