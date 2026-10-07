/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005deac0 */

undefined4 * FUN_005deac0(void)

{
  undefined4 *extraout_EDX;
  
  FUN_005d8c00();
  *(undefined1 *)((int)extraout_EDX + 0x15) = 1;
  extraout_EDX[3] = 0;
  extraout_EDX[4] = 0;
  *(undefined1 *)(extraout_EDX + 5) = 0;
  *extraout_EDX = &PTR_LAB_006f88c8;
  return extraout_EDX;
}


