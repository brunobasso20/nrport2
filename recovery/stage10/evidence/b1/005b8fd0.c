/* NR2003.exe @ 005b8fd0 FUN_005b8fd0 */

void FUN_005b8fd0(undefined *param_1,int param_2,undefined *param_3)

{
  int iVar1;
  int iVar2;
  undefined *puVar3;
  undefined *puVar4;
  undefined *local_8;
  int local_4;
  
  local_8 = &DAT_00ead190;
  if (param_1 != param_3) {
    local_8 = param_1;
  }
  local_4 = 6;
  puVar3 = local_8;
  do {
    (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(puVar3,param_2,param_3);
    iVar2 = 5;
    iVar1 = param_2;
    puVar4 = param_3;
    do {
      puVar4 = puVar4 + 4;
      iVar1 = iVar1 + 4;
      (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00eacf80,iVar1,puVar4);
      (**(code **)(PTR_PTR_FUN_0074fe4c + 0x18))(puVar3,&DAT_00eacf80);
      iVar2 = iVar2 + -1;
    } while (iVar2 != 0);
    FUN_0057cb80(puVar3);
    param_2 = param_2 + 0x18;
    puVar3 = puVar3 + 4;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  if (local_8 != param_1) {
    FUN_005b7fe0(param_1,local_8);
  }
  return;
}

