/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052f2c0 */

int FUN_0052f2c0(float param_1,float param_2,float param_3)

{
  if (param_3 <= param_2) {
    if (param_2 < param_3 || (param_2 == param_3) != 0) {
      return (uint)(byte)(param_2 < param_3 |
                         (byte)((ushort)((ushort)(param_2 == param_3) << 0xe) >> 8)) << 8;
    }
    if (param_2 < param_1) {
      return 1;
    }
  }
  else if (param_1 <= param_2) {
    return 0;
  }
  if (param_1 < param_3) {
    return 1;
  }
  return 0;
}


