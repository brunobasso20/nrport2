/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b7d0 */

void __thiscall FUN_0054b7d0(int param_1_00,char param_1)

{
  *(uint *)(param_1_00 + 0xc) =
       ((uint)(param_1 != '\0') << 0x18 ^ *(uint *)(param_1_00 + 0xc)) & 0x1000000 ^
       *(uint *)(param_1_00 + 0xc);
  return;
}


