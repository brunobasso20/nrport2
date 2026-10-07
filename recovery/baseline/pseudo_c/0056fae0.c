/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056fae0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0056fae0(undefined4 param_1,undefined4 param_2,int param_3,undefined4 param_4)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  cVar1 = FUN_005f8da0(&DAT_00c6a3b4);
  if (cVar1 != '\0') {
    puVar3 = &DAT_00c67890;
    for (iVar2 = 0x182; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    FUN_006c4b00(&DAT_00c67990,param_1,0xff);
    FUN_006c4b00(&DAT_00c67890,param_2,0xff);
    if (param_3 != 0) {
      FUN_006c4b00(&DAT_00c67a90,param_3,0x403);
    }
    _DAT_00c67e94 = param_4;
    FUN_005f8e20(&DAT_00c6a3b4);
    return 1;
  }
  return 0;
}


