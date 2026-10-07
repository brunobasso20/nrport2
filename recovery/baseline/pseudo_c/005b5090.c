/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5090 */

int __fastcall FUN_005b5090(int param_1)

{
  undefined4 *puVar1;
  int iVar2;
  
  iVar2 = 0x400;
  puVar1 = (undefined4 *)(param_1 + 0x27);
  do {
    *puVar1 = 0x80000000;
    puVar1 = (undefined4 *)((int)puVar1 + 0x23);
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  FUN_005b50c0();
  return param_1;
}


