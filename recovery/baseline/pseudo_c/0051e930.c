/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051e930 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051e930(int param_1)

{
  float fVar1;
  char cVar2;
  float10 fVar3;
  float local_4;
  
  if (*(float *)(param_1 + 0x560) <= _DAT_006ea67c) {
    fVar3 = (float10)_DAT_006ea454;
  }
  else {
    fVar1 = *(float *)(param_1 + 0x454 + *(int *)(param_1 + 0x18f6) * 4) *
            *(float *)(param_1 + 0x474);
    FUN_0051a870(&local_4,0x3f800000,*(undefined4 *)(param_1 + 0x1906));
    fVar3 = ((float10)_DAT_006e97d8 / (float10)*(float *)(param_1 + 0x190e)) * (float10)local_4 *
            (float10)fVar1 * (float10)_DAT_006f49a4 * (float10)*(float *)(param_1 + 0x17ee) -
            (float10)_DAT_0074ac18 * (float10)_DAT_006f49a0 * (float10)*(float *)(param_1 + 0x1902)
            * (float10)fVar1;
    local_4 = (float)fVar3;
    if ((*(uint *)(param_1 + 0x139f) & 0x400) != 0) {
      cVar2 = FUN_00535490(param_1);
      if (cVar2 == '\0') {
        fVar3 = (float10)0.3;
      }
      else {
        fVar3 = (float10)FUN_00516e1a();
        fVar3 = (float10)_DAT_006e97d8 - (float10)*(float *)(param_1 + 0x186a) / fVar3;
        fVar3 = fVar3 * fVar3;
        fVar3 = fVar3 * fVar3;
        if (fVar3 < (float10)_DAT_006ef640) {
          return (float10)_DAT_006ef640 * (float10)local_4;
        }
      }
      return fVar3 * (float10)local_4;
    }
  }
  return fVar3;
}


