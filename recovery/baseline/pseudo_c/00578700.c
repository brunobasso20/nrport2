/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578700 */

void __thiscall FUN_00578700(int param_1,int param_2)

{
  int *piVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  int iVar11;
  int iVar12;
  uint uVar13;
  int iVar14;
  int *piVar15;
  int iVar16;
  int local_9c0 [624];
  
  iVar8 = *(int *)(param_1 + 0x9930);
  while (iVar10 = iVar8, iVar10 != 0) {
    iVar8 = *(int *)(iVar10 + 0x50);
    if ((*(char *)(iVar10 + 0x59) == '\0') && (*(char *)(iVar10 + 0x5a) == '\0')) {
      **(int **)(iVar10 + 0x54) = iVar8;
      if (*(int *)(iVar10 + 0x50) != 0) {
        *(undefined4 *)(*(int *)(iVar10 + 0x50) + 0x54) = *(undefined4 *)(iVar10 + 0x54);
      }
      *(undefined4 *)(iVar10 + 0x50) = 0;
      *(undefined4 *)(iVar10 + 0x54) = 0;
    }
  }
  iVar8 = *(int *)(param_1 + 0x9930);
  while (iVar10 = iVar8, iVar10 != 0) {
    iVar14 = 0;
    iVar8 = *(int *)(iVar10 + 0x50);
    *(undefined1 *)(iVar10 + 0x59) = 0;
    if (*(char *)(iVar10 + 0x5a) == '\0') {
      **(int **)(iVar10 + 0x54) = iVar8;
      if (*(int *)(iVar10 + 0x50) != 0) {
        *(undefined4 *)(*(int *)(iVar10 + 0x50) + 0x54) = *(undefined4 *)(iVar10 + 0x54);
      }
      *(undefined4 *)(iVar10 + 0x50) = 0;
      *(undefined4 *)(iVar10 + 0x54) = 0;
    }
    iVar11 = *(int *)(*(int *)(iVar10 + 0xc) + 0x1a4);
    if ((iVar11 < 0) ||
       (iVar11 = (**(code **)(param_1 + 0x9954))(iVar11), *(int *)(iVar11 + 4) != 0)) {
      iVar11 = *(int *)(iVar10 + 0xc);
      fVar2 = *(float *)(iVar11 + 300);
      fVar3 = *(float *)(iVar11 + 300);
      fVar4 = *(float *)(iVar11 + 0x128);
      fVar5 = *(float *)(iVar11 + 0x128);
      fVar6 = *(float *)(iVar11 + 0x124);
      fVar7 = *(float *)(iVar11 + 0x124);
      iVar11 = FUN_005796e0(local_9c0,iVar10);
      if (0 < iVar11) {
        do {
          iVar12 = local_9c0[iVar14];
          iVar9 = *(int *)(iVar12 + 0xc);
          iVar16 = iVar10;
          if ((iVar9 != 0) &&
             (fVar6 * fVar7 + fVar4 * fVar5 + fVar2 * fVar3 <
              *(float *)(iVar9 + 0x124) * *(float *)(iVar9 + 0x124) +
              *(float *)(iVar9 + 0x128) * *(float *)(iVar9 + 0x128) +
              *(float *)(iVar9 + 300) * *(float *)(iVar9 + 300))) {
            iVar16 = iVar12;
            iVar12 = iVar10;
          }
          iVar12 = FUN_00578450(iVar16,iVar12,param_2);
          if (iVar12 != 0) {
            piVar15 = (int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44);
            piVar15[*(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) + 1] = iVar12;
            *piVar15 = *piVar15 + 1;
          }
          iVar14 = iVar14 + 1;
        } while (iVar14 < iVar11);
      }
    }
  }
  FUN_0051887a();
  uVar13 = *(uint *)(param_1 + 0x6c14) ^ 1;
  iVar10 = *(int *)(param_1 + 0x138c + uVar13 * 0x2c44);
  iVar8 = param_1 + uVar13 * 0x2c44;
  for (piVar15 = (int *)(iVar8 + 0x1390); piVar15 != (int *)(iVar8 + 0x1390 + iVar10 * 4);
      piVar15 = piVar15 + 1) {
    iVar14 = *piVar15;
    if (param_2 == *(int *)(iVar14 + 0x3e)) {
      piVar1 = (int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44);
      piVar1[*(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) + 1] = iVar14;
      *piVar1 = *piVar1 + 1;
    }
    else if (iVar14 != 0) {
      FUN_00577ee0();
      FUN_00578550(iVar14);
    }
  }
  uVar13 = *(uint *)(param_1 + 0x6c14) ^ 1;
  if (*(int *)(param_1 + 0x138c + uVar13 * 0x2c44) != 0) {
    *(undefined4 *)(param_1 + 0x138c + uVar13 * 0x2c44) = 0;
  }
  iVar10 = *(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44);
  iVar8 = param_1 + *(int *)(param_1 + 0x6c14) * 0x2c44;
  for (piVar15 = (int *)(iVar8 + 0x1390); piVar15 != (int *)(iVar8 + 0x1390 + iVar10 * 4);
      piVar15 = piVar15 + 1) {
    *(undefined2 *)(*piVar15 + 8) = 0;
  }
  iVar8 = *(int *)(param_1 + 4);
  for (piVar15 = (int *)(param_1 + 8); piVar15 != (int *)(param_1 + 8 + iVar8 * 4);
      piVar15 = piVar15 + 1) {
    *(undefined1 *)(*piVar15 + 0x58) = 0;
  }
  return;
}


