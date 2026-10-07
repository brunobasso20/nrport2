/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570460 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_00570460(undefined4 param_1,undefined4 param_2,undefined1 param_3,undefined2 param_4,
            undefined2 param_5,undefined4 param_6,undefined4 param_7,undefined4 param_8)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c68098);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c70a8c;
    for (iVar2 = 0xd; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = 0;
    _DAT_00c70abd = param_1;
    FUN_006c4b00(&DAT_00c70a8c,param_2,0x1f);
    DAT_00c70aac = param_3;
    _DAT_00c70aad = param_4;
    _DAT_00c70aaf = param_5;
    _DAT_00c70ab1 = param_6;
    _DAT_00c70ab5 = param_7;
    _DAT_00c70ab9 = param_8;
    FUN_005f8e20(&DAT_00c68098);
    return 1;
  }
  return 0;
}


