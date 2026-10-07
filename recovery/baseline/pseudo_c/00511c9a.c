/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00511c9a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00511c9a(int param_1,int param_2,int param_3)

{
  undefined4 *puVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  float fVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  int iVar16;
  int iVar17;
  float fVar18;
  float fVar19;
  float fVar20;
  float fVar21;
  float fVar22;
  float fVar23;
  float fVar24;
  float fVar25;
  float fVar26;
  float fVar27;
  int iVar28;
  undefined4 uVar29;
  float *pfVar30;
  int iVar31;
  int *piVar32;
  float10 fVar33;
  float10 fVar34;
  float10 fVar35;
  float10 fVar36;
  float local_30 [5];
  float local_1c [6];
  
  if (*(int *)(param_2 + 0x60) < 0) {
    *(undefined4 *)(param_2 + 0x60) = *(undefined4 *)(param_2 + 0x5c);
  }
  *(int *)(param_2 + 100) = *(int *)(param_2 + 0x5c);
  iVar28 = *(int *)(param_2 + 0x5c) + 1;
  *(int *)(param_2 + 0x5c) = iVar28;
  iVar31 = *(int *)(*(int *)(param_1 + 0x56) + param_3 * 4);
  puVar1 = (undefined4 *)(param_2 + 2000 + iVar28 * 0x108);
  uVar29 = FUN_00579d60(*(undefined4 *)(iVar31 + 0x51));
  *puVar1 = uVar29;
  uVar29 = *(undefined4 *)(iVar31 + 0x55);
  puVar1[1] = uVar29;
  FUN_005f65a0(param_1,(double)(*(float *)(iVar31 + 0xc) + (float)*(double *)(iVar31 + 0x35)),
               (double)(*(float *)(iVar31 + 0x10) + (float)*(double *)(iVar31 + 0x3d)),
               CONCAT31((int3)((uint)uVar29 >> 8),*(undefined1 *)(iVar31 + 0x14)),puVar1 + 0x16,
               puVar1 + 0x1b);
  FUN_005f65a0(param_1,(double)(*(float *)(iVar31 + 0xc) - (float)*(double *)(iVar31 + 0x35)),
               (double)(*(float *)(iVar31 + 0x10) - (float)*(double *)(iVar31 + 0x3d)),
               *(undefined1 *)(iVar31 + 0x14),puVar1 + 0x25,puVar1 + 0x2a);
  puVar1[0x14] = *(undefined4 *)(iVar31 + 0xc);
  puVar1[0x15] = *(undefined4 *)(iVar31 + 0x10);
  puVar1[0x3e] = (float)*(double *)(iVar31 + 0x35);
  puVar1[0x3f] = (float)((float10)*(double *)(iVar31 + 0x3d) - (float10)*(double *)(iVar31 + 0x35));
  iVar28 = *(int *)(param_1 + 0x42) + -2;
  if (-1 < iVar28) {
    piVar32 = (int *)(*(int *)(param_1 + 0x4e) + iVar28 * 4);
    do {
      if (*(float *)(*piVar32 + 0xc) <= *(float *)(iVar31 + 0xc)) break;
      iVar28 = iVar28 + -1;
      piVar32 = piVar32 + -1;
    } while (-1 < iVar28);
  }
  iVar16 = *(int *)(*(int *)(param_1 + 0x4e) + iVar28 * 4);
  iVar17 = *(int *)(*(int *)(param_1 + 0x4e) + 4 + iVar28 * 4);
  pfVar30 = (float *)(param_2 + 0xb0 + iVar28 * 0x48);
  fVar35 = (float10)fpatan((float10)*(double *)(iVar16 + 0x15) - (float10)*(double *)(iVar17 + 0x15)
                           ,(float10)*(float *)(iVar17 + 0xc) - (float10)*(float *)(iVar16 + 0xc));
  fVar36 = (float10)fpatan((float10)*(double *)(iVar16 + 0x25) - (float10)*(double *)(iVar17 + 0x25)
                           ,(float10)*(float *)(iVar17 + 0x10) - (float10)*(float *)(iVar16 + 0x10))
  ;
  if (param_3 == 0) {
    puVar1[0x40] = 0x49742400;
    puVar1[0x41] = 0;
  }
  else {
    fVar33 = (float10)fcos((float10)(double)fVar35);
    fVar33 = fVar33 * (float10)*(double *)(iVar31 + 0x15);
    puVar1[0x40] = (float)fVar33;
    fVar34 = (float10)fcos((float10)(double)fVar36);
    puVar1[0x41] = (float)(fVar34 * (float10)*(double *)(iVar31 + 0x1d) - fVar33);
  }
  fVar2 = (float)puVar1[0x3f] * _DAT_006ea454 + (float)puVar1[0x3e];
  fVar5 = pfVar30[1] * _DAT_006ea454 + *pfVar30;
  fVar3 = pfVar30[3] * _DAT_006ea454 + pfVar30[2];
  fVar4 = (((float)puVar1[0x14] - fVar2) - fVar5) / fVar3;
  fVar3 = ((fVar2 + (float)puVar1[0x14]) - fVar5) / fVar3;
  fVar19 = (((float)puVar1[0x15] - ((float)puVar1[0x3f] + (float)puVar1[0x3e])) -
           (*pfVar30 + pfVar30[1])) / (pfVar30[3] + pfVar30[2]);
  fVar18 = (((float)puVar1[0x3f] + (float)puVar1[0x3e] + (float)puVar1[0x15]) -
           (*pfVar30 + pfVar30[1])) / (pfVar30[3] + pfVar30[2]);
  fVar20 = fVar4 * pfVar30[0xc] + pfVar30[6];
  fVar21 = fVar4 * pfVar30[0xd] + pfVar30[7];
  fVar22 = fVar4 * pfVar30[0xe] + pfVar30[8];
  fVar23 = fVar4 * pfVar30[0xf] + pfVar30[9];
  fVar24 = fVar3 * pfVar30[0xc] + pfVar30[6];
  fVar25 = fVar3 * pfVar30[0xd] + pfVar30[7];
  fVar26 = fVar3 * pfVar30[0xe] + pfVar30[8];
  fVar27 = fVar3 * pfVar30[0xf] + pfVar30[9];
  fVar2 = pfVar30[0xd];
  fVar3 = pfVar30[7];
  fVar4 = pfVar30[0xe];
  fVar5 = pfVar30[8];
  fVar6 = pfVar30[0xf];
  fVar7 = pfVar30[9];
  fVar8 = pfVar30[0xc];
  fVar9 = pfVar30[6];
  fVar10 = pfVar30[0xd];
  fVar11 = pfVar30[7];
  fVar12 = pfVar30[0xe];
  fVar13 = pfVar30[8];
  fVar14 = pfVar30[0xf];
  fVar15 = pfVar30[9];
  puVar1[0x2f] = (fVar19 * pfVar30[0xc] + pfVar30[6]) - fVar20;
  puVar1[0x30] = (fVar19 * fVar2 + fVar3 + fVar20) - fVar21;
  puVar1[0x31] = (fVar19 * fVar4 + fVar5 + fVar21) - fVar22;
  puVar1[0x32] = (fVar19 * fVar6 + fVar7 + fVar22) - fVar23;
  puVar1[0x33] = fVar23;
  puVar1[0x20] = (fVar18 * fVar8 + fVar9) - fVar24;
  puVar1[0x21] = (fVar18 * fVar10 + fVar11 + fVar24) - fVar25;
  puVar1[0x22] = (fVar18 * fVar12 + fVar13 + fVar25) - fVar26;
  puVar1[0x23] = (fVar18 * fVar14 + fVar15 + fVar26) - fVar27;
  puVar1[0x24] = fVar27;
  FUN_005f65a0(param_1,(double)*(float *)(iVar31 + 0xc),(double)*(float *)(iVar31 + 0x10),0,local_30
               ,local_1c);
  fVar36 = (float10)fsin((float10)(double)fVar36);
  fVar35 = (float10)fsin((float10)(double)fVar35);
  FUN_005f65a0(param_1,(double)(fVar35 * (float10)*(double *)(iVar31 + 0x15) +
                               (float10)*(float *)(iVar31 + 0xc)),
               (double)(fVar36 * (float10)*(double *)(iVar31 + 0x1d) +
                       (float10)*(float *)(iVar31 + 0x10)),0,puVar1 + 0x34,puVar1 + 0x39);
  pfVar30 = (float *)(puVar1 + 0x39);
  iVar31 = 0;
  do {
    iVar28 = iVar31 + 4;
    pfVar30[-5] = pfVar30[-5] - *(float *)((int)local_30 + iVar31);
    *pfVar30 = *pfVar30 - *(float *)((int)local_1c + iVar31);
    pfVar30 = pfVar30 + 1;
    iVar31 = iVar28;
  } while (iVar28 < 0x14);
  return;
}


