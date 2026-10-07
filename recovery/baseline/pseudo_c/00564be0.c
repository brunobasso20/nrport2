/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00564be0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00564be0(int param_1,float *param_2)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  int iVar5;
  float *pfVar6;
  undefined4 *puVar7;
  float10 fVar8;
  float local_84;
  float local_80;
  float local_7c;
  float *local_78;
  float *local_74;
  float local_70 [2];
  float local_68;
  float local_64;
  float local_60;
  float local_5c;
  undefined1 local_58 [48];
  float local_28;
  float local_4;
  
  fVar8 = (float10)FUN_0051700a(param_2[0xf]);
  local_74 = (float *)(float)((float10)_DAT_00c11fec * fVar8);
  local_78 = (float *)(int)ROUND((float)local_74);
  if ((*(float *)(*(int *)(PTR_DAT_00749378 + 4) + 0x14 + (int)local_78 * 0x1c) < param_2[0x10]) &&
     (param_2[0x10] < *(float *)(*(int *)(PTR_DAT_00749378 + 8) + 0x14 + (int)local_78 * 0x1c))) {
    local_84 = param_2[6] - *param_2;
    local_80 = param_2[7] - param_2[1];
    local_7c = param_2[0xc] - param_2[2];
    FUN_005f6dc0(&local_84,param_2 + 0x16,&local_84);
    FUN_005f6dc0(&local_64,param_2 + 0x16,param_2 + 9);
    pfVar6 = (float *)&DAT_00c533d0;
    iVar5 = 0;
    do {
      fVar1 = local_64 * (local_84 - pfVar6[-2]) +
              local_5c * (local_7c - *pfVar6) + local_60 * (local_80 - pfVar6[-1]);
      if (*(float *)((int)&DAT_00c533a8 + iVar5) <= fVar1) {
        if (*(float *)((int)&DAT_00c533b8 + iVar5) < fVar1) {
          fVar1 = *(float *)((int)&DAT_00c533b8 + iVar5);
        }
      }
      else {
        fVar1 = *(float *)((int)&DAT_00c533a8 + iVar5);
      }
      *(float *)(iVar5 + param_1) = fVar1;
      pfVar6 = pfVar6 + 3;
      iVar5 = iVar5 + 4;
    } while ((int)pfVar6 < 0xc53400);
    return;
  }
  local_78 = local_70;
  local_74 = local_70;
  puVar7 = &DAT_00c533c8;
  iVar5 = 0;
  do {
    FUN_005f6d20(local_70,param_2 + 0x16,puVar7);
    fVar1 = local_78[1];
    fVar2 = param_2[1];
    fVar3 = local_78[2];
    fVar4 = param_2[2];
    *local_74 = *local_78 + *param_2;
    local_74[1] = fVar1 + fVar2;
    local_74[2] = fVar3 + fVar4;
    local_4 = param_2[0x15];
    FUN_005f58d0(local_58,local_70);
    fVar1 = local_28 - local_68;
    if (*(float *)((int)&DAT_00c533a8 + iVar5) <= fVar1) {
      if (*(float *)((int)&DAT_00c533b8 + iVar5) < fVar1) {
        fVar1 = *(float *)((int)&DAT_00c533b8 + iVar5);
      }
    }
    else {
      fVar1 = *(float *)((int)&DAT_00c533a8 + iVar5);
    }
    puVar7 = puVar7 + 3;
    *(float *)(iVar5 + param_1) = fVar1;
    iVar5 = iVar5 + 4;
  } while ((int)puVar7 < 0xc533f8);
  return;
}


