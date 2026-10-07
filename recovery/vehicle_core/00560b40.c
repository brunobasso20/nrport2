/* Ghidra pseudo-C; NR2003.exe @ 00560b40 */

void FUN_00560b40(int param_1,int param_2)

{
  FUN_005b7fe0(&DAT_00c082bc,&PTR_DAT_006f746c);
  FUN_0057cc40(&DAT_00c082c4,(&PTR_DAT_0074e27c)[param_2],param_1 + 0x2d5);
  FUN_0057cc40(&DAT_00c08484,(&PTR_DAT_0074e72c)[param_2],param_1 + 0x38d);
  (**(code **)PTR_PTR_0074fe48)(&DAT_00c082c4,&DAT_00c082c4,&DAT_00c08484);
  FUN_005b8040(param_1 + 0x39d,param_1 + 0x39d,&DAT_00c082bc);
  FUN_005b8fd0(&DAT_00c082bc,param_1 + 0x3e5,&DAT_00c082bc);
  FUN_005b8080(DAT_00c08378 + 0x39d,DAT_00c08378 + 0x39d,&DAT_00c082bc);
  return;
}

