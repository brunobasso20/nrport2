/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005704f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005704f0(undefined4 param_1,undefined4 param_2,undefined1 param_3)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c69220);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c69290;
    for (iVar2 = 9; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = 0;
    _DAT_00c692b1 = param_1;
    FUN_006c4b00(&DAT_00c69290,param_2,0x1f);
    DAT_00c692b0 = param_3;
    FUN_005f8e20(&DAT_00c69220);
    return 1;
  }
  return 0;
}


