/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b4c0 */

void __thiscall FUN_0054b4c0(int param_1_00,char param_1)

{
  *(undefined4 *)(param_1_00 + 100) = 0;
  *(uint *)(param_1_00 + 0xc) =
       ((uint)(param_1 != '\0') << 0x19 ^ *(uint *)(param_1_00 + 0xc)) & 0x2000000 ^
       *(uint *)(param_1_00 + 0xc);
  return;
}


