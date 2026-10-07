/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005700d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_005700d0(undefined4 param_1,undefined1 param_2,undefined2 param_3,undefined2 param_4,
            undefined4 param_5,undefined4 param_6,undefined4 param_7)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c5f4c0);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c69248;
    for (iVar2 = 0xc; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = 0;
    FUN_006c4b00(&DAT_00c69248,param_1,0x1f);
    DAT_00c69268 = param_2;
    _DAT_00c69269 = param_3;
    _DAT_00c6926b = param_4;
    _DAT_00c6926d = param_5;
    _DAT_00c69271 = param_6;
    _DAT_00c69275 = param_7;
    FUN_005f8e20(&DAT_00c5f4c0);
    return 1;
  }
  return 0;
}


