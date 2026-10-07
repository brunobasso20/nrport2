/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5650 */

/* void __cdecl rndSeed(int,unsigned int) */

void __cdecl rndSeed(int param_1,uint param_2)

{
                    /* 0x1f5650  262  ?rndSeed@@YAXHI@Z */
  if (param_2 < 2) {
    (&DAT_00f6eae4)[param_2] = param_1;
    return;
  }
  DAT_00f6eae4 = param_1;
  return;
}


