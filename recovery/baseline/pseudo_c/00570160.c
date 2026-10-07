/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00570160 */

undefined4 FUN_00570160(undefined4 param_1,undefined1 param_2)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c70a78);
  if (cVar1 != '\0') {
    puVar3 = (undefined4 *)&DAT_00c69148;
    for (iVar2 = 8; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    *(undefined1 *)puVar3 = 0;
    FUN_006c4b00(&DAT_00c69148,param_1,0x1f);
    DAT_00c69168 = param_2;
    FUN_005f8e20(&DAT_00c70a78);
    return 1;
  }
  return 0;
}


