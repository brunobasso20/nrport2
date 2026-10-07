/* NR2003.exe @ 005bd450 FUN_005bd450 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005bd450(void)

{
  DAT_00ec02c0 = 0;
  DAT_00ebfc68 = 0xffffff80;
  DAT_00ebfc6c = 0xffffff80;
  _DAT_00ebfc70 = 0xffffff80;
  _DAT_00ebfc74 = 0xffffff80;
  _DAT_00ebfc78 = 0xffffff80;
  do {
    (&DAT_00ebfc54)[DAT_00ec02c0] = DAT_00ec02c0;
    DAT_00ec02c0 = DAT_00ec02c0 + 1;
  } while (DAT_00ec02c0 < 5);
  return;
}

