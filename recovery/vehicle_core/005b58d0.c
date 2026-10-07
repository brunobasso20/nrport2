/* Ghidra pseudo-C; NR2003.exe @ 005b58d0 */

void FUN_005b58d0(void)

{
  FUN_005b56c0();
  FUN_005b5260();
  FUN_005b50c0();
  if (DAT_00c72160 != (int *)0x0) {
                    /* WARNING: Could not recover jumptable at 0x005b58f5. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**(code **)(*DAT_00c72160 + 0x70))();
    return;
  }
  return;
}

