/* NR2003.exe @ 005b9210 FUN_005b9210 */

void FUN_005b9210(undefined *param_1,undefined *param_2,undefined *param_3)

{
  undefined *puVar1;
  int iVar2;
  int iVar3;
  undefined *puVar4;
  undefined *puVar5;
  undefined *local_14;
  undefined *local_10;
  int local_c;
  int local_8;
  
  if ((param_1 == param_2) || (local_10 = param_1, param_1 == param_3)) {
    local_10 = &DAT_00ead0c0;
  }
  iVar3 = (int)local_10 - (int)param_2;
  local_8 = 6;
  do {
    puVar4 = param_2 + iVar3;
    local_14 = param_3;
    local_c = 6;
    do {
      (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(puVar4,param_2,local_14);
      iVar2 = 5;
      puVar1 = param_2;
      puVar5 = local_14;
      do {
        puVar5 = puVar5 + 4;
        puVar1 = puVar1 + 4;
        (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00ead170,puVar1,puVar5);
        (**(code **)(PTR_PTR_FUN_0074fe4c + 0x18))(puVar4,&DAT_00ead170);
        iVar2 = iVar2 + -1;
      } while (iVar2 != 0);
      FUN_0057cb80(puVar4);
      puVar4 = puVar4 + 4;
      local_14 = local_14 + 0x18;
      local_c = local_c + -1;
    } while (local_c != 0);
    param_2 = param_2 + 0x18;
    local_8 = local_8 + -1;
  } while (local_8 != 0);
  if (local_10 != param_1) {
    FUN_005b8d90(param_1,local_10);
  }
  return;
}

