/* NR2003.exe @ 00583b30 FUN_00583b30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00583b30(void)

{
  float **ppfVar1;
  float *pfVar2;
  float fVar3;
  float *pfVar4;
  float fVar5;
  float fVar6;
  byte bVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  char cVar15;
  int iVar16;
  uint uVar17;
  undefined4 uVar18;
  float *pfVar19;
  bool bVar20;
  float10 fVar21;
  
  pfVar19 = DAT_00d6a5e0;
  iVar16 = taskGetRate();
  fVar14 = DAT_00e0b848;
  fVar13 = DAT_00e0b844;
  fVar12 = DAT_00e0b840;
  fVar8 = _DAT_006e97d8 / (float)iVar16;
  if (pfVar19 != (float *)0x0) {
    do {
      switch(pfVar19[10]) {
      case 1.401298e-45:
      case 2.802597e-45:
      case 2.242078e-44:
        fVar3 = pfVar19[7];
        fVar5 = pfVar19[5] * _DAT_006ea44c + (pfVar19[0x16] - pfVar19[0x1c]);
        pfVar19[7] = (float)((int)fVar3 + 1);
        if (fVar5 < _DAT_006ea454 != (NAN(fVar5) || NAN(_DAT_006ea454))) {
          fVar5 = _DAT_006ea454;
        }
        pfVar2 = pfVar19 + 0xb;
        fVar6 = _DAT_006e97d8 - _DAT_006f49dc / (fVar5 * _DAT_006ea470 + _DAT_006e97d8);
        fVar9 = pfVar19[0x11] - fVar12 * fVar6;
        fVar5 = pfVar19[0x12] - fVar13 * fVar6;
        fVar6 = pfVar19[0x13] - fVar14 * fVar6;
        fVar10 = pfVar19[0x11] - fVar9 * fVar8 * _DAT_006ea44c;
        pfVar19[0x11] = fVar10;
        fVar11 = pfVar19[0x12] - fVar5 * fVar8 * _DAT_006ea44c;
        pfVar19[0x12] = fVar11;
        pfVar19[0x13] = pfVar19[0x13] - fVar6 * fVar8 * _DAT_006ea44c;
        *pfVar2 = fVar10 * fVar8 + *pfVar2;
        pfVar19[0xc] = fVar11 * fVar8 + pfVar19[0xc];
        if (((((int)fVar3 + 2) % 6 == 0) &&
            (FUN_005f58d0(pfVar19 + 0x14,pfVar2), (char)((uint)pfVar19[0x29] >> 8) < '\0')) &&
           (pfVar19[0x16] < pfVar19[0x1c])) {
          pfVar19[0xd] = (pfVar19[0x1c] - pfVar19[0x16]) + pfVar19[0xd];
        }
        fVar3 = pfVar19[7];
        if ((int)fVar3 < 8) {
          uVar17 = (int)fVar3 + 1U & 0x80000003;
          bVar20 = uVar17 == 0;
          if ((int)uVar17 < 0) {
            uVar17 = uVar17 - 1 | 0xfffffffc;
LAB_00583cd3:
            bVar20 = uVar17 == 0xffffffff;
          }
        }
        else {
          uVar17 = (int)fVar3 - 3U & 0x80000007;
          bVar20 = uVar17 == 0;
          if ((int)uVar17 < 0) {
            uVar17 = uVar17 - 1 | 0xfffffff8;
            goto LAB_00583cd3;
          }
        }
        if (bVar20) {
          FUN_00583930(pfVar19);
        }
        if ((*(byte *)(pfVar19 + 7) & 1) != 0) {
          FUN_00583f80(pfVar19,fVar8);
        }
        pfVar19[5] = (((fVar9 * fVar9 + fVar5 * fVar5 + fVar6 * fVar6) * _DAT_006f687c +
                      _DAT_006e97d8) / pfVar19[5]) * pfVar19[9] * pfVar19[3] * fVar8 + pfVar19[5];
        fVar21 = (float10)FUN_006c5c40();
        fVar21 = ((float10)_DAT_006e97d8 - fVar21) * (float10)_DAT_006f3814;
        pfVar19[4] = (float)fVar21;
        fVar21 = (fVar21 - (float10)_DAT_006efe7c) * (float10)_DAT_006ea44c;
        break;
      default:
        goto switchD_00583b90_caseD_3;
      case 1.121039e-44:
        pfVar19[7] = (float)((int)pfVar19[7] + 1);
        pfVar19[0xb] = pfVar19[0x11] + pfVar19[0xb];
        pfVar19[0xc] = pfVar19[0x12] + pfVar19[0xc];
        pfVar19[0xd] = pfVar19[0x13] + pfVar19[0xd];
        if ((uint)pfVar19[6] < 8) {
          bVar7 = *(byte *)(pfVar19 + 7) & 3;
        }
        else {
          bVar7 = *(byte *)(pfVar19 + 7) & 1;
        }
        if (bVar7 == 0) {
          pfVar19[6] = (float)((int)pfVar19[6] + 1);
        }
        fVar21 = (float10)(ulonglong)(0x10 - (int)pfVar19[6]) * (float10)_DAT_006ea494;
        break;
      case 4.484155e-44:
        pfVar19[7] = (float)((int)pfVar19[7] + 1);
        pfVar19[0xb] = pfVar19[0x11] + pfVar19[0xb];
        pfVar19[0xc] = pfVar19[0x12] + pfVar19[0xc];
        pfVar19[0xd] = pfVar19[0x13] + pfVar19[0xd];
        pfVar19[0x13] = pfVar19[0x13] - _DAT_006ef7b8;
        pfVar19[0xe] = pfVar19[0xe] * _DAT_006ed020;
        pfVar19[0xf] = pfVar19[0xf] * _DAT_006ed020;
        pfVar19[0x10] = pfVar19[0x10] * _DAT_006ed020;
        fVar21 = (float10)(0x10 - (int)pfVar19[7]);
      }
      *pfVar19 = (float)fVar21;
switchD_00583b90_caseD_3:
      ppfVar1 = (float **)(pfVar19 + 0x2a);
      pfVar2 = *ppfVar1;
      if (*pfVar19 < _DAT_006ea454 != (*pfVar19 == _DAT_006ea454)) {
        fVar3 = pfVar19[10];
        if ((0 < (int)fVar3) && (((int)fVar3 < 3 || (fVar3 == 2.242078e-44)))) {
          FUN_00582450(pfVar19);
        }
        DAT_00d6a5dc = DAT_00d6a5dc + -1;
        if (pfVar19 == DAT_00d6a5e0) {
          if (pfVar19 == DAT_00d6a5e4) {
            DAT_00d6a5e4 = (float *)0x0;
          }
          DAT_00d6a5e0 = *ppfVar1;
          if (DAT_00d6a5e0 != (float *)0x0) {
            DAT_00d6a5e0[0x2b] = 0.0;
          }
        }
        else {
          pfVar4 = *ppfVar1;
          *(float **)((int)pfVar19[0x2b] + 0xa8) = pfVar4;
          if (pfVar4 == (float *)0x0) {
            DAT_00d6a5e4 = (float *)pfVar19[0x2b];
          }
          else {
            pfVar4[0x2b] = pfVar19[0x2b];
          }
        }
        pfVar19[10] = -NAN;
        *ppfVar1 = DAT_00d6a5d8;
        DAT_00d6a5d8 = pfVar19;
      }
      pfVar19 = pfVar2;
    } while (pfVar2 != (float *)0x0);
  }
  FUN_005841d0();
  cVar15 = FUN_00551880();
  if (cVar15 != '\0') {
    uVar18 = FUN_0055ab00();
    uVar18 = FUN_00562f70(uVar18);
    FUN_00584730(uVar18);
  }
  return;
}

