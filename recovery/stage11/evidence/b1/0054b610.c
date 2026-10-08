/* NR2003.exe @ 0054b610 FUN_0054b610 */

void __thiscall FUN_0054b610(int param_1_00,char param_1)

{
  *(uint *)(param_1_00 + 0xc) =
       ((uint)(param_1 != '\0') << 0x1c ^ *(uint *)(param_1_00 + 0xc)) & 0x10000000 ^
       *(uint *)(param_1_00 + 0xc);
  return;
}

