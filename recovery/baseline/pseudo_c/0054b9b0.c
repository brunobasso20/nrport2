/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b9b0 */

void __thiscall FUN_0054b9b0(ushort *param_1_00,char param_1,char param_2)

{
  *param_1_00 = ((ushort)(~(3 << (param_1 * '\x02' & 0x1fU)) << 6) | 0xc03f) & *param_1_00 |
                (ushort)(byte)(param_2 << (param_1 * '\x02' & 0x1fU)) << 6;
  return;
}


