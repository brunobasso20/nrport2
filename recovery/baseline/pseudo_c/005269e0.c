/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005269e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005269e0(int param_1)

{
  bool bVar1;
  float10 fVar2;
  
  bVar1 = *(float *)(param_1 + 0x1b5c) < _DAT_006e97d8;
  *(undefined4 *)(param_1 + 0x1b1e) = 0x24;
  if (bVar1) {
    fVar2 = (float10)FUN_00516d3a(*(undefined4 *)(param_1 + 0x1b54),
                                  *(undefined4 *)(param_1 + 0x186a));
    fVar2 = fVar2 / (float10)*(float *)(param_1 + 0x1b3c);
    *(float *)(param_1 + 0x1b5c) = (float)fVar2;
    if (fVar2 < (float10)_DAT_006ea454) {
      *(undefined4 *)(param_1 + 0x1b5c) = 0;
    }
  }
  return;
}


