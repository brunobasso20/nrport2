/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f6e10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f6e10(int param_1_00,int param_1,char param_2)

{
  float *pfVar1;
  float fVar2;
  double dVar3;
  
  pfVar1 = (float *)(param_1_00 + (param_1 * 3 + 0xc) * 4);
  dVar3 = rndNormal(0);
  fVar2 = (float)dVar3;
  if (_DAT_006ea454 < _DAT_0074b7b8) {
    fVar2 = _DAT_006ea454;
  }
  while ((fVar2 < _DAT_006f3e24 || (_DAT_006e9804 < fVar2))) {
    dVar3 = rndNormal(0);
    fVar2 = (float)dVar3;
  }
  if (param_2 != '\0') {
    pfVar1[2] = fVar2 * pfVar1[1] + *pfVar1;
  }
  return;
}


