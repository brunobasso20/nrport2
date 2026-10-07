/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f5990 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_004f5990(void)

{
  undefined1 *puVar1;
  int iVar2;
  int *piVar3;
  int iVar4;
  
  iVar2 = 0;
  puVar1 = &DAT_00acdbb2;
  do {
    puVar1[-0xbe8] = 0;
    *puVar1 = 0;
    *(int *)(puVar1 + -0xbd0) = iVar2;
    *(undefined4 *)(puVar1 + 0x20d) = 0;
    puVar1 = puVar1 + 0x2214;
    iVar2 = iVar2 + 1;
  } while ((int)puVar1 < 0xb33f72);
  iVar2 = taskGetRate();
  iVar4 = 0;
  DAT_00b32e1c = (float)iVar2;
  piVar3 = &DAT_00b33090;
  iVar2 = 0x30;
  DAT_00b32e18 = _DAT_006e97d8 / DAT_00b32e1c;
  do {
    FUN_0059fa90();
    *piVar3 = iVar4;
    piVar3[0x2e] = 5000;
    iVar4 = iVar4 + 1;
    piVar3 = piVar3 + 0xcb;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  return;
}


