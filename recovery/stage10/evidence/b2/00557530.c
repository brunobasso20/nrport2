/* NR2003.exe @ 00557530 FUN_00557530 */

void FUN_00557530(undefined4 *param_1)

{
  if ((code *)param_1[0x16] != (code *)0x0) {
    (*(code *)param_1[0x16])();
    *param_1 = DAT_00bf8d68;
    DAT_00bf8d68 = param_1;
    return;
  }
  *param_1 = DAT_00bf8d68;
  DAT_00bf8d68 = param_1;
  return;
}

