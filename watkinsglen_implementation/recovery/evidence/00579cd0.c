/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579cd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00579cd0(void)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;

  fVar1 = _DAT_00b8f258 * _DAT_006ea44c;
  iVar7 = 0x11;
  do {
    fVar3 = _DAT_006e97d8;
    fVar2 = _DAT_006e97d8;
    if (iVar7 == 0x12) {
      fVar2 = SQRT(fVar1);
      fVar3 = fVar1;
    }
    iVar6 = (iVar7 * 5 + -0x55) * 0x10;
    iVar4 = 0;
    do {
      iVar5 = iVar4 + 4;
      *(float *)(iVar6 + 0xd35a14 + iVar5) =
           (*(float *)((int)&DAT_006f6148 + iVar4) * (float)(&DAT_006f6148)[iVar7] * fVar3) /
           (*(float *)((int)&DAT_006f6148 + iVar4) + (float)(&DAT_006f6148)[iVar7]);
      *(float *)(iVar6 + 0xd35924 + iVar5) =
           (*(float *)((int)&DAT_006f6198 + iVar4) * (float)(&DAT_006f6198)[iVar7] * fVar2) /
           (*(float *)((int)&DAT_006f6198 + iVar4) + (float)(&DAT_006f6198)[iVar7]);
      iVar4 = iVar5;
    } while (iVar5 < 0x50);
    iVar7 = iVar7 + 1;
  } while (iVar7 < 0x14);
  return;
}
