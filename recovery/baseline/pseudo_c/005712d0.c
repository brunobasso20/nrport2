/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005712d0 */

undefined4 FUN_005712d0(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  if (param_1 != (undefined4 *)0x0) {
    cVar1 = FUN_005f8da0(&DAT_00c6f6a4);
    if (cVar1 != '\0') {
      puVar3 = (undefined4 *)&DAT_00c5f518;
      for (iVar2 = 0x2b; iVar2 != 0; iVar2 = iVar2 + -1) {
        *puVar3 = *param_1;
        param_1 = param_1 + 1;
        puVar3 = puVar3 + 1;
      }
      *(undefined1 *)puVar3 = *(undefined1 *)param_1;
      FUN_005f8e20(&DAT_00c6f6a4);
      return 1;
    }
  }
  return 0;
}


