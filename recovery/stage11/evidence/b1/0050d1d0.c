/* NR2003.exe @ 0050d1d0 FUN_0050d1d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050d1d0(void)

{
  undefined *puVar1;
  
  puVar1 = &DAT_00b8f830;
  DAT_00b8fa94 = 0;
  _DAT_00b8fa98 = 0;
  _DAT_00b8fa9c = 0;
  do {
    *puVar1 = 0;
    puVar1 = puVar1 + 0x50;
  } while ((int)puVar1 < 0xb8f920);
  return;
}

