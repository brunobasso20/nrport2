/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00401ab0 */

void __fastcall FUN_00401ab0(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  
  iVar1 = *(int *)(param_1 + 0x5b2);
  iVar2 = FUN_00413e20();
  if ((iVar1 < 0) || (0x2f < iVar1)) {
    uVar3 = 0xffffffff;
  }
  else {
    uVar3 = *(undefined4 *)(iVar2 + iVar1 * 0xd + 0x188);
  }
  *(undefined4 *)(param_1 + 0x1afe) = uVar3;
  iVar2 = FUN_00413e20();
  if ((-1 < iVar1) && (iVar1 < 0x30)) {
    *(undefined4 *)(param_1 + 0x1b02) = *(undefined4 *)(iVar2 + iVar1 * 0xd + 0x18c);
    return;
  }
  *(undefined4 *)(param_1 + 0x1b02) = 0xffffffff;
  return;
}


