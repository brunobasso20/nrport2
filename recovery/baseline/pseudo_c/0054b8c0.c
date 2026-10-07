/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b8c0 */

void __thiscall FUN_0054b8c0(ushort *param_1_00,undefined4 param_1)

{
  short sVar1;
  
  sVar1 = FUN_006c5018();
  *(undefined4 *)(param_1_00 + 0x26) = param_1;
  *param_1_00 = *param_1_00 & 0x3fff ^ sVar1 << 0xe;
  return;
}


