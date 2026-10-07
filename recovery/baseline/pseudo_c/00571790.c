/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571790 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00571790(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c67734);
  if (cVar1 != '\0') {
    _DAT_00c6b5d8 = 1;
    _DAT_00c6b5dc = 3;
    puVar3 = &DAT_00c6b5e0;
    for (iVar2 = 8; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = *(undefined1 *)param_1;
    FUN_005f8e20(&DAT_00c67734);
    return 1;
  }
  return 0;
}


