/* NR2003.exe @ 005b87c0 FUN_005b87c0 */

void FUN_005b87c0(undefined *param_1,int param_2,undefined *param_3)

{
  int iVar1;
  undefined *puVar2;
  int iVar3;
  undefined *puVar4;
  undefined *puVar5;
  undefined *local_8;
  
  iVar1 = param_2;
  if (param_1 == param_3) {
    local_8 = &DAT_00ead1b8;
  }
  else {
    local_8 = param_1;
  }
  param_2 = 3;
  puVar4 = local_8;
  do {
    puVar2 = puVar4 + (iVar1 - (int)local_8);
    (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(puVar4,puVar2,param_3);
    iVar3 = 2;
    puVar5 = param_3;
    do {
      puVar5 = puVar5 + 4;
      puVar2 = puVar2 + 0xc;
      (**(code **)(PTR_PTR_FUN_0074fe48 + 0xc))(&DAT_00eacfb8,puVar2,puVar5);
      (**(code **)(PTR_PTR_FUN_0074fe4c + 0x18))(puVar4,&DAT_00eacfb8);
      iVar3 = iVar3 + -1;
    } while (iVar3 != 0);
    FUN_0057cb80(puVar4);
    puVar4 = puVar4 + 4;
    param_2 = param_2 + -1;
  } while (param_2 != 0);
  if (local_8 != param_1) {
    FUN_005b7d10(param_1,local_8);
  }
  return;
}

