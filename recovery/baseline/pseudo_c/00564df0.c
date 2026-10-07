/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00564df0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00564df0(int *param_1,char param_2)

{
  uint uVar1;
  float fVar2;
  float fVar3;
  bool bVar4;
  int iVar5;
  float *pfVar6;
  int iVar7;
  uint uVar8;
  uint uVar9;
  float *pfVar10;
  float10 fVar11;
  float local_84;
  float local_80;
  float local_78;
  float local_74;
  float local_6c;
  float local_68;
  float fStack_60;
  float fStack_5c;
  float fStack_58;
  float *local_54;
  int iStack_50;
  float *pfStack_4c;
  float *local_48;
  undefined1 auStack_44 [12];
  float local_38;
  float local_34;
  float fStack_30;
  float *local_2c;
  float fStack_28;
  float local_24;
  float fStack_20;
  float fStack_1c;
  float fStack_18;
  float fStack_14;
  float afStack_10 [4];
  
  pfVar6 = *(float **)((int)param_1 + 0x5ae);
  local_24 = pfVar6[0x13];
  if (((local_24 == 8.40779e-45) || (local_24 == 9.80909e-45)) ||
     (bVar4 = false, local_24 == 1.12104e-44)) {
    bVar4 = true;
  }
  local_48 = pfVar6 + 3;
  local_2c = pfVar6 + 0x16;
  local_54 = pfVar6;
  FUN_005f6dc0(&local_6c,local_2c,local_48);
  fVar11 = (float10)fpatan((float10)local_68,(float10)ABS(local_6c));
  local_34 = ABS((float)fVar11);
  if (_DAT_006e9824 < local_34) {
    local_34 = 0.2;
  }
  if (-local_6c <= _DAT_006ea62c) {
    param_1[0x56b] = 0;
  }
  else {
    fVar2 = -local_6c - _DAT_006ea62c;
    fVar2 = fVar2 * fVar2 * _DAT_006f5e64;
    param_1[0x56b] = (int)fVar2;
    if (_DAT_006e97d8 < fVar2) {
      param_1[0x56b] = 0x3f800000;
    }
  }
  local_38 = local_6c;
  local_80 = local_6c / (_DAT_006f5d00 * _DAT_006ee584);
  if (*(char *)((int)param_1 + 0x14fb) == '\0') {
    uVar1 = param_1[0x53f];
    uVar8 = uVar1 & 7;
    uVar9 = param_1[0x114] + 1;
    if (uVar8 < 2) {
      uVar8 = 2;
    }
    else if ((int)uVar9 < (int)uVar8) {
      uVar8 = uVar9;
    }
    local_78 = (float)(&DAT_00c53438)[uVar8];
    for (; (local_78 = local_80 * local_78, _DAT_00c08728 < local_78 && ((int)uVar8 < (int)uVar9));
        uVar8 = uVar8 + 1) {
      local_78 = *(float *)(uVar8 * 4 + 0xc5343c);
    }
    if (local_78 < (float)(&DAT_00c533f8)[uVar8]) {
      do {
        if ((int)uVar8 < 3) break;
        local_78 = local_80 * (float)(&DAT_00c53434)[uVar8];
        uVar8 = uVar8 - 1;
      } while (local_78 < (float)(&DAT_00c533f8)[uVar8]);
    }
    if (local_78 < _DAT_006f0e78) {
      local_78 = _DAT_006f0e78;
    }
    param_1[0x542] = (int)local_78;
    param_1[0x543] = 0;
    param_1[0x53f] = (uVar1 ^ uVar8) & 7 ^ uVar1;
    iVar5 = (**(code **)(*param_1 + 0x1c))();
    pfVar6 = (float *)(**(code **)(*param_1 + 0x20))();
    iVar7 = *(int *)((int)param_1 + 0x58a);
    fVar2 = (((*(float *)(iVar7 + 0xa8) * *(float *)(iVar7 + 0xa0) * local_6c * local_6c *
              _DAT_006f5e60) / (_DAT_006f5d1c + *(float *)(iVar7 + 8)) +
             *pfVar6 * *(float *)(iVar5 + 0x58) +
             pfVar6[1] * *(float *)(iVar5 + 100) + *(float *)(iVar5 + 0x70) * pfVar6[2]) *
             (float)(&DAT_00c53418)[param_1[0x53f] & 7] * DAT_00c53440 * _DAT_006f5e5c +
            _DAT_006ef640) * _DAT_006ed6c8;
    if (fVar2 <= _DAT_006ea454) {
      fVar2 = _DAT_006ea454;
    }
    param_1[0x544] = (int)fVar2;
    fVar3 = _DAT_006e97d8;
    fVar2 = (_DAT_006ef640 / _DAT_00c08728) * local_78 + fVar2;
    param_1[0x544] = (int)fVar2;
    if (fVar2 <= fVar3) {
      if (fVar2 < _DAT_006ea510) {
        param_1[0x544] = 0x3c656042;
      }
    }
    else {
      param_1[0x544] = 0x3f800000;
    }
    param_1[0x545] = 0;
    pfVar6 = local_54;
  }
  uVar1 = param_1[0x53f];
  local_84 = local_80;
  if ((char)uVar1 < '\0') {
    local_84 = (float)(&DAT_00c53418)[uVar1 & 7] * (float)param_1[0x542];
    local_38 = _DAT_006f5d00 * _DAT_006ee584 * local_84;
  }
  if ((uVar1 & 0x40) != 0) {
    local_84 = 0.0;
    local_38 = 0.0;
  }
  if ((uVar1 & 0x20) != 0) {
    local_80 = 0.0;
  }
  param_1[0x55e] = (int)local_80;
  param_1[0x55f] = (int)local_80;
  param_1[0x560] = (int)local_84;
  param_1[0x561] = (int)local_84;
  pfVar10 = (float *)(param_1 + 0x55a);
  iStack_50 = (int)param_1 + 0x13b3;
  local_78 = 0.0;
  afStack_10[0] = 10500.0;
  afStack_10[1] = 10500.0;
  afStack_10[2] = 14000.0;
  afStack_10[3] = 14000.0;
  *pfVar10 = DAT_00c074c4 * local_80 + *pfVar10;
  param_1[0x55b] = (int)(DAT_00c074c4 * local_80 + (float)param_1[0x55b]);
  param_1[0x55c] = (int)(DAT_00c074c4 * local_84 + (float)param_1[0x55c]);
  param_1[0x55d] = (int)(DAT_00c074c4 * local_84 + (float)param_1[0x55d]);
  do {
    if (_DAT_006ea454 <= *pfVar10) {
      if (_DAT_006f5e58 < *pfVar10) {
        fVar2 = *pfVar10 - _DAT_006f5e58;
        goto LAB_00565218;
      }
    }
    else {
      fVar2 = *pfVar10 + _DAT_006f5e58;
LAB_00565218:
      *pfVar10 = fVar2;
    }
    if ((_DAT_006f590c < *(float *)((int)param_1 + 0x5aa)) ||
       ((1 < (int)local_78 && ((char)param_1[0x53f] < '\0')))) {
      if ((int)local_78 < 2) {
        if ((*(byte *)(param_1 + 0x53f) & 0x20) == 0) goto LAB_005652ce;
        fStack_30 = 1.2;
        fStack_20 = local_6c;
        fStack_1c = ABS(local_6c);
        local_74 = fStack_1c;
      }
      else if ((*(byte *)(param_1 + 0x53f) & 0xc0) == 0) {
LAB_005652ce:
        fStack_30 = local_34 * _DAT_006f5e54;
        if (_DAT_006f590c < fStack_30) {
          fStack_30 = 1.2;
        }
        fStack_18 = local_68;
        fStack_14 = ABS(local_68);
        local_74 = fStack_14;
      }
      else {
        fStack_30 = 1.2;
        fStack_28 = ABS(local_38 - local_6c);
        local_74 = fStack_28;
        if ((char)param_1[0x53f] < '\0') {
          local_74 = fStack_28 * _DAT_006efe80;
        }
      }
      fVar2 = (pfVar10[-4] - (float)(&DAT_00c533a8)[(int)local_78]) * afStack_10[(int)local_78];
      local_74 = fVar2 * fStack_30 * local_74;
      fVar11 = (float10)FUN_005100e0(local_24);
      local_84 = (float)(fVar11 * (float10)local_74);
      if (param_2 == '\0') {
        fVar3 = *(float *)(&DAT_00c08a20 + *(int *)((int)param_1 + 0x5b2) * 0x32c) * _DAT_006e9804;
        if (_DAT_006e97d8 <
            *(float *)(&DAT_00c08a20 + *(int *)((int)param_1 + 0x5b2) * 0x32c) * _DAT_006e9804) {
          fVar3 = _DAT_006e97d8;
        }
        local_84 = local_84 * fVar3;
        local_74 = fVar3 * local_74;
      }
      fVar3 = fVar2 * local_38 * _DAT_006f5e50;
      FUN_00556e30(param_1,local_78,*(undefined4 *)(&DAT_006f6520 + (int)local_24 * 4),fVar3,
                   local_74,fVar2);
      if (!bVar4) goto LAB_00565247;
      if (param_2 == '\0') {
        local_80 = (fVar3 * _DAT_006f0e78 + local_84) - _DAT_006f5e4c;
        if (_DAT_006ea454 < local_80) {
          local_80 = local_80 * _DAT_006f5e48;
          if (_DAT_006e97d8 < local_80) {
            local_80 = 1.0;
          }
          FUN_00563460(param_1,auStack_44,local_78);
          FUN_005f6d20(&fStack_60,local_2c,auStack_44);
          fStack_60 = *local_54 + fStack_60;
          fStack_5c = local_54[1] + fStack_5c;
          fStack_58 = local_54[2] + fStack_58;
          FUN_00583a20(&fStack_60,local_48,pfVar6[0xf],local_80);
        }
        goto LAB_005654b3;
      }
    }
    else {
      local_84 = 0.0;
LAB_00565247:
      if (param_2 == '\0') {
LAB_005654b3:
        if (local_84 <= _DAT_006f47a0) {
          if (*(char *)((int)local_78 + 0x1483 + (int)param_1) != '\0') {
            pfStack_4c = (float *)(uint)(1 < (int)local_78);
            fVar2 = ((float)(int)pfStack_4c + _DAT_006e9804) * _DAT_006f5d00 - _DAT_006ea4a4;
            FUN_00563460(param_1,auStack_44,local_78);
            FUN_005f6d20(&fStack_60,local_2c,auStack_44);
            pfStack_4c = &fStack_60;
            fStack_60 = *local_54 + fStack_60;
            fStack_5c = local_54[1] + fStack_5c;
            fStack_58 = local_54[2] + fStack_58;
            FUN_0054d580(local_54,fVar2,iStack_50,(int)pfVar10 + -0xf5,&fStack_60,local_48,0,
                         (int)local_78 + *(int *)((int)param_1 + 0x5b2) * 4);
            *(undefined1 *)((int)local_78 + 0x1483 + (int)param_1) = 0;
            pfVar6 = local_54;
          }
        }
        else {
          iVar7 = (**(code **)(*param_1 + 4))();
          if (((byte)((*(ushort *)(iVar7 + 2) & 0xfff) >> (SUB41(local_78,0) * '\x02' & 0x1fU)) & 3)
              == 3) {
            *(undefined1 *)((int)local_78 + 0x1483 + (int)param_1) = 0;
          }
          else {
            iVar7 = FUN_0056ed60(local_78);
            fVar2 = *(float *)(*(int *)(PTR_PTR_00734368 + iVar7 * 4) + 0xc) - _DAT_006ea4a4;
            local_80 = (local_84 - _DAT_006f47a0) * _DAT_006f5e44;
            if (_DAT_006e97d8 < local_80) {
              local_80 = 1.0;
            }
            FUN_00563460(param_1,auStack_44,local_78);
            FUN_005f6d20(&fStack_60,local_2c,auStack_44);
            pfStack_4c = &fStack_60;
            fStack_60 = *local_54 + fStack_60;
            fStack_5c = local_54[1] + fStack_5c;
            fStack_58 = local_54[2] + fStack_58;
            if (*(char *)((int)local_78 + 0x1483 + (int)param_1) == '\0') {
              *(undefined1 *)((int)local_78 + 0x1483 + (int)param_1) = 1;
              FUN_0054d400(pfVar6,fVar2,iStack_50,(int)pfVar10 + -0xf5,&fStack_60,local_48,0);
            }
            else {
              FUN_0054d580(pfVar6,fVar2,iStack_50,(int)pfVar10 + -0xf5,&fStack_60,local_48,local_80,
                           (int)local_78 + *(int *)((int)param_1 + 0x5b2) * 4);
            }
            if (_DAT_006f5e40 < local_84) {
              local_80 = (local_84 - _DAT_006f5e40) * _DAT_006f5e48;
              if (_DAT_006e97d8 < local_80) {
                local_80 = 1.0;
              }
              FUN_00583590(&fStack_60,local_48,pfVar6[0xf],local_80);
            }
          }
        }
      }
    }
    local_78 = (float)((int)local_78 + 1);
    pfVar10 = pfVar10 + 1;
    iStack_50 = iStack_50 + 0x30;
    if (3 < (int)local_78) {
      return;
    }
  } while( true );
}


