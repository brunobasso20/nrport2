/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00410630 */

float10 FUN_00410630(int param_1,undefined4 param_2)

{
  float10 fVar1;
  float10 fVar2;
  
  fVar1 = (float10)FUN_005677d1(*(undefined4 *)(param_1 + 0xec),param_2);
  fVar2 = (float10)FUN_005677d1(*(undefined4 *)(param_1 + 0xf0),param_2);
  return fVar2 * (float10)DAT_007636e4 + (float10)(float)fVar1;
}


