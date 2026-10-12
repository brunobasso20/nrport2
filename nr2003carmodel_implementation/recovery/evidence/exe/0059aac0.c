/* NR2003.exe @ 0059aac0 FUN_0059aac0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0059aac0(undefined4 *param_1)

{
  char cVar1;
  byte bVar2;
  ushort uVar3;
  int iVar4;
  int iVar5;
  char *pcVar6;
  ushort *puVar7;
  int iVar8;
  undefined4 extraout_ECX;
  undefined4 *puVar9;
  int iVar10;
  float10 fVar11;
  float10 fVar12;
  float10 fVar13;
  undefined8 uVar14;
  undefined8 uVar15;
  int local_a8;
  undefined local_9c [16];
  undefined auStack_8c [32];
  int local_6c;
  undefined local_68 [24];
  char acStack_50 [80];
  
  FUN_0059aa50();
  iVar5 = FUN_0056a9a0((int)param_1 + 0x89,(int)param_1 + 0x132,
                       *(undefined4 *)((int)param_1 + 0x1db),param_1[0x17],param_1[0xc]);
  if (iVar5 == 0) {
    return;
  }
  FUN_00579820();
  FUN_00579860(*(undefined4 *)((int)param_1 + 0x61));
  FUN_00587d20();
  iVar4 = *(int *)((int)param_1 + 0x75);
  iVar10 = *(int *)((int)param_1 + 0x79);
  iVar5 = *(int *)((int)param_1 + 0x71);
  if (DAT_00da3841 == '\0') goto LAB_0059b1e3;
  FUN_0059a960(local_9c,*param_1,param_1[1],0);
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  FUN_00465b80(200,0,0,0xff);
  FUN_0056b960();
  pcVar6 = (char *)FUN_0056b960();
  iVar8 = -1;
  do {
    if (iVar8 == 0) break;
    iVar8 = iVar8 + -1;
    cVar1 = *pcVar6;
    pcVar6 = pcVar6 + 1;
  } while (cVar1 != '\0');
  FUN_005d4340();
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  if (_DAT_006ea4b0 < *(double *)(param_1 + 4)) {
    FUN_0059a960(local_9c,param_1[4],param_1[5],1);
    FUN_00465b80(200,0,0,0xff);
    FUN_005d4340();
  }
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  if (_DAT_006ea4b0 < *(double *)(param_1 + 6)) {
    FUN_0059a960(local_9c,param_1[6],param_1[7],1);
    FUN_00465b80(200,0,0,0xff);
    FUN_005d4340();
  }
  iVar10 = iVar10 / 2;
  local_6c = iVar10;
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  if (_DAT_006ea4b0 < *(double *)(param_1 + 8)) {
    FUN_0059a960(local_9c,param_1[8],param_1[9],1);
    iVar5 = iVar10 + 8 + iVar5;
    uVar15 = CONCAT44(1,extraout_ECX);
    FUN_00465b80(200,0,0,0xff);
    uVar14 = CONCAT44(local_9c,iVar4 + 1);
    FUN_005d4340();
    iVar5 = FUN_00574370(param_1[10],iVar5,uVar14,uVar15);
    if (iVar5 == 0) {
      FUN_006c4f81(local_68,&DAT_0075121c);
    }
    else {
      pcVar6 = (char *)FUN_00574370();
      iVar5 = FUN_00574370(param_1[10]);
      FUN_006c4f81(local_68,s__c__s_00751214,(int)*pcVar6,iVar5 + 0x10);
    }
    FUN_00465b80(200,0,0,0xff);
    FUN_005d4340();
  }
  if (*(double *)(param_1 + 2) <= _DAT_006f6e08) {
    FUN_0059a960(local_9c,param_1[2],param_1[3],0);
  }
  else {
    FUN_006c4f81(local_9c,s_all_day_00751220);
  }
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  if ((int)param_1[0xc] < 0) {
LAB_0059aefd:
    uVar3 = *(ushort *)((int)param_1 + 0x4b1);
    if ((uVar3 & 4) == 0) {
      if ((uVar3 & 0x10) == 0) {
        if ((uVar3 & 1) != 0) {
          FUN_006c4f81(auStack_8c,s___CHECK__f___00751260,(double)*(float *)((int)param_1 + 0x4b3));
          goto LAB_0059afda;
        }
        if ((*(byte *)((int)param_1 + 0x4b2) & 1) == 0) {
          if ((uVar3 & 0x200) == 0) {
            if ((uVar3 & 8) == 0) {
              if ((uVar3 & 2) != 0) {
                FUN_006c4f81(auStack_8c,s___WHITE__f___00751294,
                             (double)*(float *)((int)param_1 + 0x4b3));
                goto LAB_0059afda;
              }
              if ((uVar3 & 0x400) != 0) {
                uVar14 = CONCAT44(s___ST_UP___007512a4,auStack_8c);
                goto LAB_0059afd2;
              }
              pcVar6 = s_<no_flag>_007512b0;
            }
            else {
              pcVar6 = s___YELL____00751288;
            }
            uVar14 = CONCAT44(pcVar6,auStack_8c);
          }
          else {
            uVar14 = CONCAT44(s___YELL1___0075127c,auStack_8c);
          }
        }
        else {
          uVar14 = CONCAT44(s___YELL____00751270,auStack_8c);
        }
      }
      else {
        uVar14 = CONCAT44(s___RED___00751254,auStack_8c);
      }
LAB_0059afd2:
      FUN_006c4f81(uVar14);
    }
    else {
      FUN_006c4f81(auStack_8c,s___GREEN__f___00751244,(double)*(float *)((int)param_1 + 0x4b3));
    }
  }
  else {
    bVar2 = *(byte *)(param_1[0xc] + 0x5a7 + (int)param_1);
    if ((bVar2 & 2) == 0) {
      if ((bVar2 & 1) == 0) goto LAB_0059aefd;
      FUN_006c4f81();
    }
    else {
      FUN_006c4f81();
    }
  }
LAB_0059afda:
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  FUN_006c4f81();
  FUN_00465b80(200,0,0,0xff);
  FUN_005d4340();
  puVar7 = (ushort *)((int)param_1 + 0x4ed);
  iVar5 = 0xc;
  do {
    if ((*(byte *)((int)puVar7 + 1) & 1) != 0) {
      pcVar6 = s_YELLOW_007512c4;
      goto LAB_0059b0cf;
    }
    uVar3 = *puVar7;
    if ((uVar3 & 0x10) == 0) {
      if ((uVar3 & 8) == 0) {
        if ((uVar3 & 2) == 0) {
          if ((uVar3 & 4) == 0) {
            if ((uVar3 & 0x20) == 0) {
              pcVar6 = s_no_007512f4;
              goto LAB_0059b0cf;
            }
            uVar14 = CONCAT44(s_Blue_007512ec,auStack_8c);
          }
          else {
            uVar14 = CONCAT44(s_Green_007512e4,auStack_8c);
          }
        }
        else {
          pcVar6 = s_White_007512dc;
LAB_0059b0cf:
          uVar14 = CONCAT44(pcVar6,auStack_8c);
        }
      }
      else {
        uVar14 = CONCAT44(s_Yellow_007512d4,auStack_8c);
      }
    }
    else {
      uVar14 = CONCAT44(s_Red_007512cc,auStack_8c);
    }
    FUN_006c4f81(uVar14);
    FUN_00465b80(200,0,0,0xff);
    FUN_005d4340();
    puVar7 = puVar7 + 5;
    iVar5 = iVar5 + -1;
  } while (iVar5 != 0);
  if (((-1 < (int)param_1[0xc]) && (iVar5 = FUN_00562f70(), iVar5 != 0)) &&
     (iVar5 = *(int *)(iVar5 + 0x5ae), iVar5 != 0)) {
    fVar11 = (float10)FUN_00516e1a();
    fVar11 = (float10)FUN_00516e1a((double)(fVar11 * (float10)_DAT_006f6e04));
    fVar12 = (float10)fpatan((float10)*(float *)(iVar5 + 100),(float10)*(float *)(iVar5 + 0x58));
    fVar13 = (float10)fpatan((float10)*(float *)(iVar5 + 0x38),(float10)*(float *)(iVar5 + 0x34));
    FUN_006c4f81(acStack_50,s____2f____2f____2f____2f_m_____3f_007512fc,
                 (double)*(float *)(iVar5 + 0x3c),(double)*(float *)(iVar5 + 0x40),
                 (double)(fVar12 - fVar13),(double)fVar11);
    FUN_00465b80(200,0,0,0xff);
    iVar5 = -1;
    pcVar6 = acStack_50;
    do {
      if (iVar5 == 0) break;
      iVar5 = iVar5 + -1;
      cVar1 = *pcVar6;
      pcVar6 = pcVar6 + 1;
    } while (cVar1 != '\0');
    FUN_005d4340();
  }
LAB_0059b1e3:
  puVar9 = param_1 + 0x178;
  local_a8 = 3;
  do {
    if (puVar9 != (undefined4 *)0x0) {
      FUN_00446e70();
      FUN_005d4340();
    }
    puVar9 = puVar9 + 0x14;
    local_a8 = local_a8 + -1;
  } while (local_a8 != 0);
  if (*(char *)((int)param_1 + 0x5df) != '\0') {
    FUN_006c4f81(local_9c,s__5_3f_00751320,(double)*(float *)((int)param_1 + 0x5db));
    FUN_00465b80(200,200,100,0xff);
    FUN_005d4340();
  }
  return;
}

