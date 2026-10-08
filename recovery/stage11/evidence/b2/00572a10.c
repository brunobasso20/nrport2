/* NR2003.exe @ 00572a10 FUN_00572a10 */

void FUN_00572a10(undefined4 *param_1,int param_2)

{
  undefined4 uVar1;
  
  uVar1 = FUN_0055a680();
  FUN_00572760(uVar1);
  if (DAT_00c72160 != 0) {
    if (DAT_0074f3d8 == '\0') {
      *param_1 = 1;
      return;
    }
    if ((param_2 == 2) || (param_2 == 3)) {
      FUN_00572a80(1);
      *param_1 = 1;
      return;
    }
    FUN_00572a80(0);
  }
  *param_1 = 1;
  return;
}

