/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052e740 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_0052e740(int param_1)

{
  float fVar1;
  int iVar2;
  uint uVar3;
  ushort uVar4;
  
  iVar2 = FUN_00567610(*(undefined4 *)(param_1 + 0x5b2));
  fVar1 = *(float *)(iVar2 + 0x28);
  uVar3 = (uint)(fVar1 < _DAT_006ea44c) << 8;
  if (fVar1 < _DAT_006ea44c == 0) {
    uVar4 = (ushort)(fVar1 < _DAT_006e97d8) << 8 | (ushort)(NAN(fVar1) || NAN(_DAT_006e97d8)) << 10
            | (ushort)(fVar1 == _DAT_006e97d8) << 0xe;
    uVar3 = (uint)uVar4;
    if (fVar1 < _DAT_006e97d8 != (fVar1 == _DAT_006e97d8)) {
      return CONCAT31((uint3)(byte)(uVar4 >> 8),1);
    }
  }
  return uVar3;
}


