/* NR2003.exe @ 00549860 FUN_00549860 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00549860(undefined4 param_1,int param_2,undefined4 param_3,int param_4,float *param_5,
                 int param_6,float param_7,undefined *param_8,char *param_9)

{
  float fVar1;
  int iVar2;
  float fVar3;
  bool bVar4;
  char cVar5;
  undefined4 uVar6;
  int iVar7;
  undefined local_38 [12];
  float local_2c;
  float local_28;
  float local_24;
  undefined4 local_20;
  int local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  undefined4 local_8;
  undefined4 local_4;
  
  param_6 = param_6 * 0x20;
  if (*(float *)(&DAT_006f550c + param_6) < param_7) {
    iVar2 = *(int *)(&DAT_006f5504 + param_6);
    fVar1 = *(float *)(param_2 + 0x10 + iVar2 * 4);
    if ((NAN(fVar1) || NAN(_DAT_006ea4a0)) == (fVar1 == _DAT_006ea4a0)) {
      fVar3 = (param_7 - *(float *)(&DAT_006f550c + param_6)) *
              (_DAT_006e97d8 / *(float *)(&DAT_006f5510 + param_6));
      if (*(int *)(&DAT_006f5508 + param_6) == -1) {
        param_7 = fVar3 + fVar1;
        if ((_DAT_006e97d8 < param_7) &&
           ((param_7 <= *(float *)(&DAT_006f5514 + param_6) || (param_7 = 2.0, iVar2 == 6)))) {
          param_7 = 1.0;
        }
      }
      else {
        iVar7 = *(int *)(param_4 + 0x28 + *(int *)(&DAT_006f5508 + param_6) * 4);
        param_7 = *(float *)(iVar7 + 0x3c);
        if (*(float *)(&DAT_006f5514 + param_6) < param_7 + fVar3) {
          *(undefined4 *)(iVar7 + 0x3c) = 0x3f800000;
          fVar1 = _DAT_006e97d8 - *(float *)(iVar7 + 0x38) * *(float *)(iVar7 + 0x20);
          *(float *)(iVar7 + 0x24) = fVar1 * *(float *)(iVar7 + 0x14);
          *(float *)(iVar7 + 0x28) = fVar1 * *(float *)(iVar7 + 0x18);
          *(float *)(iVar7 + 0x2c) = fVar1 * *(float *)(iVar7 + 0x1c);
          FUN_00577cb0();
          param_7 = 2.0;
        }
      }
      fVar1 = *(float *)(param_2 + 0x10 + iVar2 * 4);
      if (((NAN(param_7) || NAN(fVar1)) == (param_7 == fVar1)) &&
         (*(float *)(param_2 + 0x10 + iVar2 * 4) < param_7)) {
        bVar4 = inBackground();
        if ((bVar4) && (*param_9 == '\0')) {
          uVar6 = FUN_00562f70(param_1);
          FUN_00592dc0(uVar6,1);
          *param_9 = '\x01';
        }
        FUN_0054b6c0(iVar2,param_7);
        cVar5 = FUN_00548740(iVar2);
        if ((cVar5 != '\0') && ((NAN(param_7) || NAN(_DAT_006ea4a0)) != (param_7 == _DAT_006ea4a0)))
        {
          bVar4 = inBackground();
          if (bVar4) {
            iVar7 = FUN_00562f70(param_1);
            if (*(int *)(iVar7 + 0x596) != 0) {
              local_18 = param_7;
              local_4 = param_3;
              local_20 = param_1;
              local_1c = iVar2;
              FUN_00548760(local_38,iVar2);
              FUN_005f6d20(&local_2c,param_5 + 0x16,local_38);
              local_14 = *param_5 + local_2c;
              local_10 = param_5[1] + local_28;
              local_c = param_5[2] + local_24;
              local_8 = 0;
              FUN_00549ab0(&local_20);
            }
          }
        }
        *param_8 = 1;
      }
    }
  }
  return;
}

