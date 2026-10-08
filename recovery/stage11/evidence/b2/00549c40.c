/* NR2003.exe @ 00549c40 FUN_00549c40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00549c40(void)

{
  int **ppiVar1;
  float fVar2;
  int **ppiVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  int iVar7;
  undefined4 uVar8;
  uint uVar9;
  int iVar10;
  undefined4 *puVar11;
  float10 fVar12;
  float local_80;
  int *local_7c;
  int local_78;
  int local_74;
  float local_70;
  undefined4 local_6c;
  uint local_68;
  float local_64;
  float local_60;
  float local_5c;
  undefined4 local_58;
  undefined4 local_54;
  undefined4 local_50;
  undefined4 local_1c;
  undefined4 local_4;
  
  FUN_0054a330();
  iVar10 = 0;
  if (0 < DAT_00bf39ec) {
    do {
      FUN_00549c00((&DAT_00bef710)[iVar10]);
      iVar10 = iVar10 + 1;
    } while (iVar10 < DAT_00bf39ec);
  }
  DAT_00bf39ec = 0;
  ppiVar3 = DAT_00bf39f0;
  do {
    if (ppiVar3 == (int **)0x0) {
      DAT_00bf39f0 = (int **)0x0;
      puVar11 = &DAT_00bf0940;
      for (iVar10 = 0x20; iVar10 != 0; iVar10 = iVar10 + -1) {
        *puVar11 = 0;
        puVar11 = puVar11 + 1;
      }
      return;
    }
    local_7c = ppiVar3[3];
    local_78 = (*ppiVar3)[1];
    local_68 = (uint)ppiVar3[2] & 0xff000000;
    uVar9 = (uint)ppiVar3[2] & 0xffffff;
    DAT_00bf39f0 = ppiVar3;
    if (local_78 != 0) {
      iVar10 = *(int *)(local_78 + 0x1a4);
      local_74 = iVar10;
      iVar6 = FUN_00562f70(iVar10);
      iVar7 = FUN_0055a610();
      if (iVar6 == *(int *)(iVar7 + 0xc)) {
        local_6c = DAT_0074e90c;
      }
      else {
        local_6c = 0;
      }
      if (*(int *)(iVar6 + 4) != 0) {
        if (ppiVar3[0x15] != (int *)0x0) {
          iVar10 = ppiVar3[0x15][0x69];
          local_70 = (float)FUN_00562f70(iVar10);
          uVar8 = FUN_00592db0(local_70);
          local_80 = 0.0;
          cVar5 = FUN_00549290(iVar10,uVar8,ppiVar3,&local_80,&DAT_00bef380 + iVar10);
          fVar2 = local_80;
          iVar10 = local_74;
          if (cVar5 != '\0') {
            if (local_80 != 0.0) {
              iVar10 = getBGCount();
              *(int *)((int)local_70 + 0x1487) = iVar10 + (int)fVar2;
            }
            FUN_00592dc0(local_70,1);
            iVar10 = local_74;
          }
        }
        uVar8 = FUN_00592db0(iVar6);
        local_80 = 0.0;
        cVar5 = FUN_00549290(iVar10,uVar8,ppiVar3,&local_80,&DAT_00bef380 + iVar10);
        fVar2 = local_80;
        if (cVar5 != '\0') {
          if (local_80 != 0.0) {
            iVar10 = getBGCount();
            *(int *)(iVar6 + 0x1487) = iVar10 + (int)fVar2;
          }
          FUN_00592dc0(iVar6,1);
        }
        ppiVar1 = ppiVar3 + 0xd;
        local_70 = SQRT((float)ppiVar3[0xf] * (float)ppiVar3[0xf] +
                        (float)ppiVar3[0xe] * (float)ppiVar3[0xe] +
                        (float)ppiVar3[0xd] * (float)ppiVar3[0xd]);
        fVar12 = (float10)FUN_00579e50(local_7c);
        fVar12 = (float10)FUN_00579f00((float)(fVar12 * (float10)(float)ppiVar3[1]));
        local_80 = (float)fVar12;
        if (((float10)_DAT_006ef6c8 < fVar12) && (_DAT_006f5858 < local_70)) {
          FUN_00557650(uVar9,local_7c,ppiVar3 + 4,local_80,local_6c);
        }
        local_80 = _DAT_00bef700 * (float)ppiVar3[1];
        if (local_70 <= _DAT_006f5858) {
          if (uVar9 != 0x11) goto LAB_00549f25;
        }
        else if (uVar9 == 0x11) {
          if (_DAT_006f5868 < local_80) {
            local_80 = (local_80 - _DAT_006f5868) * _DAT_006f5864;
            if (_DAT_006e97d8 < local_80) {
              local_80 = 1.0;
            }
            FUN_005862c0(ppiVar3 + 4,ppiVar1,local_74,0,local_80);
            if ((ppiVar3[0x15] != (int *)0x0) && (local_7c == (int *)0x11)) {
              local_64 = -(float)*ppiVar1;
              local_60 = -(float)ppiVar3[0xe];
              local_5c = -(float)ppiVar3[0xf];
              FUN_005862c0(ppiVar3 + 4,&local_64,ppiVar3[0x15][0x69],0,local_80);
            }
          }
        }
        else {
LAB_00549f25:
          if ((local_68 & 0x2000000) == 0) goto switchD_00549f4b_caseD_3;
        }
        switch(local_7c) {
        case (int *)0x1:
        case (int *)0x2:
        case (int *)0x4:
          if (_DAT_006ea514 < (float)ppiVar3[0x14]) {
            local_70 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f5860;
            if (_DAT_006e97d8 < local_70) {
              local_70 = 1.0;
            }
            local_4 = *(undefined4 *)(local_78 + 0xec);
            FUN_005f58d0(&local_58,ppiVar3 + 4);
            fVar4 = local_70;
            FUN_00583250(&local_58,ppiVar1,local_1c,local_70);
            fVar2 = *(float *)(iVar6 + 0x124b) + _DAT_006ea508;
            *(float *)(iVar6 + 0x124b) = fVar2;
            if (_DAT_006e97d8 < fVar2) {
              *(undefined4 *)(iVar6 + 0x124b) = 0x3f800000;
            }
            fVar2 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f585c;
            *(float *)(iVar6 + 0x119e) = fVar2;
            if (*(float *)(iVar6 + 0x124b) < fVar2) {
              *(undefined4 *)(iVar6 + 0x119e) = *(undefined4 *)(iVar6 + 0x124b);
            }
            *(undefined4 *)(iVar6 + 0x12ff) = local_58;
            *(undefined4 *)(iVar6 + 0x1303) = local_54;
            *(undefined4 *)(iVar6 + 0x1307) = local_50;
            FUN_0054a2a0(iVar6,fVar4);
          }
          break;
        case (int *)0x5:
        case (int *)0x6:
        case (int *)0x7:
        case (int *)0x8:
          if (_DAT_006ea478 < (float)ppiVar3[0x14]) {
            local_70 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f5860;
            if (_DAT_006e97d8 < local_70) {
              local_70 = 1.0;
            }
            local_4 = *(undefined4 *)(local_78 + 0xec);
            FUN_005f58d0(&local_58,ppiVar3 + 4);
            FUN_00583490(&local_58,ppiVar1,local_1c,local_70);
          }
          break;
        case (int *)0xa:
        case (int *)0x11:
          if (_DAT_006ea628 < (float)ppiVar3[0x14]) {
            local_70 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f5860;
            if (_DAT_006e97d8 < local_70) {
              local_70 = 1.0;
            }
            local_4 = *(undefined4 *)(local_78 + 0xec);
            FUN_005f58d0(&local_58,ppiVar3 + 4);
            fVar4 = local_70;
            FUN_00583250(&local_58,ppiVar1,local_1c,local_70);
            fVar2 = *(float *)(iVar6 + 0x124b) + _DAT_006ea508;
            *(float *)(iVar6 + 0x124b) = fVar2;
            if (_DAT_006e97d8 < fVar2) {
              *(undefined4 *)(iVar6 + 0x124b) = 0x3f800000;
            }
            fVar2 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f585c;
            *(float *)(iVar6 + 0x119a) = fVar2;
            if (*(float *)(iVar6 + 0x124b) < fVar2) {
              *(undefined4 *)(iVar6 + 0x119a) = *(undefined4 *)(iVar6 + 0x124b);
            }
            *(undefined4 *)(iVar6 + 0x12a7) = local_58;
            *(undefined4 *)(iVar6 + 0x12ab) = local_54;
            *(undefined4 *)(iVar6 + 0x12af) = local_50;
            FUN_0054a2a0(iVar6,fVar4);
          }
          break;
        case (int *)0xd:
          if (_DAT_006ea628 < (float)ppiVar3[0x14]) {
            local_70 = (float)ppiVar3[0x14] * (float)ppiVar3[1] * _DAT_006f5860;
            if (_DAT_006e9824 < local_70) {
              local_70 = 0.2;
            }
            local_4 = *(undefined4 *)(local_78 + 0xec);
            FUN_005f58d0(&local_58,ppiVar3 + 4);
            fVar2 = local_70;
            FUN_00583250(&local_58,ppiVar1,local_1c,local_70);
            FUN_0054a2a0(iVar6,fVar2);
          }
        }
      }
    }
switchD_00549f4b_caseD_3:
    DAT_00bf39f0 = (int **)DAT_00bf39f0[0x17];
    *ppiVar3 = (int *)DAT_00bf09c0;
    DAT_00bf09c0 = ppiVar3;
    ppiVar3 = DAT_00bf39f0;
  } while( true );
}

