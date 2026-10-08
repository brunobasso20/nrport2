/* NR2003.exe @ 00552410 FUN_00552410 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00552410(void)

{
  char cVar1;
  float10 fVar2;
  
  cVar1 = FUN_0055a770();
  if (cVar1 == '\0') {
    fVar2 = (float10)FUN_00550230();
    if (fVar2 <= (float10)_DAT_006ea454) {
      return (float10)_DAT_00bf6f00;
    }
  }
  return (float10)_DAT_00bf6f00 * (float10)_DAT_006ef740 + (float10)_DAT_006f59e4;
}

