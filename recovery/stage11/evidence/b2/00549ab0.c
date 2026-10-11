/* NR2003.exe @ 00549ab0 FUN_00549ab0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00549ab0(int *param_1)

{
  int iVar1;
  int *piVar2;
  float fVar3;
  int iVar4;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  iVar1 = *param_1;
  iVar4 = FUN_00562f70(iVar1);
  if (*(int *)(iVar4 + 4) != 0) {
    piVar2 = (int *)param_1[7];
    local_18 = (float)piVar2[0xd];
    local_14 = (float)piVar2[0xe];
    local_10 = (float)piVar2[0xf];
    local_24 = (float)piVar2[0x10];
    local_20 = (float)piVar2[0x11];
    local_1c = (float)piVar2[0x12];
    if (iVar1 != *(int *)(*(int *)(*piVar2 + 4) + 0x1a4)) {
      local_18 = -local_18;
      local_14 = -local_14;
      local_10 = -local_10;
      local_24 = -local_24;
      local_20 = -local_20;
      local_1c = -local_1c;
    }
    if (param_1[2] == 0x40000000) {
      fVar3 = (local_24 * local_18 + local_20 * local_14 + local_1c * local_10) * _DAT_006f5858;
      local_c = local_18 - local_24 * fVar3;
      local_8 = local_14 - fVar3 * local_20;
      local_4 = local_10 - fVar3 * local_1c;
      FUN_00585e30(param_1 + 3,&local_c,iVar1,param_1[1],param_1[6]);
    }
  }
  return;
}

