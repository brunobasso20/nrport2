/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00583b30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00583b30(void)

{
  float *pfVar1;
  float *pfVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  byte bVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float *pfVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  char cVar15;
  int iVar16;
  uint uVar17;
  undefined4 uVar18;
  bool bVar19;
  float10 fVar20;
  
  pfVar2 = DAT_00d6a5e0;
  iVar16 = taskGetRate();
  fVar14 = DAT_00e0b848;
  fVar13 = DAT_00e0b844;
  fVar12 = DAT_00e0b840;
  fVar7 = _DAT_006e97d8 / (float)iVar16;
  do {
    pfVar11 = pfVar2;
    if (pfVar11 == (float *)0x0) {
      FUN_005841d0();
      cVar15 = FUN_00551880();
      if (cVar15 != '\0') {
        uVar18 = FUN_0055ab00();
        uVar18 = FUN_00562f70(uVar18);
        FUN_00584730(uVar18);
      }
      return;
    }
    switch(pfVar11[10]) {
    case 1.4013e-45:
    case 2.8026e-45:
    case 2.24208e-44:
      fVar3 = pfVar11[7];
      fVar4 = pfVar11[5] * _DAT_006ea44c + (pfVar11[0x16] - pfVar11[0x1c]);
      pfVar11[7] = (float)((int)fVar3 + 1);
      if (fVar4 < _DAT_006ea454) {
        fVar4 = _DAT_006ea454;
      }
      pfVar2 = pfVar11 + 0xb;
      fVar5 = _DAT_006e97d8 - _DAT_006f49dc / (fVar4 * _DAT_006ea470 + _DAT_006e97d8);
      fVar8 = pfVar11[0x11] - fVar12 * fVar5;
      fVar4 = pfVar11[0x12] - fVar13 * fVar5;
      fVar5 = pfVar11[0x13] - fVar14 * fVar5;
      fVar9 = pfVar11[0x11] - fVar8 * fVar7 * _DAT_006ea44c;
      pfVar11[0x11] = fVar9;
      fVar10 = pfVar11[0x12] - fVar4 * fVar7 * _DAT_006ea44c;
      pfVar11[0x12] = fVar10;
      pfVar11[0x13] = pfVar11[0x13] - fVar5 * fVar7 * _DAT_006ea44c;
      *pfVar2 = fVar9 * fVar7 + *pfVar2;
      pfVar11[0xc] = fVar10 * fVar7 + pfVar11[0xc];
      if (((((int)fVar3 + 2) % 6 == 0) &&
          (FUN_005f58d0(pfVar11 + 0x14,pfVar2), (char)((uint)pfVar11[0x29] >> 8) < '\0')) &&
         (pfVar11[0x16] < pfVar11[0x1c])) {
        pfVar11[0xd] = (pfVar11[0x1c] - pfVar11[0x16]) + pfVar11[0xd];
      }
      fVar3 = pfVar11[7];
      if ((int)fVar3 < 8) {
        uVar17 = (int)fVar3 + 1U & 0x80000003;
        bVar19 = uVar17 == 0;
        if ((int)uVar17 < 0) {
          uVar17 = uVar17 - 1 | 0xfffffffc;
LAB_00583cd3:
          bVar19 = uVar17 == 0xffffffff;
        }
      }
      else {
        uVar17 = (int)fVar3 - 3U & 0x80000007;
        bVar19 = uVar17 == 0;
        if ((int)uVar17 < 0) {
          uVar17 = uVar17 - 1 | 0xfffffff8;
          goto LAB_00583cd3;
        }
      }
      if (bVar19) {
        FUN_00583930(pfVar11);
      }
      if (((uint)pfVar11[7] & 1) != 0) {
        FUN_00583f80(pfVar11,fVar7);
      }
      pfVar11[5] = (((fVar8 * fVar8 + fVar4 * fVar4 + fVar5 * fVar5) * _DAT_006f687c + _DAT_006e97d8
                    ) / pfVar11[5]) * pfVar11[9] * pfVar11[3] * fVar7 + pfVar11[5];
      fVar20 = (float10)FUN_006c5c40();
      fVar20 = ((float10)_DAT_006e97d8 - fVar20) * (float10)_DAT_006f3814;
      pfVar11[4] = (float)fVar20;
      fVar20 = (fVar20 - (float10)_DAT_006efe7c) * (float10)_DAT_006ea44c;
      break;
    default:
      goto switchD_00583b90_caseD_3;
    case 1.12104e-44:
      pfVar11[7] = (float)((int)pfVar11[7] + 1);
      pfVar11[0xb] = pfVar11[0x11] + pfVar11[0xb];
      pfVar11[0xc] = pfVar11[0x12] + pfVar11[0xc];
      pfVar11[0xd] = pfVar11[0x13] + pfVar11[0xd];
      if ((uint)pfVar11[6] < 8) {
        bVar6 = *(byte *)(pfVar11 + 7) & 3;
      }
      else {
        bVar6 = *(byte *)(pfVar11 + 7) & 1;
      }
      if (bVar6 == 0) {
        pfVar11[6] = (float)((int)pfVar11[6] + 1);
      }
      fVar20 = (float10)(0x10 - (int)pfVar11[6]) * (float10)_DAT_006ea494;
      break;
    case 4.48416e-44:
      pfVar11[7] = (float)((int)pfVar11[7] + 1);
      pfVar11[0xb] = pfVar11[0x11] + pfVar11[0xb];
      pfVar11[0xc] = pfVar11[0x12] + pfVar11[0xc];
      pfVar11[0xd] = pfVar11[0x13] + pfVar11[0xd];
      pfVar11[0x13] = pfVar11[0x13] - _DAT_006ef7b8;
      pfVar11[0xe] = pfVar11[0xe] * _DAT_006ed020;
      pfVar11[0xf] = pfVar11[0xf] * _DAT_006ed020;
      pfVar11[0x10] = pfVar11[0x10] * _DAT_006ed020;
      fVar20 = (float10)(0x10 - (int)pfVar11[7]);
    }
    *pfVar11 = (float)fVar20;
switchD_00583b90_caseD_3:
    pfVar1 = pfVar11 + 0x2a;
    pfVar2 = (float *)*pfVar1;
    if (*pfVar11 < _DAT_006ea454 != (*pfVar11 == _DAT_006ea454)) {
      fVar3 = pfVar11[10];
      if ((0 < (int)fVar3) && (((int)fVar3 < 3 || (fVar3 == 2.24208e-44)))) {
        FUN_00582450(pfVar11);
      }
      DAT_00d6a5dc = DAT_00d6a5dc + -1;
      if (pfVar11 == DAT_00d6a5e0) {
        if (pfVar11 == DAT_00d6a5e4) {
          DAT_00d6a5e4 = (float *)0x0;
        }
        DAT_00d6a5e0 = (float *)*pfVar1;
        if (DAT_00d6a5e0 != (float *)0x0) {
          DAT_00d6a5e0[0x2b] = 0.0;
        }
      }
      else {
        fVar3 = *pfVar1;
        *(float *)((int)pfVar11[0x2b] + 0xa8) = fVar3;
        if (fVar3 == 0.0) {
          DAT_00d6a5e4 = (float *)pfVar11[0x2b];
        }
        else {
          *(float *)((int)fVar3 + 0xac) = pfVar11[0x2b];
        }
      }
      pfVar11[10] = -NAN;
      *pfVar1 = (float)DAT_00d6a5d8;
      DAT_00d6a5d8 = pfVar11;
    }
  } while( true );
}


