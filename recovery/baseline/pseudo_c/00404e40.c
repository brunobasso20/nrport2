/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00404e40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00404e40(int param_1)

{
  float10 fVar1;
  
  fVar1 = (float10)_DAT_0074b260 * (float10)_DAT_006ea448;
  if (param_1 == DAT_00760b38) {
    fVar1 = fVar1 + fVar1;
  }
  return fVar1;
}


