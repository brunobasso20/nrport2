/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005715d0 */

undefined4 FUN_005715d0(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c6f6e4);
  if (cVar1 != '\0') {
    puVar3 = &DAT_00c6f910;
    for (iVar2 = 0x18; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    FUN_005f8e20(&DAT_00c6f6e4);
    return 1;
  }
  return 0;
}


