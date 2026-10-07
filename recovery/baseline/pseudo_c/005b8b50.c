/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b8b50 */

void FUN_005b8b50(int param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar2 = (param_2 + 1) % 3;
  iVar3 = (param_2 + 2) % 3;
  (**(code **)PTR_PTR_0074fe4c)(param_2 * 0x10 + param_1,&PTR_DAT_0074fd84);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + (param_2 * 3 + iVar2) * 4,&PTR_DAT_0074fd80);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + (param_2 * 3 + iVar3) * 4,&PTR_DAT_0074fd80);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + (iVar2 * 3 + param_2) * 4,&PTR_DAT_0074fd80);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + (iVar3 * 3 + param_2) * 4,&PTR_DAT_0074fd80);
  iVar1 = iVar2 * 0x10 + param_1;
  (**(code **)(PTR_PTR_0074fe4c + 0x14))(iVar1,param_3);
  (**(code **)PTR_PTR_0074fe4c)(iVar3 * 0x10 + param_1,iVar1);
  iVar1 = param_1 + (iVar3 * 3 + iVar2) * 4;
  (**(code **)(PTR_PTR_0074fe4c + 0x10))(iVar1,param_3);
  (**(code **)(PTR_PTR_0074fe4c + 4))(param_1 + (iVar2 * 3 + iVar3) * 4,iVar1);
  return;
}


