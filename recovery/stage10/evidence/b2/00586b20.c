/* NR2003.exe @ 00586b20 FUN_00586b20 */

void FUN_00586b20(void)

{
  char *pcVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int *piVar6;
  undefined4 unaff_EBX;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  uint uVar7;
  undefined4 unaff_EDI;
  bool bVar8;
  undefined *puVar9;
  char in_stack_fffffd88;
  int iStack_274;
  int iStack_270;
  undefined4 uStack_26c;
  int iStack_268;
  uint uStack_264;
  int iStack_260;
  undefined4 uStack_25c;
  undefined4 uStack_258;
  undefined4 uStack_254;
  undefined *puStack_250;
  undefined4 uStack_24c;
  int iStack_248;
  uint uStack_244;
  undefined4 uStack_240;
  undefined4 uStack_23c;
  int iStack_238;
  int iStack_234;
  int iStack_230;
  undefined auStack_22c [4];
  undefined auStack_228 [4];
  undefined auStack_224 [4];
  undefined auStack_220 [32];
  undefined auStack_200 [256];
  undefined auStack_100 [256];
  
  if (DAT_00d7cb5c == '\0') {
    FUN_005cff0c();
    FUN_00586e70(s_shared_0075013c);
    iVar2 = FUN_005cfd0e(&uStack_26c,s_trkembm_inf_00750144);
    if (iVar2 == 1) {
      iStack_268 = -1;
      iVar2 = 0;
      iVar3 = FUN_005cfe22(uStack_26c);
      iStack_270 = iVar3;
      if (iVar3 != 0) {
        iVar4 = FUN_005cfce4(&uStack_244,iVar3);
        uVar7 = -(uint)(iVar4 != 0) & uStack_244;
        uStack_264 = uVar7;
        if (uVar7 != 0) {
          iVar4 = FUN_005cfdb6(uStack_26c,uVar7,iVar3);
          if (iVar4 != 0) {
LAB_00586be9:
            iVar4 = iVar2;
            if (iVar2 < iVar3) {
              while ((iVar2 = FUN_006c4d21((int)*(char *)(uVar7 + iVar4),unaff_EBP,unaff_EDI,
                                           unaff_ESI,unaff_EBX,in_stack_fffffd88), iVar2 == 0 &&
                     (iVar2 = func_0x006c4cf9(), iVar2 == 0))) {
                iVar4 = iVar4 + 1;
                if (iVar3 <= iVar4) goto LAB_00586bb3;
              }
              iVar2 = iVar4;
              if (iVar4 < iVar3) {
                do {
                  if ((*(char *)(uVar7 + iVar2) == '\n') || (*(char *)(uVar7 + iVar2) == '\r'))
                  goto joined_r0x00586c30;
                  iVar2 = iVar2 + 1;
                } while (iVar2 < iVar3);
                goto LAB_00586c42;
              }
            }
          }
LAB_00586bb3:
          FUN_005cfccc(uVar7);
        }
      }
      FUN_005cfd08(uStack_26c);
    }
    FUN_005cff06();
    DAT_00d7cb5c = '\x01';
  }
  return;
joined_r0x00586c30:
  for (; (iVar2 < iVar3 &&
         ((*(char *)(uVar7 + iVar2) == '\n' || (*(char *)(uVar7 + iVar2) == '\r'))));
      iVar2 = iVar2 + 1) {
  }
LAB_00586c42:
  pcVar1 = (char *)(iVar4 + uVar7);
  if (pcVar1 == (char *)0x0) goto LAB_00586bb3;
  if (*pcVar1 != ';') {
    if (*pcVar1 == '#') {
      FUN_006c4ac9(pcVar1,s__s__d_00750150,auStack_220,&iStack_268);
    }
    else if ((((iStack_268 == 0) &&
              (iVar5 = FUN_006c4ac9(pcVar1,s__s__d__s__d__f__f__f__d_00750158,auStack_200,
                                    &iStack_260,auStack_100,&iStack_238,&uStack_24c,&uStack_240,
                                    &uStack_254,&iStack_234), iVar4 = iStack_234, iVar5 == 8)) &&
             (-1 < iStack_234)) && (iStack_234 < 0x10)) {
      uStack_25c = uStack_240;
      uStack_258 = uStack_254;
      bVar8 = iStack_238 != 0;
      in_stack_fffffd88 = iStack_260 != 0;
      uStack_23c = uStack_24c;
      iVar5 = FUN_005cfce4(&iStack_230,0x215);
      iVar3 = iStack_230;
      if ((iVar5 == 0) || (uVar7 = uStack_264, iStack_230 == 0)) {
        iStack_274 = 0;
      }
      else {
        *(undefined4 *)(iStack_230 + 0x200) = uStack_23c;
        *(undefined4 *)(iStack_230 + 0x204) = uStack_25c;
        *(undefined4 *)(iStack_230 + 0x208) = uStack_258;
        *(int *)(iStack_230 + 0x20c) = iVar4;
        *(bool *)(iStack_230 + 0x210) = bVar8;
        *(undefined4 *)(iStack_230 + 0x211) = 0;
        FUN_006c4b00(iStack_230,auStack_200,0xff);
        FUN_006c4b00(iVar3 + 0x100,auStack_100,0xff);
        iStack_274 = iVar3;
        uVar7 = uStack_264;
      }
      if (in_stack_fffffd88 == '\0') {
        FUN_005873a0(&iStack_248,&iStack_274);
        piVar6 = (int *)FUN_00587390(auStack_228);
        if (iStack_248 != *piVar6) {
          iVar3 = iStack_270;
          if (iStack_274 != 0) {
            FUN_005872d0(1);
            iVar3 = iStack_270;
          }
          goto LAB_00586be9;
        }
        puVar9 = auStack_224;
      }
      else {
        FUN_005873a0(&puStack_250,&iStack_274);
        iVar4 = iStack_274;
        if (puStack_250 != &DAT_00d7cb38) {
          iVar3 = iStack_270;
          if (iStack_274 != 0) {
            if (*(int *)(iStack_274 + 0x211) != 0) {
              FUN_005d3e60(*(int *)(iStack_274 + 0x211));
            }
            FUN_005cfccc(iVar4);
            iVar3 = iStack_270;
          }
          goto LAB_00586be9;
        }
        puVar9 = auStack_22c;
      }
      FUN_00587410(puVar9,&iStack_274);
      iVar3 = iStack_270;
    }
  }
  goto LAB_00586be9;
}

