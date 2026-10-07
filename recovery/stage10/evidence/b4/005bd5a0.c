/* NR2003.exe @ 005bd5a0 FUN_005bd5a0 */

void FUN_005bd5a0(int param_1)

{
  int iVar1;
  
  if ((&DAT_00edf228)[param_1] == 0) {
    iVar1 = (&DAT_00ebfc80)[DAT_00ebfc7c];
    DAT_00ebfc7c = DAT_00ebfc7c + 1;
    (&DAT_00edf228)[param_1] = iVar1;
    (&DAT_00edf228)[iVar1] = 0;
  }
  return;
}

