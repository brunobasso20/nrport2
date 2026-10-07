/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b9970 */

float * FUN_005b9970(float param_1)

{
  float *pfVar1;
  
  pfVar1 = DAT_00ec02c4;
  do {
    pfVar1 = pfVar1 + -1;
    if (pfVar1 < (float *)0xebf611) {
      DAT_00ec02c4 = DAT_00ec02c4 + 1;
      *DAT_00ec02c4 = param_1;
      return DAT_00ec02c4;
    }
  } while (*pfVar1 != param_1);
  return pfVar1;
}


