/* NR2003.exe @ 00411530 FUN_00411530 */

undefined4 FUN_00411530(int param_1)

{
  int iVar1;
  
  iVar1 = FUN_0055a680();
  if ((*(uint *)(iVar1 + 0x4c) & 0x80000) != 0) {
    return 1;
  }
  return *(undefined4 *)(&DAT_006ec798 + param_1 * 4);
}

