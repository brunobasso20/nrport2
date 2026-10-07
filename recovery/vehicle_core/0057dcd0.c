/* Ghidra pseudo-C; NR2003.exe @ 0057dcd0 */

void FUN_0057dcd0(int param_1)

{
  DAT_00d47d6c = param_1;
  if (param_1 == 0) {
    PTR_PTR_0074fe48 = (undefined *)&PTR_FUN_0074fdac;
    PTR_PTR_0074fe4c = (undefined *)&PTR_FUN_0074fdbc;
  }
  else {
    if (param_1 == 1) {
      PTR_PTR_0074fe48 = (undefined *)&PTR_FUN_0074fde0;
      PTR_PTR_0074fe4c = (undefined *)&PTR_recovered_0057d3b0_0074fdf0;
      return;
    }
    if (param_1 == 2) {
      PTR_PTR_0074fe48 = (undefined *)&PTR_FUN_0074fe14;
      PTR_PTR_0074fe4c = (undefined *)&PTR_FUN_0074fe24;
      return;
    }
  }
  return;
}

