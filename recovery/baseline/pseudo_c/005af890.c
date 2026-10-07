/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005af890 */

void FUN_005af890(void)

{
  byte bVar1;
  byte *pbVar2;
  byte *pbVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  uint uVar7;
  byte *pbVar8;
  char cVar9;
  byte *pbVar10;
  char *pcVar11;
  bool bVar12;
  int local_98;
  int local_94;
  char *pcStack_90;
  undefined1 *local_8c;
  int iStack_88;
  char *pcStack_84;
  undefined1 auStack_80 [128];
  
  if (DAT_00e7d100 != '\0') {
    local_8c = &DAT_00e7d100;
    local_98 = 0;
    local_94 = 0;
    pbVar2 = (byte *)FUN_005cff54(&DAT_006f71f0,&DAT_00e7d100,&local_8c);
    if (pbVar2 != (byte *)0x0) {
      pbVar8 = &DAT_00e7d1a0;
      do {
        pbVar10 = &DAT_006f71ec;
        pbVar3 = pbVar2;
        do {
          bVar1 = *pbVar3;
          bVar12 = bVar1 < *pbVar10;
          if (bVar1 != *pbVar10) {
LAB_005af90a:
            iVar4 = (1 - (uint)bVar12) - (uint)(bVar12 != 0);
            goto LAB_005af90f;
          }
          if (bVar1 == 0) break;
          bVar1 = pbVar3[1];
          bVar12 = bVar1 < pbVar10[1];
          if (bVar1 != pbVar10[1]) goto LAB_005af90a;
          pbVar3 = pbVar3 + 2;
          pbVar10 = pbVar10 + 2;
        } while (bVar1 != 0);
        iVar4 = 0;
LAB_005af90f:
        if (iVar4 == 0) goto LAB_005af9be;
        iVar4 = FUN_006c4ac9(pbVar2,&DAT_007521ac,&pcStack_90);
        if (iVar4 == 1) {
          if (local_94 == 4) {
            FUN_005aef10(s___too_many_float_agrs_007521b0);
            return;
          }
          (&DAT_00e7d0dc)[local_94] = pcStack_90;
          local_94 = local_94 + 1;
          pbVar3 = pbVar8;
        }
        else {
          uVar7 = 0xffffffff;
          pbVar3 = pbVar2;
          do {
            if (uVar7 == 0) break;
            uVar7 = uVar7 - 1;
            bVar1 = *pbVar3;
            pbVar3 = pbVar3 + 1;
          } while (bVar1 != 0);
          if (0x26 < ~uVar7 - 1) {
            FUN_005aef10(s___arg_too_long_007521e0);
            return;
          }
          if (pbVar8 == &DAT_00e7d240) {
            FUN_005aef10(s___too_many_string_agrs_007521c8);
            return;
          }
          local_98 = local_98 + 1;
          pbVar3 = pbVar8 + 0x28;
          do {
            bVar1 = *pbVar2;
            pbVar2 = pbVar2 + 1;
            *pbVar8 = bVar1;
            pbVar8 = pbVar8 + 1;
          } while (bVar1 != 0);
        }
        pbVar2 = (byte *)FUN_005cff54(&DAT_006f71f0,local_8c,&local_8c);
        pbVar8 = pbVar3;
      } while (pbVar2 != (byte *)0x0);
    }
    DAT_00e7d0d0 = local_98 + -1;
    DAT_00e7d198 = local_94;
LAB_005af9be:
    if (-1 < local_98) {
      local_98 = -0x80;
      pcStack_90 = (char *)0x0;
      local_94 = 0;
      do {
        pcVar11 = (&PTR_DAT_00751e9c)[local_94 * 2];
        iVar4 = 0;
        cVar9 = *pcVar11;
        if (cVar9 == '\0') {
          DAT_00751fe0 = local_94;
          return;
        }
        iStack_88 = (int)&DAT_00e7d1a0 - (int)pcVar11;
        pcStack_84 = pcVar11;
        while( true ) {
          iVar5 = FUN_006c6254((int)pcVar11[iStack_88]);
          iVar6 = FUN_006c6254((int)cVar9);
          if (iVar6 != iVar5) break;
          cVar9 = pcVar11[1];
          iVar4 = iVar4 + 1;
          pcVar11 = pcVar11 + 1;
          if (cVar9 == '\0') {
            DAT_00751fe0 = local_94;
            return;
          }
        }
        if (cVar9 == '\0') {
          DAT_00751fe0 = local_94;
          return;
        }
        if (local_98 < iVar4) {
          pcStack_90 = pcStack_84;
          local_98 = iVar4;
        }
        pcVar11 = pcStack_90;
        local_94 = local_94 + 1;
      } while (local_94 < 6);
      if (local_98 < 4) {
        FUN_006c4f81(auStack_80,s_____s__not_found_00751fe8,&DAT_00e7d1a0);
      }
      else {
        FUN_006c4f81(auStack_80,s___subst___s__for___s__00751ffc,&DAT_00e7d1a0,pcStack_90);
        FUN_006c4b00(&DAT_00e7d1a0,pcVar11,0x28);
      }
      FUN_005aef10(auStack_80);
      DAT_00751fe0 = 0xffffff80;
    }
  }
  return;
}


