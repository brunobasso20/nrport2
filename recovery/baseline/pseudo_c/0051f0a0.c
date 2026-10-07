/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051f0a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0051f0a0(float param_1)

{
  float10 fVar1;
  
  if (_DAT_006e97d8 <= param_1) {
    return (float10)_DAT_006ea62c;
  }
  if (param_1 < _DAT_006ea454) {
    fVar1 = (float10)FUN_0051f0a0(-param_1);
    return -fVar1;
  }
  fVar1 = (float10)FUN_006c5c40();
  return (float10)_DAT_006ea62c - fVar1;
}


