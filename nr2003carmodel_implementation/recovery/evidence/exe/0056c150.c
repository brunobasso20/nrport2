/* NR2003.exe @ 0056c150 FUN_0056c150 */

uint FUN_0056c150(int param_1,uint param_2)

{
  if (0x7fffffff < param_2) {
    param_2 = DAT_00c5c2e0;
  }
  if ((((int)param_2 < DAT_00c5ca20) && (-1 < param_1)) && (param_1 < 5)) {
    return CONCAT31((int3)(param_2 * 0x1b >> 8),
                    (*(uint *)(&DAT_00c5c3c8 + param_2 * 0x6c) & 1 << ((byte)param_1 & 0x1f)) != 0);
  }
  return param_2 & 0xffffff00;
}

