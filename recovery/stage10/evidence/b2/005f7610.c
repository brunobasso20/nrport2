/* NR2003.exe @ 005f7610 FUN_005f7610 */

uint FUN_005f7610(byte *param_1,int param_2,uint param_3)

{
  if (param_2 == 0) {
    return param_3 & 0xffff;
  }
  do {
    param_3 = (uint)(*(ushort *)(&DAT_006f8b90 + (param_3 & 0xff ^ (uint)*param_1) * 2) ^
                    (ushort)(param_3 >> 8) & 0xff);
    param_1 = param_1 + 1;
    param_2 = param_2 + -1;
  } while (param_2 != 0);
  return param_3;
}

