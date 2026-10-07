/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00548dd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00548dd0(int param_1,int param_2)

{
  float *pfVar1;
  byte bVar2;
  int iVar3;
  int iVar4;
  float *pfVar5;
  undefined1 local_18 [4];
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  if ((_DAT_006f3e30 < *(float *)(param_2 + 0x58)) &&
     (_DAT_006ea470 < *(float *)(param_2 + 0x58) - *(float *)(param_1 + 0x58))) {
    FUN_00549c00(*(uint *)(param_2 + 4) & 0x7f);
  }
  if ((((_DAT_006f3e30 < *(float *)(param_1 + 0x58)) && (*(float *)(param_2 + 0x58) < _DAT_006e981c)
       ) && (iVar3 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), iVar3 != 0)) &&
     (*(int *)(iVar3 + 0x148b) != 0)) {
    *(undefined4 *)(iVar3 + 0x148b) = 0;
  }
  if ((_DAT_006f3e30 < *(float *)(param_2 + 0x58)) &&
     (_DAT_006ea470 < *(float *)(param_2 + 0x58) - *(float *)(param_1 + 0x58))) {
    FUN_00549c00(*(uint *)(param_2 + 4) & 0x7f);
  }
  iVar3 = 0;
  pfVar5 = (float *)(param_1 + 0x10);
  do {
    if (((*(float *)((int)pfVar5 + (param_2 - param_1)) == _DAT_006ea4a0) &&
        (*pfVar5 != _DAT_006ea4a0)) &&
       (iVar4 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), *(int *)(iVar4 + 4) != 0)) {
      pfVar1 = *(float **)(iVar4 + 0x5ae);
      FUN_00548760(local_18,iVar3);
      FUN_005f6d20(&local_c,pfVar1 + 0x16,local_18);
      local_c = *pfVar1 + local_c;
      local_8 = pfVar1[1] + local_8;
      local_4 = pfVar1[2] + local_4;
      FUN_00585e30(&local_c,pfVar1 + 3,*(uint *)(param_2 + 4) & 0x7f,iVar3,0);
    }
    iVar3 = iVar3 + 1;
    pfVar5 = pfVar5 + 1;
  } while (iVar3 < 0xb);
  iVar3 = 0;
  do {
    bVar2 = (char)iVar3 * '\x02';
    if (((((byte)((*(ushort *)(param_2 + 2) & 0xfff) >> (bVar2 & 0x1f)) & 3) == 3) &&
        (((byte)((*(ushort *)(param_1 + 2) & 0xfff) >> (bVar2 & 0x1f)) & 3) != 3)) &&
       (iVar4 = FUN_00562f70(*(uint *)(param_2 + 4) & 0x7f), *(int *)(iVar4 + 4) != 0)) {
      pfVar5 = *(float **)(iVar4 + 0x5ae);
      FUN_00563430(local_18,iVar3);
      FUN_005f6d20(&local_c,pfVar5 + 0x16,local_18);
      local_c = *pfVar5 + local_c;
      local_8 = pfVar5[1] + local_8;
      local_4 = pfVar5[2] + local_4;
      if (local_14 <= _DAT_006ea454) {
        local_14 = local_14 + _DAT_006e9824;
      }
      else {
        local_14 = local_14 - _DAT_006e9824;
      }
      local_10 = local_10 + _DAT_006ee4c8;
      FUN_005f6d20(&local_c,pfVar5 + 0x16,local_18);
      local_c = *pfVar5 + local_c;
      local_8 = pfVar5[1] + local_8;
      local_4 = pfVar5[2] + local_4;
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 < 4);
  return;
}


