/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b6c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_0054b6c0(int param_1_00,int param_1,float param_2)

{
  float fVar1;
  int iVar2;
  uint uVar3;
  
  uVar3 = *(uint *)(param_1_00 + 8) &
          ~(*(int *)(&DAT_006f56bc + param_1 * 0x15) <<
           ((byte)*(undefined4 *)(&DAT_006f56b8 + param_1 * 0x15) & 0x1f));
  *(uint *)(param_1_00 + 8) = uVar3;
  if ((&DAT_006f56c0)[param_1 * 0x15] == '\0') {
    iVar2 = *(int *)(&DAT_006f56bc + param_1 * 0x15);
    fVar1 = _DAT_006e97d8;
    if (param_2 <= _DAT_006e97d8) {
      iVar2 = FUN_006c5018();
      fVar1 = _DAT_006e97d8;
    }
  }
  else if (param_2 == _DAT_006ea4a0) {
    iVar2 = *(int *)(&DAT_006f56bc + param_1 * 0x15);
    fVar1 = _DAT_006ea4a0;
  }
  else {
    iVar2 = FUN_006c5018();
    fVar1 = _DAT_006ea4a0;
  }
  if ((param_2 <= _DAT_006e97d8) && (fVar1 = param_2, param_2 < _DAT_006ea454)) {
    fVar1 = _DAT_006ea454;
  }
  *(uint *)(param_1_00 + 8) =
       iVar2 << ((byte)*(undefined4 *)(&DAT_006f56b8 + param_1 * 0x15) & 0x1f) | uVar3;
  *(float *)(param_1_00 + 0x10 + param_1 * 4) = fVar1;
  return;
}


