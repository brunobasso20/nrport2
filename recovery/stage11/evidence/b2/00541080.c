/* NR2003.exe @ 00541080 FUN_00541080 */

void __fastcall FUN_00541080(int *param_1)

{
  param_1[0x10b] = -0x3c060000;
  param_1[0x10c] = -0x3c060000;
                    /* WARNING: Could not recover jumptable at 0x00541093. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)(*param_1 + 0x44))();
  return;
}

