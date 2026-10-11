/* NR2003.exe @ 005acdd0 FUN_005acdd0 */

void FUN_005acdd0(undefined4 *param_1)

{
  undefined4 *puVar1;
  
  FUN_00501870(10);
  puVar1 = (undefined4 *)FUN_00501a20(0x10);
  if (puVar1 != (undefined4 *)0x0) {
    *puVar1 = *param_1;
    puVar1[1] = param_1[1];
    puVar1[2] = param_1[2];
    puVar1[3] = param_1[3];
  }
  FUN_00501a40();
  return;
}

