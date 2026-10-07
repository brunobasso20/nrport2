/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056d700 */

void FUN_0056d700(void)

{
  undefined4 *puVar1;
  int iVar2;
  
  puVar1 = &DAT_00c5d8e4;
  iVar2 = 0x40;
  do {
    puVar1[-1] = 0;
    *puVar1 = 0;
    puVar1[1] = 0;
    *(undefined1 *)(puVar1 + 4) = 0;
    *(undefined1 *)((int)puVar1 + 0x11) = 0;
    *(undefined4 *)((int)puVar1 + 0x12) = 0;
    puVar1[-3] = &PTR_FUN_006ef59c;
    puVar1 = (undefined4 *)((int)puVar1 + 0x66);
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  return;
}


