/* NR2003.exe @ 0054b800 FUN_0054b800 */

void __thiscall FUN_0054b800(int param_1_00,undefined4 param_1)

{
  int iVar1;
  
  iVar1 = FUN_006c5018();
  *(undefined4 *)(param_1_00 + 0x54) = param_1;
  *(ushort *)(param_1_00 + 2) = *(ushort *)(param_1_00 + 2) & 0x3fff ^ (ushort)(iVar1 << 0xe);
  return;
}

