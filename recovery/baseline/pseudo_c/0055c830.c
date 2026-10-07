/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055c830 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055c830(void)

{
  int iVar1;
  undefined4 *puVar2;
  char cVar3;
  bool bVar4;
  undefined4 uVar5;
  int iVar6;
  char *pcVar7;
  char *pcVar8;
  float10 fVar9;
  bool bStack_c9;
  int iStack_c8;
  char local_c4 [65];
  float fStack_83;
  undefined1 auStack_7f [43];
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
  
  cVar3 = FUN_005b0540();
  if (cVar3 == '\0') {
    return;
  }
  FUN_005b05c0();
  cVar3 = FUN_005b0900(0x80);
  if (cVar3 != '\0') {
    pcVar7 = local_c4;
    for (iVar6 = 0x29; iVar6 != 0; iVar6 = iVar6 + -1) {
      pcVar7[0] = '\0';
      pcVar7[1] = '\0';
      pcVar7[2] = '\0';
      pcVar7[3] = '\0';
      pcVar7 = pcVar7 + 4;
    }
    *pcVar7 = '\0';
    bVar4 = inServer();
    if (bVar4) {
      iVar6 = FUN_00544e60();
      if ((iVar6 == 3) ||
         ((iVar6 = FUN_00544e60(), iVar6 == 2 && (iVar6 = FUN_00544e90(), 0 < iVar6)))) {
        local_c4[0] = '\x01';
        iVar6 = FUN_00544bf0();
      }
      else {
        local_c4[0] = '\0';
        iVar6 = FUN_00544bf0();
      }
    }
    else {
      local_c4[0] = DAT_00c081a2;
      iVar6 = FUN_0055a680();
    }
    if (iVar6 != 0) {
      FUN_006c4b00(local_c4 + 1,iVar6,0x3f);
      FUN_005469c0(auStack_7f,0x40,*(undefined4 *)(iVar6 + 0x67),iVar6 + 0x6b);
      FUN_00546c20((int)&uStack_40 + 1,0x20,iVar6 + 0x44);
    }
    if (local_c4[0] != '\0') {
      fVar9 = (float10)FUN_00516e1a();
      fStack_83 = (float)fVar9;
    }
    iVar6 = 0xa5;
    bVar4 = true;
    pcVar7 = &DAT_00c064d0;
    pcVar8 = local_c4;
    do {
      if (iVar6 == 0) break;
      iVar6 = iVar6 + -1;
      bVar4 = *pcVar7 == *pcVar8;
      pcVar7 = pcVar7 + 1;
      pcVar8 = pcVar8 + 1;
    } while (bVar4);
    if ((!bVar4) && (cVar3 = FUN_005b0980(0x80,0xa5,local_c4,1), cVar3 != '\0')) {
      pcVar7 = local_c4;
      pcVar8 = &DAT_00c064d0;
      for (iVar6 = 0x29; iVar6 != 0; iVar6 = iVar6 + -1) {
        *(undefined4 *)pcVar8 = *(undefined4 *)pcVar7;
        pcVar7 = pcVar7 + 4;
        pcVar8 = pcVar8 + 4;
      }
      *pcVar8 = *pcVar7;
    }
  }
  cVar3 = FUN_005b0900(0x81);
  if (((cVar3 != '\0') && (bStack_c9 = (bool)FUN_00551880(), (bool)DAT_00c077d2 != bStack_c9)) &&
     (cVar3 = FUN_005b0980(0x81,1,&bStack_c9,1), cVar3 != '\0')) {
    DAT_00c077d2 = bStack_c9;
  }
  cVar3 = FUN_005b0900(0x82);
  if (cVar3 != '\0') {
    bVar4 = inServer();
    if (bVar4) {
      iVar6 = FUN_00544e60();
      bStack_c9 = iVar6 == 3;
    }
    else {
      iVar6 = FUN_0055a5a0();
      bStack_c9 = iVar6 == 5;
    }
    if (((bool)DAT_00c07558 != bStack_c9) &&
       (cVar3 = FUN_005b0980(0x82,1,&bStack_c9,1), cVar3 != '\0')) {
      DAT_00c07558 = bStack_c9;
    }
  }
  if ((DAT_00bf6f34 != '\0') && (cVar3 = FUN_005b0900(0x83), cVar3 != '\0')) {
    iVar6 = 0xc;
    puVar2 = (undefined4 *)&stack0xffffff2c;
    do {
      fVar9 = (float10)FUN_00557e40(iVar6 + -0xc);
      puVar2[4] = (float)fVar9;
      uVar5 = FUN_00557ee0(iVar6 + -8);
      puVar2[7] = uVar5;
      uVar5 = FUN_00557ee0(iVar6);
      puVar2[8] = uVar5;
      fVar9 = (float10)FUN_00557e40(iVar6 + 0x14);
      puVar2[6] = (float)fVar9;
      iStack_c8 = FUN_00557ee0(iVar6 + 8);
      puVar2[5] = (float)iStack_c8;
      iStack_c8 = FUN_00557ee0(iVar6 + 0x52);
      puVar2[10] = (float)iStack_c8;
      fVar9 = (float10)FUN_00557e40(iVar6 + 0x18);
      puVar2[9] = (float)fVar9;
      iVar1 = iVar6 + -0xb;
      iVar6 = iVar6 + 1;
      puVar2 = puVar2 + 7;
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
    iVar6 = FUN_00557ee0(0x65);
    if (iVar6 < 1) {
      fStack_28 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x68);
      fStack_28 = (float)fVar9;
    }
    if (iVar6 < 2) {
      fStack_24 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x69);
      fStack_24 = (float)fVar9;
    }
    if (iVar6 < 3) {
      fStack_20 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6a);
      fStack_20 = (float)fVar9;
    }
    if (iVar6 < 4) {
      fStack_1c = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6b);
      fStack_1c = (float)fVar9;
    }
    if (iVar6 < 5) {
      fStack_18 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6c);
      fStack_18 = (float)fVar9;
    }
    if (iVar6 < 6) {
      fStack_14 = 0.0;
    }
    else {
      fVar9 = (float10)FUN_00557e40(0x6d);
      fStack_14 = (float)fVar9;
    }
    cVar3 = FUN_005b0980(0x83,0xc4,local_c4,1);
    if (cVar3 != '\0') {
      DAT_00bf6f34 = '\0';
    }
  }
  if (((DAT_00c081a1 != '\0') && (cVar3 = FUN_005b0900(), cVar3 != '\0')) &&
     (cVar3 = FUN_005b0980(0x84,0x28), cVar3 != '\0')) {
    DAT_00c081a1 = '\0';
  }
  return;
}


