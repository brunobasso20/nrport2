/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005a0b60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall FUN_005a0b60(undefined4 *param_1_00,undefined4 param_1,float param_2)

{
  uint uVar1;
  float fVar2;
  bool bVar3;
  int iVar4;
  int iVar5;
  float fVar6;
  undefined4 *puVar7;
  float *pfVar8;
  undefined4 *puVar9;
  float *pfVar10;
  float local_38;
  float local_34;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  if ((*(byte *)(param_1_00 + 0xc9) & 1) != 0) {
    iVar4 = FUN_005ceb90(param_1,param_1_00[0xc5]);
    uVar1 = param_1_00[0xc9];
    if ((uVar1 & 0x20) != 0) {
      iVar5 = FUN_0055ab00();
      if (param_1_00[0x9c] == iVar5) {
        if ((*(byte *)(param_1_00 + 0xc9) & 0x10) == 0) {
          FUN_005f6070(param_1_00 + 0x33,param_1_00 + 1);
          param_1_00[0xc9] = param_1_00[0xc9] | 0x10;
        }
        else {
          puVar7 = param_1_00 + 0x59;
          puVar9 = param_1_00 + 0x33;
          for (iVar5 = 0x26; iVar5 != 0; iVar5 = iVar5 + -1) {
            *puVar9 = *puVar7;
            puVar7 = puVar7 + 1;
            puVar9 = puVar9 + 1;
          }
        }
        if (iVar4 == 0) {
          param_1_00[0x9e] = 0x3f800000;
          puVar9 = param_1_00 + 0x59;
          puVar7 = param_1_00;
          for (iVar4 = 0x26; puVar7 = puVar7 + 1, iVar4 != 0; iVar4 = iVar4 + -1) {
            *puVar9 = *puVar7;
            puVar9 = puVar9 + 1;
          }
          param_1_00[0x9a] = 0;
          return;
        }
        if ((-0x25 < iVar4) && (iVar4 < 0x25)) {
          param_2 = (float)iVar4 * param_2;
          local_38 = (float)param_1_00[1] + param_2 * (float)param_1_00[0x27];
          local_34 = (float)param_1_00[2] + param_2 * (float)param_1_00[0x28];
          local_30 = (float)param_1_00[3] + param_2 * (float)param_1_00[0x29];
          thunk_FUN_005f58d0(param_1_00 + 0x59,&local_38);
          param_2 = param_2 * _DAT_006ea44c;
          local_38 = param_2 * (float)param_1_00[0x2a];
          local_34 = param_2 * (float)param_1_00[0x2b];
          local_30 = param_2 * (float)param_1_00[0x2c];
          FUN_005f7150(&local_10,param_1_00 + 0x20,&local_38);
          local_20 = local_10 + (float)param_1_00[0x20];
          local_1c = local_c + (float)param_1_00[0x21];
          local_18 = local_8 + (float)param_1_00[0x22];
          local_14 = local_4 + (float)param_1_00[0x23];
          FUN_005f6ff0(&local_20);
          FUN_005f5a60(param_1_00 + 0x59,&local_20);
          FUN_005f5ac0(param_1_00 + 0x59,param_1_00 + 0x27,param_1_00 + 0x2a);
          param_1_00[0x9e] = 0x3f800000;
          param_1_00[0x9a] = 0;
          return;
        }
      }
      else {
        bVar3 = inServer();
        if (((bVar3) && (iVar5 = FUN_004f5970(param_1_00[0x9c]), *(char *)(iVar5 + 0x59b) != '\0'))
           && (iVar4 == 0)) {
          if ((param_1_00[0xc9] & 8) != 0) {
            if ((param_1_00[0xc9] & 0x10) == 0) {
              FUN_005f6070(param_1_00 + 0x33,param_1_00 + 0x59);
              param_1_00[0xc9] = param_1_00[0xc9] | 0x10;
            }
            else if (param_1_00[0x9a] == 0) {
              FUN_005f6070(param_1_00 + 0x33,param_1_00 + 0x59);
            }
          }
          uVar1 = param_1_00[0xc9];
          puVar9 = param_1_00 + 0x59;
          puVar7 = param_1_00;
          for (iVar4 = 0x26; puVar7 = puVar7 + 1, iVar4 != 0; iVar4 = iVar4 + -1) {
            *puVar9 = *puVar7;
            puVar9 = puVar9 + 1;
          }
          param_1_00[0xc9] = uVar1 | 8;
          param_1_00[0x9e] = 0x3f800000;
          param_1_00[0x9a] = 0;
          return;
        }
      }
      FUN_0059fa90();
      param_1_00[0x9e] = 0x3f800000;
      param_1_00[0x9a] = 0;
      return;
    }
    if ((-0x25 < iVar4) && (iVar4 < 0x25)) {
      if ((uVar1 & 4) != 0) {
        if ((uVar1 & 8) != 0) {
          iVar5 = FUN_005ceb90(param_1_00[0xc5],param_1_00[0xc6]);
          if ((int)param_1_00[200] < iVar5) {
            param_1_00[199] = 0;
          }
          else {
            param_1_00[199] = param_1_00[199] + 1;
          }
          if ((*(byte *)(param_1_00 + 0xc9) & 0x10) == 0) {
            FUN_005f6070(param_1_00 + 0x33,param_1_00 + 0x9f);
            param_1_00[0xc9] = param_1_00[0xc9] | 0x10;
          }
          else if ((param_1_00[199] == 0) || (param_1_00[200] + iVar4 < (int)param_1_00[199])) {
            FUN_005f6070(param_1_00 + 0x33,param_1_00 + 0x9f);
            (**(code **)*param_1_00)(param_1_00[0x9c]);
          }
          else if (param_1_00[0x9a] == 0) {
            FUN_005f6070(param_1_00 + 0x33,param_1_00 + 0x59);
          }
        }
        if (iVar4 == 0) {
          puVar9 = param_1_00 + 0x9f;
          puVar7 = param_1_00;
          for (iVar5 = 0x26; puVar7 = puVar7 + 1, iVar5 != 0; iVar5 = iVar5 + -1) {
            *puVar9 = *puVar7;
            puVar9 = puVar9 + 1;
          }
        }
        else {
          local_24 = (_DAT_006ea44c * (float)iVar4 + (float)param_1_00[0x31]) * param_2;
          fVar2 = (float)iVar4 * param_2;
          local_2c = local_24 * (float)param_1_00[0x2d];
          local_28 = local_24 * (float)param_1_00[0x2e];
          local_24 = local_24 * (float)param_1_00[0x2f];
          local_38 = (float)param_1_00[1] + ((float)param_1_00[0x27] + local_2c) * fVar2;
          local_34 = (float)param_1_00[2] + ((float)param_1_00[0x28] + local_28) * fVar2;
          local_30 = (float)param_1_00[3] + ((float)param_1_00[0x29] + local_24) * fVar2;
          thunk_FUN_005f58d0(param_1_00 + 0x9f,&local_38);
          fVar2 = fVar2 * _DAT_006ea44c;
          local_38 = fVar2 * (float)param_1_00[0x2a];
          local_34 = fVar2 * (float)param_1_00[0x2b];
          local_30 = fVar2 * (float)param_1_00[0x2c];
          FUN_005f7150(&local_10,param_1_00 + 0x20,&local_38);
          local_20 = local_10 + (float)param_1_00[0x20];
          local_1c = local_c + (float)param_1_00[0x21];
          local_18 = local_8 + (float)param_1_00[0x22];
          local_14 = local_4 + (float)param_1_00[0x23];
          FUN_005f6ff0(&local_20);
          FUN_005f5a60(param_1_00 + 0x9f,&local_20);
        }
        pfVar8 = (float *)(param_1_00 + 0x9f);
        FUN_005f5ac0(pfVar8,param_1_00 + 0x27,param_1_00 + 0x2a);
        local_24 = (float)param_1_00[0x30] -
                   ((float)param_1_00[0xa1] - (float)param_1_00[0xa7]) * (float)param_1_00[0xaa];
        local_2c = local_24 * (float)param_1_00[0xa8];
        local_28 = local_24 * (float)param_1_00[0xa9];
        local_24 = local_24 * (float)param_1_00[0xaa];
        local_38 = *pfVar8 + local_2c;
        local_34 = (float)param_1_00[0xa0] + local_28;
        local_30 = (float)param_1_00[0xa1] + local_24;
        thunk_FUN_005f58d0(pfVar8,&local_38);
        if ((param_1_00[199] == 0) || (param_1_00[200] + iVar4 < (int)param_1_00[199])) {
          pfVar10 = (float *)(param_1_00 + 0x59);
          for (iVar5 = 0x26; iVar5 != 0; iVar5 = iVar5 + -1) {
            *pfVar10 = *pfVar8;
            pfVar8 = pfVar8 + 1;
            pfVar10 = pfVar10 + 1;
          }
        }
        else {
          local_38 = (float)param_1_00[0x33] + param_2 * (float)param_1_00[0x36];
          local_34 = (float)param_1_00[0x34] + param_2 * (float)param_1_00[0x37];
          local_30 = (float)param_1_00[0x35] + param_2 * (float)param_1_00[0x38];
          pfVar8 = (float *)(param_1_00 + 0x59);
          thunk_FUN_005f58d0(pfVar8,&local_38);
          param_2 = param_2 * _DAT_006ea44c;
          local_38 = param_2 * (float)param_1_00[0x56];
          local_34 = param_2 * (float)param_1_00[0x57];
          local_30 = param_2 * (float)param_1_00[0x58];
          FUN_005f7150(&local_10,param_1_00 + 0x52,&local_38);
          local_20 = local_10 + (float)param_1_00[0x52];
          local_1c = local_c + (float)param_1_00[0x53];
          local_18 = local_8 + (float)param_1_00[0x54];
          local_14 = local_4 + (float)param_1_00[0x55];
          FUN_005f6ff0(&local_20);
          FUN_005f5a60(pfVar8,&local_20);
          FUN_005f5ac0(pfVar8,param_1_00 + 0x36,param_1_00 + 0x56);
          local_24 = (float)param_1_00[0x30] -
                     ((float)param_1_00[0x5b] - (float)param_1_00[0x61]) * (float)param_1_00[100];
          local_2c = local_24 * (float)param_1_00[0x62];
          local_28 = local_24 * (float)param_1_00[99];
          local_24 = local_24 * (float)param_1_00[100];
          local_38 = *pfVar8 + local_2c;
          local_34 = (float)param_1_00[0x5a] + local_28;
          local_30 = (float)param_1_00[0x5b] + local_24;
          thunk_FUN_005f58d0(pfVar8,&local_38);
        }
        param_1_00[0xc9] = param_1_00[0xc9] | 8;
      }
      fVar2 = _DAT_006ea44c;
      if (1 < iVar4) {
        param_1_00[0x9a] = 0;
        fVar2 = (float)iVar4 * _DAT_006e9804 * _DAT_006ea44c;
        fVar6 = (float)(0xbe7ffffdU - (int)((float)iVar4 * _DAT_006e9804) >> 1);
        fVar6 = (_DAT_006ea494 - fVar6 * fVar6 * fVar2) * fVar6;
        param_1_00[0x9e] = (_DAT_006ea494 - fVar6 * fVar6 * fVar2) * fVar6;
        return;
      }
      param_1_00[0x9a] = 0;
      param_1_00[0x9e] = fVar2;
      return;
    }
    FUN_0059fa90();
  }
  param_1_00[0x9a] = 0;
  return;
}


