/* NR2003.exe @ 0055b450 FUN_0055b450 */

void FUN_0055b450(void)

{
  uint uVar1;
  char cVar2;
  byte bVar3;
  undefined4 uVar4;
  int iVar5;
  uint *puVar6;
  uint uVar7;
  int iVar8;
  int iVar9;
  undefined4 uVar10;
  uint extraout_ECX;
  uint extraout_ECX_00;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  undefined4 *puVar11;
  uint *puVar12;
  int *piVar13;
  float10 fVar14;
  undefined8 uVar15;
  int local_18c;
  uint uStack_188;
  uint uStack_184;
  undefined4 uStack_180;
  undefined4 uStack_17c;
  ushort uStack_178;
  ushort uStack_176;
  undefined4 uStack_170;
  undefined4 uStack_16c;
  undefined4 uStack_168;
  uint uStack_164;
  undefined4 uStack_160;
  undefined4 uStack_15c;
  undefined auStack_158 [240];
  uint auStack_68 [26];
  
  uVar4 = FUN_005c2d40();
  switch(uVar4) {
  case 0:
  case 1:
  case 3:
  case 4:
    FUN_00567140();
    FUN_0055a4f0();
    return;
  case 2:
    break;
  default:
    goto switchD_0055b46d_caseD_5;
  }
  cVar2 = FUN_00501480();
  if (((cVar2 == '\0') && (iVar5 = FUN_0055a5c0(), iVar5 != 1)) &&
     (iVar5 = FUN_0055a5c0(), iVar5 != 2)) {
    FUN_00501770();
  }
  FUN_00501790();
  if (DAT_00c081a4 != 0) {
    FUN_00501870();
    FUN_005019e0();
    FUN_00501a40();
    DAT_00c081a4 = 0;
  }
  FUN_005b5cb0();
  iVar5 = FUN_0055a5a0();
  if ((iVar5 == 4) && (iVar5 = FUN_0055a5c0(), iVar5 == 3)) {
    FUN_00538b20();
    iVar5 = FUN_00541040();
    if (iVar5 != 0) {
      FUN_00538b20();
      cVar2 = FUN_00541050();
      if (cVar2 != '\0') {
        FUN_00538b20();
        cVar2 = FUN_00541060();
        if (cVar2 != '\0') {
          FUN_00538b20();
          iVar5 = FUN_00541040();
          if (iVar5 == 2) {
            FUN_00501b30();
            FUN_00550a50();
            FUN_005c2fb0();
            return;
          }
          FUN_00538b20();
          iVar5 = FUN_00541040();
          if (iVar5 == 3) {
            FUN_00501b30();
            FUN_00550b30();
            FUN_00524990();
            FUN_00524980();
            FUN_005c2fb0(DAT_00c08194);
            return;
          }
          FUN_00538b20();
          FUN_00541080();
        }
      }
    }
  }
  iVar5 = getBGCount();
  if (((byte)iVar5 & 7) == 7) {
    FUN_00501870(0xd);
    puVar6 = (uint *)FUN_00501a20();
    if (puVar6 != (uint *)0x0) {
      uVar7 = FUN_0055a6a0();
      *puVar6 = (*puVar6 ^ uVar7) & 0xf ^ *puVar6;
      iVar5 = FUN_0055a730();
      *puVar6 = (iVar5 << 4 ^ extraout_ECX) & 0xf0 ^ extraout_ECX;
      thunk_FUN_0055a760();
      iVar5 = FUN_006c5018();
      *puVar6 = *puVar6 & 0xff ^ iVar5 << 8;
    }
    FUN_00501a40();
  }
  uVar15 = CONCAT44(unaff_ESI,unaff_EBP);
  puVar11 = &DAT_00c08138;
  for (iVar5 = 0xc; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar11 = 0;
    puVar11 = puVar11 + 1;
  }
  iVar5 = FUN_0055a6a0();
  local_18c = iVar5;
  iVar8 = FUN_005c2ea0(DAT_00c08194,unaff_EDI,uVar15);
  while (((0 < iVar8 && (iVar8 = FUN_0055a5a0(), iVar8 == 4)) &&
         (iVar8 = FUN_0055a6a0(), iVar8 == iVar5))) {
    FUN_005c2f70(DAT_00c08194,1,&uStack_188);
    uVar4 = FUN_005c3650(&uStack_188);
    switch(uVar4) {
    case 0:
      uVar7 = FUN_0055ab00();
      if ((uStack_184 >> 0x18 & 0x7f) != uVar7) {
        FUN_0055b2f0(&uStack_188);
        *(undefined *)((int)&DAT_00c08138 + (uStack_184 >> 0x18 & 0x7f)) = 1;
      }
      break;
    case 4:
      FUN_0055be50(&uStack_188);
      break;
    case 5:
      FUN_00501870(4);
      FUN_005019e0(0x10,&uStack_188);
      FUN_00501a40();
      FUN_0055be60(&uStack_188);
      break;
    case 6:
      FUN_0055c4b0(&uStack_188);
      break;
    case 0x10:
      FUN_0054b3e0(&uStack_188);
      FUN_00592d60(auStack_68);
      iVar8 = FUN_00562f70(auStack_68[1] & 0x7f);
      puVar6 = auStack_68;
      puVar12 = (uint *)(iVar8 + 0x1493);
      for (iVar9 = 0x1a; iVar9 != 0; iVar9 = iVar9 + -1) {
        *puVar12 = *puVar6;
        puVar6 = puVar6 + 1;
        puVar12 = puVar12 + 1;
      }
      break;
    case 0x20:
      if ((uStack_188 & 0x3c0) == 0) {
        FUN_0055c420(&uStack_188);
      }
      else {
        uStack_168 = uStack_188;
        uStack_160 = uStack_180;
        uStack_164 = uStack_184;
        uStack_15c = uStack_17c;
        FUN_005c2f70(DAT_00c08194,uStack_188 >> 6 & 0xf,auStack_158);
        FUN_0055c420(&uStack_168);
      }
    }
    iVar8 = FUN_005c2ea0(DAT_00c08194);
  }
  iVar5 = 0;
  do {
    if (*(char *)((int)&DAT_00c08138 + iVar5) != '\0') {
      if (iVar5 < 0x30) {
        iVar8 = 0;
        piVar13 = &DAT_00c08a18;
        iVar5 = 0x30;
        do {
          if (*(char *)((int)&DAT_00c08138 + iVar8) == '\0') {
            iVar9 = FUN_0055ab00();
            if (((iVar8 != iVar9) && (iVar9 = FUN_00562f70(iVar8), *(int *)(iVar9 + 4) != 0)) &&
               (iVar9 = (&DAT_00c073d8)[iVar8], (&DAT_00c073d8)[iVar8] = iVar9 + -1, iVar9 + -1 < 1)
               ) {
              FUN_0059fa90();
              *piVar13 = iVar8;
            }
          }
          else {
            (&DAT_00c073d8)[iVar8] = 3;
          }
          iVar8 = iVar8 + 1;
          piVar13 = piVar13 + 0xcb;
          iVar5 = iVar5 + -1;
        } while (iVar5 != 0);
      }
      break;
    }
    iVar5 = iVar5 + 1;
  } while (iVar5 < 0x30);
  iVar5 = FUN_0055a5a0();
  if ((iVar5 == 4) && (iVar5 = FUN_0055a6a0(), iVar5 == local_18c)) {
    iVar5 = FUN_0055a5c0();
    if ((iVar5 == 1) || (iVar5 = FUN_0055a5c0(), iVar5 == 2)) {
      FUN_0055a610();
      FUN_005697e0();
      FUN_00539390();
    }
    else {
      FUN_0055bfd0();
    }
    cVar2 = FUN_0055a780();
    if ((cVar2 != '\0') && (iVar5 = FUN_005c2e40(DAT_00c08194), 0 < iVar5)) {
      FUN_005c3670(&uStack_178,5);
      FUN_0055a6a0();
      bVar3 = FUN_0055a730();
      uStack_176 = (ushort)((extraout_ECX_00 & 0xff ^ (uint)bVar3 << 8) << 4) ^
                   (byte)uStack_176 & 0xf;
      iVar5 = FUN_0055a5c0();
      if (iVar5 == 1) {
        iVar5 = 1;
      }
      else {
        iVar5 = FUN_0055a5c0();
        iVar5 = (-(uint)(iVar5 != 2) & 0xfffffffe) + 2;
      }
      uStack_178 = uStack_178 ^ (byte)((byte)(iVar5 << 6) ^ (byte)uStack_178) & 0xc0;
      uStack_170 = FUN_0055a6f0();
      uStack_16c = 0;
      FUN_005c2ec0(DAT_00c08194,1,&uStack_178);
      FUN_0055a7a0();
    }
    uVar4 = FUN_0055ab00();
    iVar5 = FUN_00562f70(uVar4);
    if (*(int *)(iVar5 + 4) == 0) {
LAB_0055ba56:
      iVar5 = FUN_0055a5c0();
      if ((iVar5 != 1) && (iVar5 = FUN_0055a5c0(), iVar5 != 2)) {
        FUN_005c3670(&uStack_168,0x12);
        cVar2 = FUN_00502460();
        if (cVar2 == '\0') {
          iVar5 = FUN_0055a610();
          if (*(int *)(iVar5 + 0xc) == 0) {
            iVar5 = 0x7f;
          }
          else {
            iVar5 = *(int *)(*(int *)(iVar5 + 0xc) + 0x5b2);
          }
        }
        else {
          iVar5 = FUN_00503470();
          if (*(int *)(iVar5 + 0xc) == 0) {
            iVar5 = 0x7f;
          }
          else {
            iVar5 = FUN_00503470();
            iVar5 = *(int *)(*(int *)(iVar5 + 0xc) + 0x5b2);
          }
        }
        uStack_164 = 0;
        uStack_168 = CONCAT22(uStack_168._2_2_,
                              (ushort)uStack_168 ^
                              ((ushort)(iVar5 << 6) ^ (ushort)uStack_168) & 0x1fc0);
        iVar5 = FUN_005c2e40(DAT_00c08194);
        if (0 < iVar5) {
          FUN_005c2ec0(DAT_00c08194,1,&uStack_168);
        }
      }
    }
    else {
      iVar8 = FUN_005c2d20(DAT_00c08194);
      if (iVar8 != 1) {
        iVar8 = FUN_005c2e40(DAT_00c08194);
        if ((uint)(iVar8 << 4) < 0x40) {
          iVar8 = FUN_005c2e40(DAT_00c08194);
          if (iVar8 < 1) goto LAB_0055ba08;
          FUN_005a2280(&uStack_178);
          puVar11 = (undefined4 *)&uStack_178;
          iVar8 = 1;
        }
        else {
          FUN_005a2040(&uStack_168);
          puVar11 = &uStack_168;
          iVar8 = (uStack_168 >> 6 & 0xf) + 1;
        }
        FUN_005c2ec0(DAT_00c08194,iVar8,puVar11);
      }
LAB_0055ba08:
      FUN_0055b350();
      if (((*(int *)(iVar5 + 4) == 0) ||
          ((cVar2 = FUN_00502460(), cVar2 != '\0' &&
           ((iVar8 = FUN_00503470(), *(int *)(iVar8 + 0xc) != iVar5 ||
            (iVar8 = FUN_00503470(), *(int *)(iVar8 + 4) == 0x11)))))) ||
         ((cVar2 = FUN_00502460(), cVar2 == '\0' &&
          ((iVar8 = FUN_0055a610(), *(int *)(iVar8 + 0xc) != iVar5 || (*(int *)(iVar8 + 4) == 0x11))
          )))) goto LAB_0055ba56;
    }
    iVar5 = DAT_00c0876c;
    uVar4 = FUN_0055ab00();
    iVar8 = FUN_00562f70(uVar4);
    if ((int)(uint)(*(int *)(iVar8 + 4) != 0) < iVar5) {
      FUN_00501870(3);
      iVar5 = DAT_00c08768;
      if (DAT_00c08768 != 0) {
        do {
          if (*(int *)(iVar5 + 4) == 0) {
            iVar8 = 0;
          }
          else {
            iVar8 = *(int *)(iVar5 + 4) + -4;
          }
          FUN_0055b410(iVar5);
          iVar5 = iVar8;
        } while (iVar8 != DAT_00c08768);
      }
      FUN_00501a40();
    }
    FUN_00501b00();
  }
  FUN_00503a80();
  iVar5 = FUN_0055a5a0();
  if ((iVar5 == 4) && (iVar5 = FUN_0055a6a0(), iVar5 == local_18c)) {
    iVar5 = FUN_0055a5c0();
    if ((iVar5 != 3) && (cVar2 = FUN_00574d60(), cVar2 != '\0')) {
      FUN_00501b30();
      FUN_00574d00();
      FUN_005c2fb0(DAT_00c08194);
    }
    FUN_0050e280();
  }
  if ((DAT_00c08199 == '\0') && (DAT_00c08198 != '\0')) {
    FUN_00538b20(&DAT_00c070f8);
    FUN_0053fd40();
    uVar4 = FUN_0055a6f0(&DAT_00c07170);
    uVar10 = FUN_0055a6a0();
    FUN_005a4100(uVar10,uVar4);
    FUN_00501b30();
    local_18c = 1;
    FUN_005f5890(&DAT_00e0b7e4);
    uVar7 = *DAT_00e0b7d8;
    uVar1 = *DAT_00e0b7e0;
    FUN_005f58a0();
    bgRequestFGAction(FUN_00572a10,&local_18c,(void *)(uVar7 ^ uVar1));
    DAT_00c08199 = '\x01';
  }
  FUN_00538b20();
  cVar2 = FUN_00540380();
  if (cVar2 == '\0') {
    FUN_00538b20();
    cVar2 = FUN_00540370();
    if (cVar2 != '\0') {
      FUN_00538b20();
      FUN_00540390();
    }
  }
  FUN_00538b20();
  cVar2 = FUN_00540520();
  if (cVar2 == '\0') {
    FUN_00538b20();
    cVar2 = FUN_00540510();
    if (cVar2 != '\0') {
      FUN_00538b20();
      FUN_00540550();
    }
  }
  if ((DAT_00c0819b == '\0') && (DAT_00c0819a != '\0')) {
    FUN_00538b20();
    iVar5 = FUN_005402b0();
    if (iVar5 == 0) {
      FUN_00619640(&uStack_168,0x20,local_18c,0);
      FUN_0055c800(4,&uStack_168);
      FUN_005cfeb8();
      iVar5 = FUN_005c2d20();
      if (iVar5 == 1) {
        iVar5 = FUN_005c38b0(DAT_00c08194,1,0,0);
        if (iVar5 == 0) goto LAB_0055bd3d;
      }
      else {
        FUN_005c2910();
      }
    }
    DAT_00c0819b = '\x01';
  }
LAB_0055bd3d:
  cVar2 = FUN_005c2cf0();
  if (((cVar2 != '\0') && (DAT_00c081dc = DAT_00c081dc + -1, DAT_00c081dc < 0)) &&
     (cVar2 = FUN_0057af40(), cVar2 != '\0')) {
    fVar14 = (float10)FUN_005c32d0();
    FUN_006c4f81(&uStack_168,s____d__5_3f_0074de88,0x464,(double)(fVar14 + fVar14));
    FUN_0055c800(1,&uStack_168);
    FUN_005cfeb8();
    fVar14 = (float10)FUN_005c3320();
    FUN_006c4f81(&uStack_170,s____d__5_3f_0074de94,0x465,(double)fVar14);
    FUN_0055c800(1,&uStack_170);
    FUN_005cfeb8();
    DAT_00c081dc = taskGetRate();
  }
switchD_0055b46d_caseD_5:
  return;
}

