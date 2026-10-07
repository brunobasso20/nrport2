/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570ba0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00570ba0(undefined4 *param_1,undefined4 *param_2)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c6faf4);
  if (cVar1 != '\0') {
    _DAT_00c70b40 = 3;
    puVar3 = (undefined4 *)&DAT_00c70b44;
    for (iVar2 = 8; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_2;
      param_2 = param_2 + 1;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = *(undefined1 *)param_2;
    puVar3 = (undefined4 *)&DAT_00c70bd8;
    for (iVar2 = 0x39; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    *(undefined2 *)puVar3 = *(undefined2 *)param_1;
    FUN_005f8e20(&DAT_00c6faf4);
    return 1;
  }
  return 0;
}


