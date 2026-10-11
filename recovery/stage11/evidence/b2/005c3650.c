/* NR2003.exe @ 005c3650 FUN_005c3650 */

int FUN_005c3650(ushort *param_1)

{
  if ((*param_1 & 1) == 0) {
    return 0;
  }
  return ((*param_1 & 0x3e) >> 1) + 1;
}

