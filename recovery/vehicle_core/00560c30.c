/* Ghidra pseudo-C; NR2003.exe @ 00560c30 */

void FUN_00560c30(int param_1,int param_2,int param_3)

{
  FUN_005b7fe0(&DAT_00c08468,&PTR_DAT_006f746c);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c085c4,param_1 + 0x2d5,param_2 + 0x2d5);
  (**(code **)(PTR_PTR_0074fe48 + 8))(&DAT_00c085c4,&DAT_00c085c4,&DAT_00c0867c);
  (**(code **)(PTR_PTR_0074fe48 + 0xc))(&DAT_00c08470,&PTR_DAT_0074e788 + param_3,&DAT_00c085c4);
  FUN_005b8040(param_1 + 0x39d,param_1 + 0x39d,&DAT_00c08468);
  FUN_005b8fd0(&DAT_00c08424,param_1 + 0x3e5,&DAT_00c08468);
  FUN_005b8080(DAT_00c08378 + 0x39d,DAT_00c08378 + 0x39d,&DAT_00c08424);
  FUN_005b8080(param_2 + 0x39d,param_2 + 0x39d,&DAT_00c08468);
  FUN_005b8fd0(&DAT_00c08424,param_2 + 0x3e5,&DAT_00c08468);
  FUN_005b8040();
  return;
}

