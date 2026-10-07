/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571610 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_00571610(char *param_1,char *param_2,undefined4 param_3,undefined4 *param_4,undefined4 *param_5,
            undefined1 param_6)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c6920c);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c690a0;
    for (iVar2 = 0x13; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = 0;
    if ((param_1 == (char *)0x0) || (*param_1 == '\0')) {
      DAT_00c690a0 = 0;
    }
    else {
      FUN_006c4b00(&DAT_00c690a0,param_1,0x20);
      DAT_00c690bf = 0;
    }
    if ((param_2 == (char *)0x0) || (*param_2 == '\0')) {
      DAT_00c690c0 = 0;
    }
    else {
      FUN_006c4b00(&DAT_00c690c0,param_2,0x20);
      DAT_00c690df = 0;
    }
    _DAT_00c690e0 = param_3;
    if (param_4 == (undefined4 *)0x0) {
      _DAT_00c690e4 = 0xffffffff;
    }
    else {
      _DAT_00c690e4 = *param_4;
    }
    if (param_5 == (undefined4 *)0x0) {
      _DAT_00c690e8 = 0xffffffff;
    }
    else {
      _DAT_00c690e8 = *param_5;
    }
    DAT_00c690ec = param_6;
    FUN_005f8e20(&DAT_00c6920c);
    return 1;
  }
  return 0;
}


