/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b8260 */

void FUN_005b8260(undefined *param_1,undefined *param_2,undefined *param_3)

{
  int iVar1;
  undefined *puVar2;
  int iVar3;
  undefined *puVar4;
  undefined *puVar5;
  undefined *local_14;
  undefined *local_10;
  int local_c;
  int local_8;
  
  if ((param_1 == param_2) || (local_10 = param_1, param_1 == param_3)) {
    local_10 = &DAT_00eacff0;
  }
  iVar1 = (int)local_10 - (int)param_2;
  local_8 = 3;
  do {
    puVar2 = param_2 + iVar1;
    local_14 = param_3;
    local_c = 3;
    do {
      (**(code **)(PTR_PTR_0074fe48 + 0xc))(puVar2,param_2,local_14);
      iVar3 = 2;
      puVar4 = param_2;
      puVar5 = local_14;
      do {
        puVar5 = puVar5 + 0xc;
        puVar4 = puVar4 + 4;
        (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf74,puVar4,puVar5);
        (**(code **)(PTR_PTR_0074fe4c + 0x18))(puVar2,&DAT_00eacf74);
        iVar3 = iVar3 + -1;
      } while (iVar3 != 0);
      FUN_0057cb80(puVar2);
      local_14 = local_14 + 4;
      puVar2 = puVar2 + 4;
      local_c = local_c + -1;
    } while (local_c != 0);
    param_2 = param_2 + 0xc;
    local_8 = local_8 + -1;
  } while (local_8 != 0);
  if (local_10 != param_1) {
    FUN_005b8180(param_1,local_10);
  }
  return;
}


