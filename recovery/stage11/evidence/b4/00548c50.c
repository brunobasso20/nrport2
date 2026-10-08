/* NR2003.exe @ 00548c50 FUN_00548c50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00548c50(int param_1,char param_2)

{
  return (float10)(ulonglong)
                  ((*(uint *)(param_1 + 4) >> 7 & 0xff) >> (param_2 * '\x02' & 0x1fU) & 3) *
         (float10)_DAT_006f49d0;
}

