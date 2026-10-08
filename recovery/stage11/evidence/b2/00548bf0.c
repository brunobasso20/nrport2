/* NR2003.exe @ 00548bf0 FUN_00548bf0 */

uint FUN_00548bf0(ushort *param_1,char param_2)

{
  return ((*param_1 & 0x3fc0) >> 6) >> (param_2 * '\x02' & 0x1fU) & 3;
}

