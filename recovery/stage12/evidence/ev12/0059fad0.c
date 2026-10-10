/* NR2003.exe @ 0059fad0 FUN_0059fad0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall
FUN_0059fad0(int param_1_00,int param_1,float *param_2,float param_3,undefined4 param_4)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float *pfVar5;
  float local_48;
  float local_44;
  float local_40;
  float local_3c;
  float local_38;
  float local_34;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_c;
  float local_8;
  
  pfVar5 = param_2;
  fVar3 = (float)param_1;
  param_3 = param_3 / fVar3;
  local_48 = (*param_2 - *(float *)(param_1_00 + 4)) * param_3;
  local_44 = (param_2[1] - *(float *)(param_1_00 + 8)) * param_3;
  local_40 = (param_2[2] - *(float *)(param_1_00 + 0xc)) * param_3;
  if ((char)param_4 != '\0') {
    local_c = local_48;
    local_8 = local_44;
    if ((*(byte *)(param_1_00 + 0x324) & 4) != 0) {
      fVar4 = (SQRT(local_48 * local_48 + local_44 * local_44 + local_40 * local_40) * _DAT_006f6ea4
              ) / (_DAT_00b8f258 * _DAT_006f6ea0);
      local_c = fVar4 * *(float *)(param_1_00 + 0xb4) + local_48;
      local_8 = fVar4 * *(float *)(param_1_00 + 0xb8) + local_44;
    }
    FUN_005f5d60(&param_2,&param_1,&param_4,&local_c,param_2 + 9);
    FUN_005f5a90(pfVar5,param_2,param_1,param_4);
  }
  if ((*(byte *)(param_1_00 + 0x324) & 2) == 0) {
    fVar3 = fVar3 * _DAT_006ea44c;
    *(undefined4 *)(param_1_00 + 0xa8) = 0;
    *(undefined4 *)(param_1_00 + 0xac) = 0;
    *(undefined4 *)(param_1_00 + 0xb0) = 0;
    *(float *)(param_1_00 + 0xc4) = fVar3;
  }
  else {
    local_24 = pfVar5[0x1f] - *(float *)(param_1_00 + 0x80);
    pfVar1 = pfVar5 + 0x1f;
    local_20 = pfVar5[0x20] - *(float *)(param_1_00 + 0x84);
    local_1c = pfVar5[0x21] - *(float *)(param_1_00 + 0x88);
    fVar4 = pfVar5[0x22] - *(float *)(param_1_00 + 0x8c);
    if (_DAT_006e97d8 <=
        fVar4 * fVar4 + local_24 * local_24 + local_20 * local_20 + local_1c * local_1c) {
      local_24 = *pfVar1 + *(float *)(param_1_00 + 0x80);
      local_20 = pfVar5[0x20] + *(float *)(param_1_00 + 0x84);
      local_1c = pfVar5[0x21] + *(float *)(param_1_00 + 0x88);
      fVar4 = *(float *)(param_1_00 + 0x8c) + pfVar5[0x22];
    }
    fVar2 = pfVar5[0x22];
    local_34 = param_3 + param_3;
    local_3c = local_34 *
               ((local_24 * fVar2 - fVar4 * *pfVar1) -
               (local_1c * pfVar5[0x20] - local_20 * pfVar5[0x21]));
    local_38 = ((local_20 * fVar2 - fVar4 * pfVar5[0x20]) -
               (local_24 * pfVar5[0x21] - local_1c * *pfVar1)) * local_34;
    local_34 = ((local_1c * fVar2 - fVar4 * pfVar5[0x21]) -
               (local_20 * *pfVar1 - local_24 * pfVar5[0x20])) * local_34;
    local_48 = local_48 * _DAT_006ea44c + *(float *)(param_1_00 + 0x9c) * _DAT_006ea44c;
    local_44 = local_44 * _DAT_006ea44c + *(float *)(param_1_00 + 0xa0) * _DAT_006ea44c;
    local_40 = local_40 * _DAT_006ea44c + *(float *)(param_1_00 + 0xa4) * _DAT_006ea44c;
    *(float *)(param_1_00 + 0xc4) =
         *(float *)(param_1_00 + 0xc4) * _DAT_006ea44c + fVar3 * _DAT_006ed6c8;
    local_18 = (local_48 - *(float *)(param_1_00 + 0x9c)) * param_3;
    local_14 = (local_44 - *(float *)(param_1_00 + 0xa0)) * param_3;
    param_3 = (local_40 - *(float *)(param_1_00 + 0xa4)) * param_3;
    if ((*(byte *)(param_1_00 + 0x324) & 4) != 0) {
      local_18 = local_18 * _DAT_006ea44c + *(float *)(param_1_00 + 0xb4) * _DAT_006ea44c;
      local_14 = local_14 * _DAT_006ea44c + *(float *)(param_1_00 + 0xb8) * _DAT_006ea44c;
      param_3 = param_3 * _DAT_006ea44c + *(float *)(param_1_00 + 0xbc) * _DAT_006ea44c;
      local_3c = local_3c * _DAT_006ea44c + *(float *)(param_1_00 + 0xa8) * _DAT_006ea44c;
      local_38 = local_38 * _DAT_006ea44c + *(float *)(param_1_00 + 0xac) * _DAT_006ea44c;
      local_34 = local_34 * _DAT_006ea44c + *(float *)(param_1_00 + 0xb0) * _DAT_006ea44c;
    }
    *(float *)(param_1_00 + 0xbc) = param_3;
    *(float *)(param_1_00 + 0xb4) = local_18;
    *(float *)(param_1_00 + 0xb8) = local_14;
    *(float *)(param_1_00 + 0xa8) = local_3c;
    *(float *)(param_1_00 + 0xac) = local_38;
    *(float *)(param_1_00 + 0xb0) = local_34;
    *(uint *)(param_1_00 + 0x324) = *(uint *)(param_1_00 + 0x324) | 4;
  }
  *(float *)(param_1_00 + 0x9c) = local_48;
  *(float *)(param_1_00 + 0xa0) = local_44;
  *(float *)(param_1_00 + 0xa4) = local_40;
  *(uint *)(param_1_00 + 0x324) = *(uint *)(param_1_00 + 0x324) | 2;
  return;
}

