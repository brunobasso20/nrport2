/* NR2003.exe @ 005bd5e0 FUN_005bd5e0 */

void FUN_005bd5e0(int param_1)

{
  int iVar1;
  
  if ((param_1 != 0) &&
     (iVar1 = (&DAT_00edf228)[param_1], (&DAT_00edf228)[param_1] = iVar1 + -1, iVar1 + -1 < 0)) {
    DAT_00ebfc7c = DAT_00ebfc7c + -1;
    (&DAT_00ebfc80)[DAT_00ebfc7c] = param_1;
  }
  return;
}

