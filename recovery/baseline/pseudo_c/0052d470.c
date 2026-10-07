/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052d470 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052d470(int param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  uint uVar8;
  uint uVar9;
  uint uVar10;
  uint uVar11;
  uint uVar12;
  char cVar13;
  int *piVar14;
  int iVar15;
  int iVar16;
  float *pfVar17;
  float10 fVar18;
  undefined4 uVar19;
  
  if (*(int *)(param_1 + 0x2210) != 0) {
    uVar19 = *(undefined4 *)(param_1 + 0x5b2);
    piVar14 = (int *)FUN_00538ab0();
    (**(code **)(*piVar14 + 0x30))(uVar19);
    iVar15 = FUN_005443c0(uVar19);
    if (-1 < iVar15) {
      uVar19 = *(undefined4 *)(param_1 + 0x5b2);
      piVar14 = (int *)FUN_00538ab0();
      iVar16 = iVar15;
      (**(code **)(*piVar14 + 0x30))(uVar19,iVar15);
      cVar13 = FUN_005438c0(uVar19,iVar16);
      if (cVar13 == '\0') {
        uVar19 = *(undefined4 *)(param_1 + 0x5b2);
        piVar14 = (int *)FUN_00538ab0();
        iVar16 = iVar15;
        (**(code **)(*piVar14 + 0x30))(uVar19,iVar15);
        fVar18 = (float10)FUN_00543a40(uVar19,iVar16);
        *(float *)(param_1 + 0x21f4 + *(int *)(param_1 + 0x21f0) * 4) = (float)fVar18;
        iVar16 = *(int *)(param_1 + 0x21f0) + 1;
        *(int *)(param_1 + 0x21f0) = iVar16;
        if (5 < iVar16) {
          *(undefined4 *)(param_1 + 0x21f0) = 0;
        }
        iVar16 = 4;
        *(undefined4 *)(param_1 + 0x2208) = *(undefined4 *)(param_1 + 0x21f4);
        pfVar17 = (float *)(param_1 + 0x21f8);
        do {
          if (*pfVar17 < *(float *)(param_1 + 0x2208)) {
            *(float *)(param_1 + 0x2208) = *pfVar17;
          }
          pfVar17 = pfVar17 + 1;
          iVar16 = iVar16 + -1;
        } while (iVar16 != 0);
        if (*(float *)(param_1 + 0x2208) <= _DAT_006e97d8) {
          *(undefined4 *)(param_1 + 0x220c) = 0x3f800000;
        }
        else {
          *(float *)(param_1 + 0x220c) = _DAT_006e97d8 / *(float *)(param_1 + 0x2208);
        }
        if (iVar15 < DAT_00bdaa38) {
          iVar16 = FUN_005099b0();
          if (iVar16 == 7) {
            iVar16 = FUN_00538ab0();
            if (*(char *)(iVar16 + 0x10327) == '\0') {
              iVar16 = FUN_00538ac0();
              uVar19 = DAT_00748520;
              if (*(char *)(param_1 + 0x59b) == '\0') {
                (&DAT_00bd7a20)[iVar15 * 6] = (float)fVar18;
                FUN_005f5890(&DAT_00bf3aa0);
                uVar5 = *DAT_00bf3a94;
                uVar6 = *DAT_00bf3a9c;
                FUN_005f58a0(&DAT_00bf3aa0);
                FUN_005f5890(&DAT_00bf44d9);
                uVar7 = *DAT_00bf44cd;
                uVar8 = *DAT_00bf44d5;
                FUN_005f58a0(&DAT_00bf44d9);
                FUN_005f5890(&DAT_00bf4f12);
                uVar9 = *DAT_00bf4f06;
                uVar10 = *DAT_00bf4f0e;
                FUN_005f58a0(&DAT_00bf4f12);
                FUN_005f5890(&DAT_00bf594b);
                uVar11 = *DAT_00bf593f;
                uVar12 = *DAT_00bf5947;
                FUN_005f58a0(&DAT_00bf594b);
                (&DAT_00bd7a24)[iVar15 * 6] =
                     ((float)(uVar11 ^ uVar12) + (float)(uVar9 ^ uVar10) + (float)(uVar7 ^ uVar8) +
                     (float)(uVar5 ^ uVar6)) * _DAT_006ea50c;
              }
              else if (*(int *)(param_1 + 0x5b2) == *(int *)(iVar16 + 0x30)) {
                (&DAT_00bd7a2c)[iVar15 * 6] = (float)fVar18;
                fVar1 = *(float *)(param_1 + 0x1cba);
                fVar2 = *(float *)(param_1 + 0x1cb6);
                fVar3 = *(float *)(param_1 + 0x1cb2);
                fVar4 = *(float *)(param_1 + 0x1cae);
                (&DAT_00bd7a34)[iVar15 * 6] = uVar19;
                (&DAT_00bd7a30)[iVar15 * 6] = (fVar1 + fVar2 + fVar3 + fVar4) * _DAT_006ea50c;
              }
            }
          }
        }
      }
    }
  }
  piVar14 = (int *)FUN_00538ae0();
  iVar15 = (**(code **)(*piVar14 + 0x38))();
  *(uint *)(param_1 + 0x2210) = (uint)(iVar15 == 0);
  return;
}


