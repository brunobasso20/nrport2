/* NR2003.exe @ 00520130 FUN_00520130 */

void __thiscall
FUN_00520130(undefined4 *param_1_00,undefined4 param_1,undefined param_2,undefined4 param_3)

{
  int iVar1;
  
  *param_1_00 = param_1;
  *(undefined *)(param_1_00 + 1) = param_2;
  *(undefined4 *)((int)param_1_00 + 5) = param_3;
  *(undefined *)((int)param_1_00 + 9) = 0;
  *(undefined *)((int)param_1_00 + 10) = 0;
  *(undefined4 *)((int)param_1_00 + 0xb) = 0;
  param_1_00 = (undefined4 *)((int)param_1_00 + 0x7b);
  iVar1 = 0x1b;
  do {
    param_1_00[-0x1b] = 0;
    *param_1_00 = 0;
    param_1_00[0x1b] = 0;
    param_1_00 = param_1_00 + 1;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

