/* NR2003.exe @ 0054b840 FUN_0054b840 */

void __thiscall FUN_0054b840(int param_1_00,undefined4 param_1)

{
  uint uVar1;
  int iVar2;
  
  uVar1 = *(uint *)(param_1_00 + 0xc);
  iVar2 = FUN_006c5018();
  *(uint *)(param_1_00 + 0xc) = (iVar2 << 8 ^ uVar1) & 0x300 ^ uVar1;
  *(undefined4 *)(param_1_00 + 0x60) = param_1;
  return;
}

