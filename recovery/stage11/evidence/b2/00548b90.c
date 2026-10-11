/* NR2003.exe @ 00548b90 FUN_00548b90 */

uint FUN_00548b90(int param_1,char param_2)

{
  return (*(ushort *)(param_1 + 2) & 0xfff) >> (param_2 * '\x02' & 0x1fU) & 3;
}

