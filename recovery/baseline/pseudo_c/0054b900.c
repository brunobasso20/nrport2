/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054b900 */

void __thiscall FUN_0054b900(int param_1_00,undefined4 param_1)

{
  ushort uVar1;
  short sVar2;
  
  uVar1 = *(ushort *)(param_1_00 + 2);
  sVar2 = FUN_006c5018();
  *(ushort *)(param_1_00 + 2) = (sVar2 << 0xc ^ uVar1) & 0x3000 ^ uVar1;
  *(undefined4 *)(param_1_00 + 0x50) = param_1;
  return;
}


