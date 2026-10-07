/* Ghidra pseudo-C; NR2003.exe @ 005b8880 */

void FUN_005b8880(int param_1,int param_2)

{
  (**(code **)PTR_PTR_0074fe4c)(param_1,&PTR_DAT_0074fd80);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + 0x1c,param_2);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + 8,param_2 + 4);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + 0xc,param_2 + 8);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + 0x10,&PTR_DAT_0074fd80);
  (**(code **)(PTR_PTR_0074fe4c + 4))(param_1 + 0x14,param_1 + 0x1c);
  (**(code **)(PTR_PTR_0074fe4c + 4))(param_1 + 0x18,param_1 + 8);
  (**(code **)(PTR_PTR_0074fe4c + 4))(param_1 + 4,param_1 + 0xc);
  (**(code **)PTR_PTR_0074fe4c)(param_1 + 0x20,&PTR_DAT_0074fd80);
  return;
}

