/* NR2003.exe @ 00619640 FUN_00619640 */

void FUN_00619640(undefined4 param_1,undefined4 param_2,undefined4 param_3,char *param_4)

{
  undefined *puVar1;
  
  if (param_4 == (char *)0x0) {
    param_4 = &DAT_00f7293c;
  }
  else if (('/' < *param_4) && (puVar1 = &DAT_00756654, *param_4 < ':')) goto LAB_00619665;
  puVar1 = &DAT_00f7293d;
LAB_00619665:
  FUN_006c4f81(param_1,s____d_s_s_00756658,param_3,puVar1,param_4);
  return;
}

