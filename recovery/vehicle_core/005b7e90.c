/* Ghidra pseudo-C; NR2003.exe @ 005b7e90 */

void FUN_005b7e90(undefined *param_1,undefined *param_2,undefined *param_3)

{
  undefined *puVar1;
  undefined *puVar2;
  undefined *puVar3;
  
  if ((param_1 == param_2) || (puVar3 = param_1, param_1 == param_3)) {
    puVar3 = &DAT_00ead1a8;
  }
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead160,param_2 + 4,param_3 + 8);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(puVar3,param_3 + 4,param_2 + 8);
  (**(code **)(PTR_PTR_0074fe48 + 8))(puVar3,&DAT_00ead160,puVar3);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead160,param_2 + 8,param_3);
  puVar1 = puVar3 + 4;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(puVar1,param_3 + 8,param_2);
  (**(code **)(PTR_PTR_0074fe48 + 8))(puVar1,&DAT_00ead160,puVar1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead160,param_2,param_3 + 4);
  puVar2 = param_1 + 8;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(puVar2,param_3,param_2 + 4);
  (**(code **)(PTR_PTR_0074fe48 + 8))(puVar2,&DAT_00ead160,puVar2);
  if (puVar3 != param_1) {
    (**(code **)PTR_PTR_0074fe4c)(param_1,puVar3);
    (**(code **)PTR_PTR_0074fe4c)(param_1 + 4,puVar1);
  }
  return;
}

