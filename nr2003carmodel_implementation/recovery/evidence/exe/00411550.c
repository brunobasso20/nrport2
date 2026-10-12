/* NR2003.exe @ 00411550 FUN_00411550 */

undefined4 FUN_00411550(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_0055a680();
  if ((*(uint *)(iVar1 + 0x4c) & 0x80000) != 0) {
    return 1;
  }
  return *(undefined4 *)(&DAT_006ec7f0 + param_1 * 4);
}

