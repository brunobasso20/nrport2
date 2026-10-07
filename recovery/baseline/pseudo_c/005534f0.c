/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005534f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005534f0(void)

{
  char cVar1;
  float10 fVar2;
  
  cVar1 = FUN_00552400();
  if (cVar1 == '\0') {
    fVar2 = (float10)FUN_00554ee0();
    if ((fVar2 < (float10)_DAT_006ea478) && (_DAT_00bf6390 < _DAT_006e9824)) {
      return (float10)_DAT_006ea454;
    }
  }
  fVar2 = (float10)FUN_0057af30(4);
  return (float10)_DAT_006e97d8 - fVar2;
}


