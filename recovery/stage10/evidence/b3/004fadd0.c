/* NR2003.exe @ 004fadd0 FUN_004fadd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004fadd0(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined4 unaff_EBX;
  int iVar6;
  undefined4 unaff_EBP;
  int *piVar7;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  int iVar8;
  int iVar9;
  undefined4 local_170;
  int local_16c;
  int local_168;
  int local_164;
  int aiStack_160 [44];
  int local_b0 [44];
  
  cVar1 = FUN_0056e130();
  if ((cVar1 != '\0') && (iVar2 = getIntCount(), _DAT_00b6e950 <= iVar2)) {
    iVar2 = taskGetRate();
    _DAT_00b6e950 = getIntCount();
    _DAT_00b6e950 = iVar2 * 3 + _DAT_00b6e950;
    iVar2 = 0;
    iVar6 = 0;
    iVar8 = 0;
    iVar9 = 0;
    local_16c = 0;
    local_170 = 0;
    cVar1 = FUN_005c2db0(&local_170);
    if (cVar1 != '\0') {
      do {
        iVar9 = FUN_005c2e10(local_170);
        iVar3 = FUN_005c2d40(local_170);
        if (iVar3 == 2) {
          iVar3 = *(int *)(&DAT_00be11a7 + iVar9 * 0x3ec);
          if ((iVar3 != 0) && (*(char *)(iVar3 + 0x1232) == '\0')) {
            if ((*(byte *)(iVar3 + 0x1234) & 2) != 0) {
              iVar8 = iVar8 + 1;
            }
            if ((*(byte *)(iVar3 + 0x1234) & 1) == 0) {
              if ((&DAT_00be11ae)[iVar9 * 0x3ec] == '\0') {
                aiStack_160[iVar2] = iVar9;
                iVar2 = iVar2 + 1;
              }
            }
            else {
              local_b0[iVar6] = iVar9;
              iVar6 = iVar6 + 1;
            }
          }
        }
        cVar1 = FUN_005c2db0(&local_170);
      } while (cVar1 != '\0');
      iVar9 = iVar6;
      local_16c = iVar2;
      if (1 < iVar8) {
        return;
      }
    }
    local_164 = FUN_0056e170();
    if (local_164 == 0) {
      if (1 < iVar6) {
        return;
      }
    }
    else if ((((0 < local_164) && (iVar6 != iVar8 && -1 < iVar6 - iVar8)) &&
             (iVar8 = FUN_00544e60(), iVar8 == 1)) && (iVar8 = 0, 0 < iVar6)) {
      local_168 = iVar6 + -1;
      piVar7 = local_b0;
      do {
        iVar2 = *piVar7 * 0x3ec;
        if ((*(byte *)(*(int *)(&DAT_00be11a7 + *piVar7 * 0x3ec) + 0x1234) & 2) == 0) {
          iVar4 = taskGetRate();
          iVar4 = iVar4 * local_164;
          iVar3 = *(int *)(&DAT_00be11af + iVar2);
          iVar6 = iVar9;
          iVar5 = getIntCount();
          iVar9 = iVar6;
          if (iVar3 + iVar4 * 0x3c < iVar5) {
            *(byte *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x1234) =
                 *(byte *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x1234) & 0xfe;
            FUN_004f7f20(0,*(undefined4 *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x5b2));
            if (iVar8 < local_168) {
              FUN_006c5390(piVar7,piVar7 + 1,(iVar6 - (iVar8 + 1)) * 4,unaff_EDI,unaff_ESI,unaff_EBP
                           ,unaff_EBX,iVar6);
            }
            iVar6 = iVar6 + -1;
            local_168 = local_168 + -1;
            iVar9 = iVar6;
          }
        }
        iVar8 = iVar8 + 1;
        piVar7 = piVar7 + 1;
        iVar2 = local_16c;
      } while (iVar8 < iVar6);
    }
    if (iVar6 == 1) {
      FUN_004f8dc0();
    }
    else if (1 < iVar6) {
      return;
    }
    if (iVar2 != 0) {
      rndUniform(0);
      iVar9 = FUN_006c5018();
      iVar6 = iVar9;
      do {
        iVar6 = (iVar6 + 1) % iVar2;
        if (iVar6 == iVar9) break;
      } while ((&DAT_00be11ae)[aiStack_160[iVar6] * 0x3ec] != '\0');
      iVar2 = aiStack_160[iVar6] * 0x3ec;
      if ((&DAT_00be11ae)[aiStack_160[iVar6] * 0x3ec] == '\0') {
        *(byte *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x1234) =
             *(byte *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x1234) | 1;
        (&DAT_00be11ae)[iVar2] = 1;
        iVar6 = getIntCount();
        *(int *)(&DAT_00be11af + iVar2) = iVar6;
        FUN_004f7f20(0,*(undefined4 *)(*(int *)(&DAT_00be11a7 + iVar2) + 0x5b2));
      }
    }
  }
  return;
}

