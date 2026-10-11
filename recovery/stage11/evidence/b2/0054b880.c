/* NR2003.exe @ 0054b880 FUN_0054b880 */

void __thiscall FUN_0054b880(int param_1_00,undefined4 param_1)

{
  uint uVar1;
  int iVar2;
  
  uVar1 = *(uint *)(param_1_00 + 0xc);
  iVar2 = FUN_006c5018();
  *(uint *)(param_1_00 + 0xc) = (iVar2 << 6 ^ uVar1) & 0xc0 ^ uVar1;
  *(undefined4 *)(param_1_00 + 0x5c) = param_1;
  return;
}

