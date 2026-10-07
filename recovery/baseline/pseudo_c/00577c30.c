/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00577c30 */

void __fastcall FUN_00577c30(undefined4 *param_1)

{
  undefined4 *puVar1;
  
  puVar1 = (undefined4 *)param_1[1];
  *param_1 = &PTR_FUN_006f6118;
  if (puVar1 != (undefined4 *)0x0) {
    if ((param_1[0x10] != 0) && (puVar1 != (undefined4 *)0x0)) {
      (**(code **)*puVar1)(1);
    }
    param_1[1] = 0;
  }
  puVar1 = (undefined4 *)param_1[2];
  if (puVar1 != (undefined4 *)0x0) {
    if ((param_1[0x10] != 0) && (puVar1 != (undefined4 *)0x0)) {
      (**(code **)*puVar1)(1);
    }
    param_1[2] = 0;
  }
  return;
}


