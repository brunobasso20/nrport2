/* NR2003.exe @ 005bef00 FUN_005bef00 */

undefined4 __fastcall FUN_005bef00(int param_1)

{
  int iVar1;
  
  *(undefined4 *)(param_1 + 0xc) = 0;
  *(undefined4 *)(param_1 + 0x10) = 0;
  *(undefined4 *)(param_1 + 0x5b6) = 0;
  iVar1 = FUN_005cff5a(param_1 + 8,0x15b8);
  if (iVar1 == 0) {
    return 0;
  }
  FUN_0059b7a0(param_1);
  iVar1 = FUN_0059bde0(param_1);
  if (iVar1 == 0) {
    return 0;
  }
  return 1;
}

