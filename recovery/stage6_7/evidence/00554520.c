/* NR2003.exe @ 00554520 FUN_00554520 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00554520(void)

{
  char cVar1;
  bool bVar2;
  undefined4 uVar3;
  int *piVar4;
  float *pfVar5;
  int iVar6;
  int iVar7;
  float10 fVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  float fVar12;
  float fVar13;
  float local_10;
  
  cVar1 = FUN_00551880();
  if (cVar1 != '\0') {
    FUN_00551ce0();
    FUN_005547a0();
    uVar3 = FUN_0055ab00();
    piVar4 = (int *)FUN_00562f70(uVar3);
    DAT_00bf3a00 = *(float *)((int)piVar4 + 0x5aa);
    iVar7 = *(int *)((int)piVar4 + 0x5ae);
    pfVar5 = (float *)FUN_00557d60(0x3b);
    fVar12 = _DAT_006e97d8 - *pfVar5;
    uVar3 = (**(code **)(*piVar4 + 4))(1);
    fVar8 = (float10)FUN_005486a0(uVar3);
    if ((float10)_DAT_006e97d8 < fVar8) {
      fVar12 = _DAT_006e97d8;
    }
    uVar3 = *(undefined4 *)((int)piVar4 + 0x5aa);
    fVar12 = fVar12 * *(float *)((int)piVar4 + 0x5a2);
    uVar9 = 0x3f8ccccd;
    uVar10 = DAT_00e0b84c;
    uVar11 = DAT_00e0b830;
    FUN_0051a000(0x3f8ccccd,DAT_00e0b84c,DAT_00e0b830,uVar3,fVar12);
    FUN_0051a830(uVar9,uVar10,uVar11,uVar3,fVar12);
    iVar6 = taskGetRate();
    fVar12 = _DAT_006e97d8 / (float)iVar6;
    fVar13 = fVar12;
    FUN_0051a000(fVar12);
    FUN_0051aac0(fVar13);
    FUN_0051c2d0(fVar12);
    FUN_0051c3d0(fVar12);
    FUN_005605c0();
    bVar2 = inBackground();
    if (bVar2) {
      if (iVar7 != 0) {
        FUN_005f74c0(piVar4 + 0x54c,piVar4 + 0x54d,piVar4 + 0x54e,iVar7 + 0x58);
      }
      FUN_00551990(piVar4);
    }
    if ((DAT_00bf6ebb != '\0') && (DAT_00bf6eb8 == '\0')) {
      iVar7 = taskGetRate();
      fVar12 = DAT_00bf6ec4 - _DAT_00bf6ec0;
      _DAT_00bf6ec0 = DAT_00bf6ec4;
      fVar12 = fVar12 * (float)iVar7;
      fVar13 = _DAT_00bf6ed0;
      if (_DAT_006ea480 < (float)((uint)DAT_00bf6ec4 & 0x7fffffff)) {
        fVar13 = ((_DAT_00bf6f20 * _DAT_006ea67c *
                   (_DAT_006e97d8 - _DAT_006ecfc8 / (DAT_00bf3a00 + _DAT_006ecfc8)) * fVar12 +
                  DAT_00bf6ec4) / DAT_00bf6ec4) * _DAT_00bf6ed0;
      }
      fVar12 = ((fVar13 - _DAT_00bf6f24 * fVar12) + _DAT_00bf6ecc) * _DAT_006ea44c;
      _DAT_00bf6ecc = fVar12;
      pfVar5 = (float *)FUN_00557d60(0x30);
      fVar12 = (_DAT_0074c9a4 / (*pfVar5 * _DAT_006f5a44)) * fVar12;
      local_10 = _DAT_006e97d8;
      if ((_DAT_006e97d8 < fVar12 == (NAN(_DAT_006e97d8) || NAN(fVar12))) &&
         (local_10 = fVar12, fVar12 < _DAT_006ea4a8)) {
        local_10 = -1.0;
      }
      FUN_005d08d0(DAT_00bf6ebc,local_10);
    }
  }
  return;
}

