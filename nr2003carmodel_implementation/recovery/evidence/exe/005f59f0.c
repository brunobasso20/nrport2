/* NR2003.exe @ 005f59f0 FUN_005f59f0 */

void FUN_005f59f0(int param_1,undefined4 *param_2)

{
  *(undefined4 *)(param_1 + 0xc) = *param_2;
  *(undefined4 *)(param_1 + 0x10) = param_2[1];
  *(undefined4 *)(param_1 + 0x14) = param_2[2];
  *(float *)(param_1 + 0x44) =
       *(float *)(param_1 + 0x34) * *(float *)(param_1 + 0xc) +
       *(float *)(param_1 + 0x10) * *(float *)(param_1 + 0x38);
  *(float *)(param_1 + 0x48) =
       *(float *)(param_1 + 0x10) * *(float *)(param_1 + 0x34) -
       *(float *)(param_1 + 0x38) * *(float *)(param_1 + 0xc);
  return;
}

