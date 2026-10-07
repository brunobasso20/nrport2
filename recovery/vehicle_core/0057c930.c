/* Ghidra pseudo-C; NR2003.exe @ 0057c930 */

void FUN_0057c930(void)

{
  int iVar1;
  undefined4 *puVar2;
  
  puVar2 = &DAT_00d3fe50;
  for (iVar1 = 5000; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  while ((undefined4 *)PTR_DAT_0074fd54 != &DAT_00d44c78) {
    PTR_DAT_0074fd54 = (undefined *)((int)PTR_DAT_0074fd54 + -4);
    **(undefined4 **)PTR_DAT_0074fd54 = 0;
  }
  FUN_005bcdd0();
  DAT_00d47d60 = 0;
  PTR_DAT_0074fd58 = (undefined *)&DAT_00d47ce8;
  return;
}

