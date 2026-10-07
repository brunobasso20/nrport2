/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050a170 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0050a170(float param_1)

{
  float10 fVar1;
  
  fVar1 = (float10)_DAT_006e97d8 -
          (float10)_DAT_00749484 * (float10)_DAT_0074b098 * (float10)param_1;
  if (fVar1 < (float10)_DAT_006ea4cc) {
    fVar1 = (float10)_DAT_006ea4cc;
  }
  return (((float10)_DAT_0074b098 * (float10)param_1) / fVar1) * (float10)_DAT_00749480;
}


