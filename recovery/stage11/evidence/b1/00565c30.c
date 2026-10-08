/* NR2003.exe @ 00565c30 FUN_00565c30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565c30(int param_1)

{
  float fVar1;
  bool bVar2;
  bool bVar3;
  int iVar4;
  
  iVar4 = FUN_004284f0(param_1 + 0x58e);
  *(undefined4 *)(param_1 + 0x1594) = 0x3eeb851f;
  *(undefined4 *)(param_1 + 0x159c) = 0x3ee147ae;
  fVar1 = *(float *)(iVar4 + 0x1b4);
  bVar2 = NAN(_DAT_006ea454);
  bVar3 = fVar1 < _DAT_006ea454;
  *(undefined4 *)(param_1 + 0x15a8) = 0;
  if (bVar3 != (NAN(fVar1) || bVar2)) {
    *(undefined4 *)(param_1 + 0x1598) = 0xbe4ccccd;
    *(undefined4 *)(param_1 + 0x15a4) = 0xbfa66666;
    *(undefined4 *)(param_1 + 0x15a0) = 0x3dcccccd;
    *(undefined4 *)(param_1 + 0x15a4) = 0xbfa66666;
    return;
  }
  *(undefined4 *)(param_1 + 0x1598) = 0x3e4ccccd;
  *(undefined4 *)(param_1 + 0x15a0) = 0xbdcccccd;
  *(undefined4 *)(param_1 + 0x15a4) = 0xbfa66666;
  return;
}

