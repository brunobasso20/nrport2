/* NR2003.exe @ 005576f0 FUN_005576f0 */

void FUN_005576f0(undefined4 param_1,undefined4 *param_2,undefined4 param_3)

{
  undefined4 *puVar1;
  
  FUN_00501870(6);
  puVar1 = (undefined4 *)FUN_00501a20(0x14);
  if (puVar1 != (undefined4 *)0x0) {
    if (param_2 != (undefined4 *)0x0) {
      *puVar1 = *param_2;
      puVar1[1] = param_2[1];
      puVar1[2] = param_2[2];
      puVar1[3] = param_3;
      puVar1[4] = param_1;
      FUN_00501a40();
      return;
    }
    *puVar1 = 0;
    puVar1[1] = 0;
    puVar1[2] = 0;
    puVar1[3] = param_3;
    puVar1[4] = param_1;
  }
  FUN_00501a40();
  return;
}

