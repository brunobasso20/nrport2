/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00565b70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565b70(int param_1)

{
  bool bVar1;
  int iVar2;
  float10 fVar3;
  float10 fVar4;
  
  iVar2 = FUN_004284f0(param_1 + 0x58e);
  fVar3 = (float10)fsin((float10)*(float *)(param_1 + 0x158c));
  fVar3 = -(fVar3 * (float10)*(float *)(iVar2 + 0x1bc));
  fVar4 = (float10)fsin((float10)*(float *)(param_1 + 0x1588));
  *(float *)(param_1 + 0x1594) = (float)((float10)*(float *)(iVar2 + 0x1b0) - fVar4 * fVar3);
  fVar4 = (float10)fcos((float10)*(float *)(param_1 + 0x1588));
  *(float *)(param_1 + 0x1598) = (float)(fVar4 * fVar3 + (float10)*(float *)(iVar2 + 0x1b4));
  fVar3 = (float10)fcos((float10)*(float *)(param_1 + 0x158c));
  *(float *)(param_1 + 0x159c) =
       (float)(fVar3 * (float10)*(float *)(iVar2 + 0x1bc) + (float10)*(float *)(iVar2 + 0x1b8));
  bVar1 = *(float *)(iVar2 + 0x1b4) < _DAT_006ea454;
  *(undefined4 *)(param_1 + 0x15a4) = 0;
  if (bVar1) {
    *(undefined4 *)(param_1 + 0x15a0) = 0xbe19999a;
    *(undefined4 *)(param_1 + 0x15a8) = 0xbf333333;
    return;
  }
  *(undefined4 *)(param_1 + 0x15a0) = 0x3e19999a;
  *(undefined4 *)(param_1 + 0x15a8) = 0x3f333333;
  return;
}


