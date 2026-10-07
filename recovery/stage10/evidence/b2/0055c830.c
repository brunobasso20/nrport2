/* NR2003.exe @ 0055c830 FUN_0055c830 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055c830(void)

{
  int iVar1;
  char cVar2;
  bool bVar3;
  undefined4 uVar4;
  int iVar5;
  char *pcVar6;
  undefined4 *puVar7;
  undefined4 *puVar8;
  float10 fVar9;
  bool bStack_c9;
  int iStack_c8;
  undefined4 local_c4;
  float fStack_83;
  undefined auStack_7f [43];
  float fStack_54;
  float fStack_50;
  float fStack_4c;
  float fStack_48;
  float fStack_44;
  undefined4 uStack_40;
  float fStack_3c;
  float fStack_38;
  float fStack_34;
  float fStack_30;
  float fStack_2c;
  float fStack_28;
  float fStack_24;
  float fStack_20;
  float fStack_1c;
  float fStack_18;
  float fStack_14;
  float fStack_10;
  float fStack_c;
  float fStack_8;
  float fStack_4;
  
  cVar2 = FUN_005b0540();
  if (cVar2 == '\0') {
    return;
  }
  FUN_005b05c0();
  cVar2 = FUN_005b0900(0x80);
  if (cVar2 != '\0') {
    puVar7 = &local_c4;
    for (iVar5 = 0x29; iVar5 != 0; iVar5 = iVar5 + -1) {
      *puVar7 = 0;
      puVar7 = puVar7 + 1;
    }
    *(undefined *)puVar7 = 0;
    bVar3 = inServer();
    if (bVar3) {
      iVar5 = FUN_00544e60();
      if ((iVar5 == 3) ||
         ((iVar5 = FUN_00544e60(), iVar5 == 2 && (iVar5 = FUN_00544e90(), 0 < iVar5)))) {
        local_c4._0_1_ = '\x01';
        iVar5 = FUN_00544bf0();
      }
      else {
        local_c4._0_1_ = '\0';
        iVar5 = FUN_00544bf0();
      }
    }
    else {
      local_c4._0_1_ = DAT_00c081a2;
      iVar5 = FUN_0055a680();
    }
    if (iVar5 != 0) {
      FUN_006c4b00((int)&local_c4 + 1,iVar5,0x3f);
      FUN_005469c0(auStack_7f,0x40,*(undefined4 *)(iVar5 + 0x67),iVar5 + 0x6b);
      FUN_00546c20((int)&uStack_40 + 1,0x20,iVar5 + 0x44);
    }
    if ((char)local_c4 != '\0') {
      fVar9 = (float10)FUN_00516e1a();
      fStack_83 = (float)fVar9;
    }
    iVar5 = 0xa5;
    bVar3 = true;
    pcVar6 = &DAT_00c064d0;
    puVar7 = &local_c4;
    do {
      if (iVar5 == 0) break;
      iVar5 = iVar5 + -1;
      bVar3 = *pcVar6 == *(char *)puVar7;
      pcVar6 = pcVar6 + 1;
      puVar7 = (undefined4 *)((int)puVar7 + 1);
    } while (bVar3);
    if ((!bVar3) && (cVar2 = FUN_005b0980(0x80,0xa5,&local_c4,1), cVar2 != '\0')) {
      puVar7 = &local_c4;
      puVar8 = (undefined4 *)&DAT_00c064d0;
      for (iVar5 = 0x29; iVar5 != 0; iVar5 = iVar5 + -1) {
        *puVar8 = *puVar7;
        puVar7 = puVar7 + 1;
        puVar8 = puVar8 + 1;
      }
      *(undefined *)puVar8 = *(undefined *)puVar7;
    }
  }
  cVar2 = FUN_005b0900(0x81);
  if (((cVar2 != '\0') && (bStack_c9 = (bool)FUN_00551880(), (bool)DAT_00c077d2 != bStack_c9)) &&
     (cVar2 = FUN_005b0980(0x81,1,&bStack_c9,1), cVar2 != '\0')) {
    DAT_00c077d2 = bStack_c9;
  }
  cVar2 = FUN_005b0900(0x82);
  if (cVar2 != '\0') {
    bVar3 = inServer();
    if (bVar3) {
      iVar5 = FUN_00544e60();
      bStack_c9 = iVar5 == 3;
    }
    else {
      iVar5 = FUN_0055a5a0();
      bStack_c9 = iVar5 == 5;
    }
    if (((bool)DAT_00c07558 != bStack_c9) &&
       (cVar2 = FUN_005b0980(0x82,1,&bStack_c9,1), cVar2 != '\0')) {
      DAT_00c07558 = bStack_c9;
    }
  }
  if ((DAT_00bf6f34 != '\0') && (cVar2 = FUN_005b0900(0x83), cVar2 != '\0')) {
    iVar5 = 0xc;
    puVar7 = (undefined4 *)&stack0xffffff2c;
    do {
      fVar9 = (float10)FUN_00557e40(iVar5 + -0xc);
      puVar7[4] = (float)fVar9;
      uVar4 = FUN_00557ee0(iVar5 + -8);
      puVar7[7] = uVar4;
      uVar4 = FUN_00557ee0(iVar5);
      puVar7[8] = uVar4;
      fVar9 = (float10)FUN_00557e40(iVar5 + 0x14);
      puVar7[6] = (float)fVar9;
      iStack_c8 = FUN_00557ee0(iVar5 + 8);
      puVar7[5] = (float)iStack_c8;
      iStack_c8 = FUN_00557ee0(iVar5 + 0x52);
      puVar7[10] = (float)iStack_c8;
      fVar9 = (float10)FUN_00557e40(iVar5 + 0x18);
      puVar7[9] = (float)fVar9;
      iVar1 = iVar5 + -0xb;
      iVar5 = iVar5 + 1;
      puVar7 = puVar7 + 7;
    } while (iVar1 < 4);
    fVar9 = (float10)FUN_00557e40(99);
    fStack_50 = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(0x43);
    fStack_48 = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(0x44);
    fStack_44 = (float)fVar9;
    iStack_c8 = FUN_00557ee0(0x3b);
    uStack_40 = (float)iStack_c8 * _DAT_006ea4a4;
    fVar9 = (float10)FUN_00557e40(0x29);
    fStack_4c = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(100);
    fStack_3c = (float)fVar9;
    iStack_c8 = FUN_00557ee0(0x3d);
    fStack_2c = (float)iStack_c8;
    fVar9 = (float10)FUN_00557e40(0x2d);
    fStack_34 = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(0x2e);
    fStack_30 = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(0x2a);
    fStack_38 = (float)fVar9;
    iStack_c8 = FUN_00557ee0(0x28);
    fStack_c = (float)iStack_c8;
    iStack_c8 = FUN_00557ee0(0x40);
    fStack_54 = (float)iStack_c8;
    iStack_c8 = FUN_00557ee0(0x30);
    fStack_8 = (float)iStack_c8;
    fVar9 = (float10)FUN_00557e40(0x5c);
    fStack_4 = (float)fVar9;
    fVar9 = (float10)FUN_00557e40(0x6e);
    fStack_10 = (float)fVar9;
    iVar5 = FUN_00557ee0(0x65);
    if (iVar5 < 1) {
      fStack_28 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x68);
      fStack_28 = (float)fVar9;
    }
    if (iVar5 < 2) {
      fStack_24 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x69);
      fStack_24 = (float)fVar9;
    }
    if (iVar5 < 3) {
      fStack_20 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6a);
      fStack_20 = (float)fVar9;
    }
    if (iVar5 < 4) {
      fStack_1c = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6b);
      fStack_1c = (float)fVar9;
    }
    if (iVar5 < 5) {
      fStack_18 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6c);
      fStack_18 = (float)fVar9;
    }
    if (iVar5 < 6) {
      fStack_14 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6d);
      fStack_14 = (float)fVar9;
    }
    cVar2 = FUN_005b0980(0x83,0xc4,&local_c4,1);
    if (cVar2 != '\0') {
      DAT_00bf6f34 = '\0';
    }
  }
  if (((DAT_00c081a1 != '\0') && (cVar2 = FUN_005b0900(), cVar2 != '\0')) &&
     (cVar2 = FUN_005b0980(0x84,0x28), cVar2 != '\0')) {
    DAT_00c081a1 = '\0';
  }
  return;
}

