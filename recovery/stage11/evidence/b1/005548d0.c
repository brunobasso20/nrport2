/* NR2003.exe @ 005548d0 FUN_005548d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005548d0(undefined4 param_1,code *param_2)

{
  undefined4 *puVar1;
  float fVar2;
  bool bVar3;
  char cVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  undefined4 *puVar8;
  undefined4 *puVar9;
  float10 fVar10;
  float local_28;
  undefined4 local_24;
  undefined4 local_20;
  undefined4 local_1c;
  undefined4 local_18;
  undefined4 local_14;
  
  if (DAT_00bf63d8 == '\0') {
    return;
  }
  bVar3 = false;
  cVar4 = FUN_00551880();
  if (cVar4 != '\0') {
    local_24 = DAT_00bf63da;
    local_20 = DAT_00bf63de;
    local_1c = FUN_005b2180();
    local_18 = DAT_00bf6ef8;
    local_14 = DAT_00bf6efc;
    cVar4 = FUN_005b0900(0);
    if (cVar4 != '\0') {
      FUN_005b0980(0,0x14,&local_24,0);
    }
    cVar4 = FUN_005b0900(1);
    if (cVar4 != '\0') {
      FUN_005b0980(1,0x4c,&DAT_00bf63f6,0);
    }
    cVar4 = FUN_005b0900(2);
    if (cVar4 != '\0') {
      FUN_005b0980(2,0x40,&DAT_00bf6442,0);
    }
    cVar4 = FUN_005b0900(3);
    if (cVar4 != '\0') {
      FUN_005b0980(3,0x40,&DAT_00bf6482,0);
    }
    cVar4 = FUN_005b0900(4);
    if (cVar4 != '\0') {
      FUN_005b0980(4,0xc,&DAT_00bf64c2,0);
    }
    cVar4 = FUN_005b0900(5);
    if (cVar4 != '\0') {
      FUN_005b0980(5,0x14,&DAT_00bf64ce,0);
    }
    bVar3 = true;
  }
  iVar5 = FUN_00555140();
  iVar6 = FUN_005b2180();
  if (iVar6 == iVar5 + -1) {
    cVar4 = FUN_005b0900(0x40);
    if ((cVar4 != '\0') && (cVar4 = FUN_00551880(), cVar4 != '\0')) {
      iVar5 = FUN_0051a000();
      _DAT_00bf64e2 = *(undefined4 *)(iVar5 + 0x484);
      iVar5 = FUN_0051a000();
      FUN_005f5890(iVar5 + 0x4e0);
      FUN_00425e80(&local_28,*(undefined4 *)(iVar5 + 0x4d4),*(undefined4 *)(iVar5 + 0x4dc),4);
      FUN_005f58a0(iVar5 + 0x4e0);
      _DAT_00bf64e6 = local_28;
      iVar5 = FUN_0051a000();
      _DAT_00bf64ea = *(undefined4 *)(iVar5 + 0x500);
      iVar5 = FUN_0051a000();
      FUN_005f5890(iVar5 + 0x4b0);
      FUN_00425e80(&local_28,*(undefined4 *)(iVar5 + 0x4a4),*(undefined4 *)(iVar5 + 0x4ac),4);
      FUN_005f58a0(iVar5 + 0x4b0);
      _DAT_00bf64ee = local_28;
      iVar5 = FUN_0051a000();
      _DAT_00bf64f2 = *(undefined4 *)(iVar5 + 0x4d0);
      iVar5 = FUN_0051a000();
      _DAT_00bf64f6 = *(undefined4 *)(iVar5 + 0x504);
      iVar5 = FUN_0051a000();
      local_28 = *(float *)(iVar5 + 0x484);
      iVar5 = FUN_0051a000();
      fVar2 = *(float *)(*(int *)(iVar5 + 0x56a) + 0x2c) - _DAT_006f58f8;
      DAT_00bf64fa = DAT_00bf64fa ^
                     (fVar2 < local_28 != (NAN(fVar2) || NAN(local_28)) ^ DAT_00bf64fa) & 1;
      iVar5 = FUN_0051a000();
      FUN_005f5890(iVar5 + 0x4e0);
      local_28 = (float)(**(uint **)(iVar5 + 0x4d4) ^ **(uint **)(iVar5 + 0x4dc));
      FUN_005f58a0(iVar5 + 0x4e0);
      DAT_00bf64fa = DAT_00bf64fa ^ ((_DAT_006ee574 < local_28) * '\x02' ^ DAT_00bf64fa) & 2;
      iVar5 = FUN_0051a000();
      DAT_00bf64fa = DAT_00bf64fa ^
                     ((*(float *)(iVar5 + 0x4d0) < _DAT_006f5a4c !=
                      (NAN(*(float *)(iVar5 + 0x4d0)) || NAN(_DAT_006f5a4c))) << 2 ^ DAT_00bf64fa) &
                     4;
      iVar5 = FUN_0051a000();
      DAT_00bf64fa = DAT_00bf64fa ^
                     ((*(float *)(iVar5 + 0x500) < _DAT_006f5a48 !=
                      (NAN(*(float *)(iVar5 + 0x500)) || NAN(_DAT_006f5a48))) << 3 ^ DAT_00bf64fa) &
                     8;
      FUN_005b0980(0x40,0x19,&DAT_00bf64e2,0);
      bVar3 = true;
    }
    cVar4 = FUN_005b0900(0x41);
    if (cVar4 != '\0') {
      iVar5 = 0;
      local_28 = 0.0;
      cVar4 = (*param_2)(&local_28);
      if (cVar4 != '\0') {
        puVar8 = &DAT_00bf64fb;
        do {
          puVar9 = puVar8;
          if ((*(int *)((int)local_28 + 4) != 0) &&
             (iVar6 = *(int *)((int)local_28 + 0x5b2), iVar7 = FUN_0055ab00(), iVar6 != iVar7)) {
            iVar5 = iVar5 + 1;
            puVar9 = puVar8 + 0xb;
            puVar1 = *(undefined4 **)((int)local_28 + 0x5ae);
            *puVar8 = *(undefined4 *)((int)local_28 + 0x5b2);
            fVar10 = (float10)FUN_00516e1a();
            puVar8[1] = (float)((float10)(float)puVar1[0xf] / fVar10);
            puVar8[2] = *puVar1;
            puVar8[3] = puVar1[1];
            puVar8[4] = puVar1[2];
            puVar8[5] = puVar1[3];
            puVar8[6] = puVar1[4];
            puVar8[7] = puVar1[5];
            FUN_005f6e40(&local_24,puVar1 + 0x1f);
            FUN_005f74c0(puVar8 + 8,puVar8 + 9,puVar8 + 10,&local_24);
          }
          cVar4 = (*param_2)(&local_28);
          puVar8 = puVar9;
        } while (cVar4 != '\0');
        if (0 < iVar5) {
          FUN_005b0980(0x41,iVar5 * 0x2c,&DAT_00bf64fb,0);
          goto LAB_00554cfe;
        }
      }
    }
  }
  if (!bVar3) {
    return;
  }
LAB_00554cfe:
  iVar5 = FUN_00555140();
  iVar6 = FUN_005b2180();
  FUN_005b0980(0xff,0,0,iVar6 == iVar5 + -1);
  return;
}

