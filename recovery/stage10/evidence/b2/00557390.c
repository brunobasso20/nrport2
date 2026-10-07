/* NR2003.exe @ 00557390 FUN_00557390 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00557390(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00bf8d78;
  DAT_00bf8d6c = &DAT_00bf8d78;
  _DAT_00bf8d70 = 0x8fc;
  DAT_00bf8d74 = 0x5c;
  do {
    *piVar1 = DAT_00bf8d74 + (int)piVar1;
    piVar1 = (int *)((int)piVar1 + DAT_00bf8d74);
  } while (piVar1 < &DAT_00bf9674);
  *(undefined4 *)((int)piVar1 - DAT_00bf8d74) = 0;
  DAT_00bf8d68 = DAT_00bf8d6c;
  return;
}

