/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00541600 */

void __fastcall FUN_00541600(undefined4 *param_1)

{
  int iVar1;
  
  *param_1 = 0xde7ad7e3;
  param_1[1] = 0x71c33234;
  param_1[2] = 0;
  param_1[3] = 0;
  param_1[4] = 0;
  param_1[5] = 0;
  param_1[6] = 0;
  param_1 = param_1 + 9;
  iVar1 = 6;
  do {
    param_1[-2] = 0;
    param_1[-1] = 0xbff00000;
    *param_1 = 0;
    param_1[1] = 0x3ff00000;
    param_1 = (undefined4 *)((int)param_1 + 0x19);
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}


