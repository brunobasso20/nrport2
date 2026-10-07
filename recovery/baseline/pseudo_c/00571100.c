/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00571100 */

undefined4 FUN_00571100(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  if (param_1 != (undefined4 *)0x0) {
    cVar1 = FUN_005f8da0(&DAT_00c6b480);
    if (cVar1 != '\0') {
      puVar3 = (undefined4 *)&DAT_00c680b0;
      for (iVar2 = 0x3bf; iVar2 != 0; iVar2 = iVar2 + -1) {
        *puVar3 = *param_1;
        param_1 = param_1 + 1;
        puVar3 = puVar3 + 1;
      }
      *(undefined2 *)puVar3 = *(undefined2 *)param_1;
      FUN_005f8e20(&DAT_00c6b480);
      return 1;
    }
  }
  return 0;
}


