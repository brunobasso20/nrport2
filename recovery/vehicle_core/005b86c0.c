/* Ghidra pseudo-C; NR2003.exe @ 005b86c0 */

void FUN_005b86c0(undefined *param_1,undefined *param_2,undefined *param_3)

{
  undefined *puVar1;
  int iVar2;
  undefined *puVar3;
  undefined *puVar4;
  undefined *local_10;
  undefined *local_c;
  int local_8;
  int local_4;
  
  if ((param_1 == param_2) || (local_c = param_1, param_1 == param_3)) {
    local_c = &DAT_00eacf84;
  }
  local_4 = 3;
  puVar3 = local_c;
  do {
    local_8 = 3;
    local_10 = param_3;
    do {
      (**(code **)(PTR_PTR_0074fe48 + 0xc))(puVar3,param_2,local_10);
      iVar2 = 2;
      puVar1 = param_2;
      puVar4 = local_10;
      do {
        puVar4 = puVar4 + 0xc;
        puVar1 = puVar1 + 0xc;
        (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead1c4,puVar1,puVar4);
        (**(code **)(PTR_PTR_0074fe4c + 0x18))(puVar3,&DAT_00ead1c4);
        iVar2 = iVar2 + -1;
      } while (iVar2 != 0);
      FUN_0057cb80(puVar3);
      local_10 = local_10 + 4;
      puVar3 = puVar3 + 4;
      local_8 = local_8 + -1;
    } while (local_8 != 0);
    param_2 = param_2 + 4;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  if (local_c != param_1) {
    FUN_005b8180(param_1,local_c);
  }
  return;
}

