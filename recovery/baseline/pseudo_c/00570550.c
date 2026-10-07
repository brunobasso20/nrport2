/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570550 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_00570550(undefined4 param_1,undefined4 param_2,undefined2 param_3,undefined2 param_4,
            undefined2 param_5,undefined1 param_6,undefined4 param_7,undefined4 param_8)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c691f8);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c6a438;
    for (iVar2 = 0x404; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined2 *)puVar3 = 0;
    *(undefined1 *)((int)puVar3 + 2) = 0;
    _DAT_00c6b447 = param_1;
    FUN_006c51dd(&DAT_00c6a438,param_2,0x7ff);
    _DAT_00c6b438 = param_3;
    _DAT_00c6b43a = param_4;
    _DAT_00c6b43c = param_5;
    DAT_00c6b43e = param_6;
    _DAT_00c6b43f = param_7;
    _DAT_00c6b443 = param_8;
    FUN_005f8e20(&DAT_00c691f8);
    return 1;
  }
  return 0;
}


