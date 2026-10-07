/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f71b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f71b0(int param_1_00,float param_1)

{
  bool bVar1;
  
  bVar1 = param_1 < _DAT_006ea454;
  *(float *)(param_1_00 + 0x198) = param_1;
  if (bVar1) {
    *(undefined4 *)(param_1_00 + 0x198) = 0;
  }
  if (_DAT_006e97d8 < *(float *)(param_1_00 + 0x198)) {
    *(undefined4 *)(param_1_00 + 0x198) = 0x3f800000;
  }
  FUN_004f6e90();
  return;
}


