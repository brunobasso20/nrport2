/* NR2003.exe @ 00565b70 FUN_00565b70 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565b70(int param_1)

{
  float fVar1;
  bool bVar2;
  bool bVar3;
  int iVar4;
  float10 fVar5;
  float10 fVar6;
  
  iVar4 = FUN_004284f0(param_1 + 0x58e);
  fVar5 = (float10)fsin((float10)*(float *)(param_1 + 0x158c));
  fVar5 = -(fVar5 * (float10)*(float *)(iVar4 + 0x1bc));
  fVar6 = (float10)fsin((float10)*(float *)(param_1 + 0x1588));
  *(float *)(param_1 + 0x1594) = (float)((float10)*(float *)(iVar4 + 0x1b0) - fVar6 * fVar5);
  fVar6 = (float10)fcos((float10)*(float *)(param_1 + 0x1588));
  *(float *)(param_1 + 0x1598) = (float)(fVar6 * fVar5 + (float10)*(float *)(iVar4 + 0x1b4));
  fVar5 = (float10)fcos((float10)*(float *)(param_1 + 0x158c));
  *(float *)(param_1 + 0x159c) =
       (float)(fVar5 * (float10)*(float *)(iVar4 + 0x1bc) + (float10)*(float *)(iVar4 + 0x1b8));
  fVar1 = *(float *)(iVar4 + 0x1b4);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 < _DAT_006ea454;
  *(undefined4 *)(param_1 + 0x15a4) = 0;
  if (bVar3 != (NAN(fVar1) || bVar2)) {
    *(undefined4 *)(param_1 + 0x15a0) = 0xbe19999a;
    *(undefined4 *)(param_1 + 0x15a8) = 0xbf333333;
    return;
  }
  *(undefined4 *)(param_1 + 0x15a0) = 0x3e19999a;
  *(undefined4 *)(param_1 + 0x15a8) = 0x3f333333;
  return;
}

