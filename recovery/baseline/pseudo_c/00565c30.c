/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00565c30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00565c30(int param_1)

{
  bool bVar1;
  int iVar2;
  
  iVar2 = FUN_004284f0(param_1 + 0x58e);
  *(undefined4 *)(param_1 + 0x1594) = 0x3eeb851f;
  *(undefined4 *)(param_1 + 0x159c) = 0x3ee147ae;
  bVar1 = *(float *)(iVar2 + 0x1b4) < _DAT_006ea454;
  *(undefined4 *)(param_1 + 0x15a8) = 0;
  if (bVar1) {
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


