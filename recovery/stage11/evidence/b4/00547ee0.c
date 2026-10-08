/* NR2003.exe @ 00547ee0 FUN_00547ee0 */

void FUN_00547ee0(undefined4 *param_1,uint param_2)

{
  *param_1 = 0;
  param_1[1] = 0;
  param_1[2] = 0;
  param_1[3] = 0;
  FUN_005c3670(param_1,0x10);
  param_1[1] = (param_1[1] ^ param_2) & 0x7f ^ param_1[1];
  return;
}

