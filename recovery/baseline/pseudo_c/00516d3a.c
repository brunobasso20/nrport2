/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00516d3a */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00516d3a(float param_1,float param_2)

{
  float10 fVar1;
  
  fVar1 = (float10)param_2 - (float10)param_1;
  if (fVar1 < (float10)_DAT_00ba7218) {
    return fVar1 + (float10)DAT_00bad918;
  }
  if ((float10)_DAT_00bad934 < fVar1) {
    fVar1 = fVar1 - (float10)DAT_00bad918;
  }
  return fVar1;
}


