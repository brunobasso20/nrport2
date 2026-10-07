/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005416d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_005416d0(int param_1)

{
  double dVar1;
  float fVar2;
  int iVar3;
  uint uVar4;
  
  *(double *)(param_1 + 0x88) = (double)DAT_0074b218;
  *(double *)(param_1 + 0x90) = (double)_DAT_0074b230;
  *(double *)(param_1 + 0x98) = (double)_DAT_0074b248;
  iVar3 = FUN_00544bf0();
  dVar1 = ((double)(*(uint *)(iVar3 + 0x50) & 3) + _DAT_006ef808) * _DAT_006f5468;
  *(double *)(param_1 + 0xa0) = (double)_DAT_0074b590 * dVar1;
  *(double *)(param_1 + 0xa8) = (double)_DAT_0074b5a8;
  *(double *)(param_1 + 0xb0) = (double)_DAT_0074b5c0 * dVar1;
  *(double *)(param_1 + 0xb8) = (double)_DAT_0074b5d8;
  iVar3 = FUN_00544bf0();
  uVar4 = *(uint *)(iVar3 + 0x4c) >> 0x14;
  *(byte *)(param_1 + 0xe8) = (byte)uVar4 & 1;
  fVar2 = _DAT_0074b5f0;
  if ((uVar4 & 1) == 0) {
    fVar2 = _DAT_0074b5f0 * _DAT_006e9824;
    *(undefined1 *)(param_1 + 0xe8) = 1;
  }
  *(double *)(param_1 + 0xc0) = (double)fVar2;
  *(double *)(param_1 + 200) = (*(double *)(param_1 + 0x98) + _DAT_006ef730) / (double)_DAT_00b8fa5c
  ;
  *(double *)(param_1 + 0xd0) = (double)_DAT_0074b608;
  *(double *)(param_1 + 0xd8) = (double)_DAT_0074b620;
  *(double *)(param_1 + 0xe0) = (double)_DAT_0074b638;
  return;
}


