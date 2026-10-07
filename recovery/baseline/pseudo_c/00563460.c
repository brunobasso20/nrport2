/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00563460 */

void FUN_00563460(int param_1,undefined4 *param_2,int param_3)

{
  float fVar1;
  
  *param_2 = (&DAT_00c533c8)[param_3 * 3];
  param_2[1] = (&DAT_00c533cc)[param_3 * 3];
  fVar1 = (float)(&DAT_00c533d0)[param_3 * 3];
  param_2[2] = fVar1;
  param_2[2] = fVar1 + *(float *)(param_1 + 0x1558 + param_3 * 4);
  return;
}


