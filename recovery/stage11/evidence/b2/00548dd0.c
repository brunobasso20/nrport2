/* NR2003.exe @ 00548dd0 FUN_00548dd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00548dd0(int param_1,int param_2)

{
  float fVar1;
  float *pfVar2;
  byte bVar3;
  int iVar4;
  int iVar5;
  float *pfVar6;
  undefined local_18 [4];
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  if ((_DAT_006f3e30 < *(float *)(param_2 + 0x58)) &&
     (_DAT_006ea470 < *(float *)(param_2 + 0x58) - *(float *)(param_1 + 0x58))) {
    FUN_00549c00(*(uint *)(param_2 + 4) & 0x7f);
  }
  if ((((_DAT_006f3e30 < *(float *)(param_1 + 0x58)) &&
       (*(float *)(param_2 + 0x58) < _DAT_006e981c !=
        (NAN(*(float *)(param_2 + 0x58)) || NAN(_DAT_006e981c)))) &&
      (iVar4 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), iVar4 != 0)) &&
     (*(int *)(iVar4 + 0x148b) != 0)) {
    *(undefined4 *)(iVar4 + 0x148b) = 0;
  }
  if ((_DAT_006f3e30 < *(float *)(param_2 + 0x58)) &&
     (_DAT_006ea470 < *(float *)(param_2 + 0x58) - *(float *)(param_1 + 0x58))) {
    FUN_00549c00(*(uint *)(param_2 + 4) & 0x7f);
  }
  iVar4 = 0;
  pfVar6 = (float *)(param_1 + 0x10);
  do {
    fVar1 = *(float *)((int)pfVar6 + (param_2 - param_1));
    if ((((NAN(fVar1) || NAN(_DAT_006ea4a0)) != (fVar1 == _DAT_006ea4a0)) &&
        ((NAN(*pfVar6) || NAN(_DAT_006ea4a0)) == (*pfVar6 == _DAT_006ea4a0))) &&
       (iVar5 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), *(int *)(iVar5 + 4) != 0)) {
      pfVar2 = *(float **)(iVar5 + 0x5ae);
      FUN_00548760(local_18,iVar4);
      FUN_005f6d20(&local_c,pfVar2 + 0x16,local_18);
      local_c = *pfVar2 + local_c;
      local_8 = pfVar2[1] + local_8;
      local_4 = pfVar2[2] + local_4;
      FUN_00585e30(&local_c,pfVar2 + 3,*(uint *)(param_2 + 4) & 0x7f,iVar4,0);
    }
    iVar4 = iVar4 + 1;
    pfVar6 = pfVar6 + 1;
  } while (iVar4 < 0xb);
  iVar4 = 0;
  do {
    bVar3 = (char)iVar4 * '\x02';
    if (((((byte)((*(ushort *)(param_2 + 2) & 0xfff) >> (bVar3 & 0x1f)) & 3) == 3) &&
        (((byte)((*(ushort *)(param_1 + 2) & 0xfff) >> (bVar3 & 0x1f)) & 3) != 3)) &&
       (iVar5 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), *(int *)(iVar5 + 4) != 0)) {
      pfVar6 = *(float **)(iVar5 + 0x5ae);
      FUN_00563430(local_18,iVar4);
      FUN_005f6d20(&local_c,pfVar6 + 0x16,local_18);
      local_c = *pfVar6 + local_c;
      local_8 = pfVar6[1] + local_8;
      local_4 = pfVar6[2] + local_4;
      if (local_14 <= _DAT_006ea454) {
        local_14 = local_14 + _DAT_006e9824;
      }
      else {
        local_14 = local_14 - _DAT_006e9824;
      }
      local_10 = local_10 + _DAT_006ee4c8;
      FUN_005f6d20(&local_c,pfVar6 + 0x16,local_18);
      local_c = *pfVar6 + local_c;
      local_8 = pfVar6[1] + local_8;
      local_4 = pfVar6[2] + local_4;
    }
    iVar4 = iVar4 + 1;
  } while (iVar4 < 4);
  return;
}

