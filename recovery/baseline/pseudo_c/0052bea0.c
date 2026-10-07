/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052bea0 */

void __thiscall FUN_0052bea0(int param_1_00,byte param_1)

{
  *(uint *)(param_1_00 + 0x16ba) = *(uint *)(param_1_00 + 0x16ba) | 1 << (param_1 & 0x1f);
  return;
}


