/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571320 */

undefined4 FUN_00571320(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f4ec);
  if (cVar1 != '\0') {
    puVar3 = &DAT_00c67eb0;
    for (iVar2 = 0x62; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    FUN_005f8e20(&DAT_00c5f4ec);
    return 1;
  }
  return 0;
}


