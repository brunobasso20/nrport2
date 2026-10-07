/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00535490 */

int FUN_00535490(int param_1)

{
  int iVar1;
  uint3 uVar2;
  
  iVar1 = *(int *)(param_1 + 0x5ae);
  uVar2 = (uint3)((uint)iVar1 >> 8);
  if ((iVar1 != 0) && (*(int *)(iVar1 + 0x50) == 1)) {
    return CONCAT31(uVar2,1);
  }
  return (uint)uVar2 << 8;
}


