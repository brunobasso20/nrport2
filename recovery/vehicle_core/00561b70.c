/* Ghidra pseudo-C; NR2003.exe @ 00561b70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_00561b70(undefined4 *param_1)

{
  int iVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  undefined4 uVar8;
  int iVar9;
  float10 fVar10;
  float10 fVar11;
  float10 fVar12;
  float fStack_24;
  float fStack_20;
  float fStack_1c;
  float fStack_10;
  float fStack_c;
  float fStack_8;
  float fStack_4;
  
  uVar8 = FUN_0055ab00();
  iVar9 = FUN_00562f70(uVar8);
  iVar1 = *(int *)(iVar9 + 0x58a);
  fVar10 = (float10)(float)param_1[6];
  fVar11 = (float10)(float)param_1[7];
  fStack_10 = (float)param_1[8];
  fVar2 = (float)param_1[9];
  fVar3 = (float)param_1[10];
  fVar4 = (float)param_1[0xb];
  fVar6 = (fStack_10 * fStack_10 + (float)(fVar10 * fVar10) + (float)(fVar11 * fVar11)) *
          DAT_00e0b84c * _DAT_006ea44c;
  fVar5 = fVar6 * *(float *)(iVar1 + 0xa0);
  fVar12 = (float10)fpatan(fVar11,fVar10);
  fVar11 = (float10)fpatan(-(float10)fStack_10,
                           SQRT((float10)(float)(fVar10 * fVar10) +
                                (float10)(float)(fVar11 * fVar11)));
  fVar10 = (float10)_DAT_00c083c4;
  FUN_00410280(&fStack_c,&fStack_24,iVar1,(float)(fVar11 + fVar10),(float)fVar12,fVar6,
               ((DAT_00c084c8 - **(float **)(DAT_00c084c0 + 0x2d5)) +
               (_DAT_00c084cc - **(float **)(DAT_00c08310 + 0x2d5))) * _DAT_006ea44c,
               *(undefined4 *)(iVar9 + 0x59e),*(undefined4 *)(iVar9 + 0x5a2),
               *(undefined4 *)(iVar9 + 0x5a6));
  DAT_0074e090 = DAT_0074e090 + -1;
  if (DAT_0074e090 == 0) {
    FUN_00410b50(iVar1,(float)(fVar11 + fVar10),(float)fVar12,fVar6,_DAT_0074fd74 * _DAT_006ea628);
    DAT_0074e090 = 0x10;
  }
  fVar6 = SQRT(fVar2 * fVar2 + fVar3 * fVar3 + fVar4 * fVar4);
  fVar7 = _DAT_006ea478;
  if (_DAT_006ea4cc < fVar6) {
    fVar7 = _DAT_006e97d8 / fVar6;
  }
  fVar7 = fVar7 * _DAT_006f5cf8;
  *(float *)*param_1 = fStack_c * fVar5;
  *(float *)param_1[1] = fStack_8 * fVar5;
  *(float *)param_1[2] = fStack_4 * fVar5;
  fVar5 = fVar5 * *(float *)(iVar1 + 0xa4);
  *(float *)param_1[3] = (fStack_24 + fVar2 * fVar7) * fVar5;
  *(float *)param_1[4] = (fStack_20 + fVar7 * fVar3) * fVar5;
  *(float *)param_1[5] = (fStack_1c + fVar7 * fVar4) * fVar5;
  return;
}

