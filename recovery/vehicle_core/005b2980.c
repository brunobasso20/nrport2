/* Ghidra pseudo-C; NR2003.exe @ 005b2980 */

undefined4 FUN_005b2980(char *param_1)

{
  if (((param_1 < s_chassis_00727290) || (s_chassis_00727290 + DAT_0072c2e0 * 0x505 <= param_1)) &&
     ((param_1 < &DAT_00e84474 || ((char *)0xe84497 < param_1)))) {
    return 0;
  }
  return 1;
}

