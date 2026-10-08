/* NR2003.exe @ 0054b4f0 FUN_0054b4f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_0054b4f0(int param_1_00,float param_1)

{
  uint in_EAX;
  ushort uVar1;
  
  if ((*(uint *)(param_1_00 + 0xc) & 0x2000000) != 0) {
    if (param_1 < _DAT_006ea454) {
      param_1 = _DAT_006ea454;
    }
    param_1 = param_1 + *(float *)(param_1_00 + 100);
    *(float *)(param_1_00 + 100) = param_1;
    uVar1 = (ushort)(param_1 < _DAT_006f5878) << 8 | (ushort)(param_1 == _DAT_006f5878) << 0xe;
    in_EAX = (uint)uVar1;
    if (param_1 >= _DAT_006f5878 && param_1 != _DAT_006f5878) {
      *(undefined4 *)(param_1_00 + 100) = 0;
      *(uint *)(param_1_00 + 0xc) = *(uint *)(param_1_00 + 0xc) & 0xfdffffff;
      return CONCAT31((uint3)(byte)(uVar1 >> 8),1);
    }
  }
  return in_EAX & 0xffffff00;
}

