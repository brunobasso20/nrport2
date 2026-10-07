/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578590 */

undefined4 * __fastcall FUN_00578590(undefined4 *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  
  param_1[1] = 0;
  param_1[0x272] = 0;
  puVar1 = param_1 + 0x4e3;
  iVar2 = 2;
  do {
    *puVar1 = 0;
    puVar1 = puVar1 + 0xb11;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  param_1[0x1b06] = 0;
  param_1[0x2617] = 0;
  param_1[0x2618] = 0;
  param_1[0x2619] = 0;
  param_1[0x261a] = 0;
  param_1[0x261b] = 0;
  param_1[0x2619] = param_1 + 0x2618;
  param_1[0x264c] = 0;
  param_1[0x264d] = 0;
  *(undefined1 *)(param_1 + 0x2657) = 0;
  *param_1 = &PTR_FUN_006f611c;
  puVar1 = param_1 + 0x261c;
  for (iVar2 = 0x30; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar1 = 0;
    puVar1 = puVar1 + 1;
  }
  return param_1;
}


