/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005846d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005846d0(int param_1,int param_2)

{
  undefined1 uVar1;
  
  *(byte *)(param_1 + 1) =
       (byte)(*(uint *)(param_2 + 0x18) >> 0xb) & 0x1c | (byte)(*(uint *)(param_2 + 0x18) >> 6) & 3
       | *(byte *)(param_2 + 0x1a) & 0xe0;
  if (_DAT_006f6870 <= *(float *)(param_2 + 0x14)) {
    *(undefined1 *)(param_1 + 2) = 0xff;
    return;
  }
  uVar1 = FUN_006c5018();
  *(undefined1 *)(param_1 + 2) = uVar1;
  return;
}


