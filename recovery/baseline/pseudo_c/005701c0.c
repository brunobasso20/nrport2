/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005701c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
FUN_005701c0(undefined4 param_1,undefined2 param_2,undefined2 param_3,undefined2 param_4,
            undefined1 param_5,undefined4 param_6,undefined4 param_7)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c70dc0);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c69330;
    for (iVar2 = 0x403; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined2 *)puVar3 = 0;
    *(undefined1 *)((int)puVar3 + 2) = 0;
    FUN_006c51dd(&DAT_00c69330,param_1,0x7ff);
    _DAT_00c6a330 = param_2;
    _DAT_00c6a332 = param_3;
    _DAT_00c6a334 = param_4;
    DAT_00c6a336 = param_5;
    _DAT_00c6a337 = param_6;
    _DAT_00c6a33b = param_7;
    FUN_005f8e20(&DAT_00c70dc0);
    return 1;
  }
  return 0;
}


