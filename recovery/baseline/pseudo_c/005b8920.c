/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b8920 */

void FUN_005b8920(int param_1,int param_2)

{
  int iVar1;
  int iVar2;
  
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf70,&PTR_DAT_0074fd8c,param_2 + 0xc);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf6c,&DAT_00eacf70,param_2);
  iVar1 = param_2 + 4;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead16c,&DAT_00eacf70,iVar1);
  iVar2 = param_2 + 8;
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead1cc,&DAT_00eacf70,iVar2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf70,&DAT_00eacf70,param_2 + 0xc);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead150,&PTR_DAT_0074fd8c,param_2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf68,&DAT_00ead150,iVar1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead1b4,&DAT_00ead150,iVar2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead150,&DAT_00ead150,param_2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf78,&PTR_DAT_0074fd8c,iVar1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead158,&DAT_00eacf78,iVar2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00eacf78,&DAT_00eacf78,iVar1);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead178,&PTR_DAT_0074fd8c,iVar2);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00ead178,&DAT_00ead178,iVar2);
  (**(code **)PTR_PTR_0074fe48)(param_1,&DAT_00eacf70,&DAT_00ead150);
  (**(code **)(PTR_PTR_0074fe48 + 8))(param_1,param_1,&PTR_DAT_0074fd84);
  (**(code **)(PTR_PTR_0074fe48 + 8))(param_1 + 4,&DAT_00eacf68,&DAT_00ead1cc);
  (**(code **)PTR_PTR_0074fe48)(param_1 + 8,&DAT_00ead1b4,&DAT_00ead16c);
  (**(code **)PTR_PTR_0074fe48)(param_1 + 0xc,&DAT_00eacf68,&DAT_00ead1cc);
  iVar1 = param_1 + 0x10;
  (**(code **)PTR_PTR_0074fe48)(iVar1,&DAT_00eacf70,&DAT_00eacf78);
  (**(code **)(PTR_PTR_0074fe48 + 8))(iVar1,iVar1,&PTR_DAT_0074fd84);
  (**(code **)(PTR_PTR_0074fe48 + 8))(param_1 + 0x14,&DAT_00ead158,&DAT_00eacf6c);
  (**(code **)(PTR_PTR_0074fe48 + 8))(param_1 + 0x18,&DAT_00ead1b4,&DAT_00ead16c);
  (**(code **)PTR_PTR_0074fe48)(param_1 + 0x1c,&DAT_00ead158,&DAT_00eacf6c);
  param_1 = param_1 + 0x20;
  (**(code **)PTR_PTR_0074fe48)(param_1,&DAT_00eacf70,&DAT_00ead178);
  (**(code **)(PTR_PTR_0074fe48 + 8))(param_1,param_1,&PTR_DAT_0074fd84);
  return;
}


