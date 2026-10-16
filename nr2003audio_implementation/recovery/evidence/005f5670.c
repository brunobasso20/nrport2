/* NR2003.exe @ 005f5670 rndInt */

/* int __cdecl rndInt(unsigned int) */

int __cdecl rndInt(uint param_1)

{
  int iVar1;

                    /* 0x1f5670  260  ?rndInt@@YAHI@Z */
  if (param_1 < 2) {
    iVar1 = (&DAT_00f6eae4)[param_1] * 0x19660d + 0x3c6ef35f;
    (&DAT_00f6eae4)[param_1] = iVar1;
    return iVar1;
  }
  DAT_00f6eae4 = DAT_00f6eae4 * 0x19660d + 0x3c6ef35f;
  return DAT_00f6eae4;
}
