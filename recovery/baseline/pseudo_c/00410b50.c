/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00410b50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00410b50(int param_1,undefined4 param_2,undefined4 param_3,float param_4,float param_5)

{
  float10 fVar1;
  
  if (((*(byte *)(param_1 + 0x9c) & 2) != 0) && (DAT_0071f904 != 0)) {
    fVar1 = (float10)FUN_005677d1(*(undefined4 *)(param_1 + 0xf8),param_3);
    _DAT_007636e0 =
         (float)(((fVar1 - (float10)_DAT_006ea494) * (float10)param_4 * (float10)_DAT_006ea4a4 -
                 (float10)_DAT_006ea62c) * (float10)param_5 * (float10)_DAT_006ec75c +
                (float10)_DAT_007636e0);
    DAT_007636e4 = DAT_007636e4 + _DAT_007636e0;
    if (_DAT_006e97d8 < DAT_007636e4) {
      DAT_007636e4 = 1.0;
      _DAT_007636e0 = 0.0;
      return;
    }
    if (DAT_007636e4 < _DAT_006ea454) {
      DAT_007636e4 = 0.0;
      _DAT_007636e0 = 0.0;
    }
    return;
  }
  return;
}


