/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051236a */

undefined4 FUN_0051236a(int *param_1,undefined4 param_2)

{
  int *piVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  
  iVar3 = 0;
  iVar4 = *param_1;
  piVar1 = param_1;
  if (0 < iVar4) {
    do {
      iVar3 = iVar3 + 1;
      cVar2 = FUN_005123ca(piVar1[1],piVar1[9],param_1[iVar3 % iVar4 + 1],param_1[iVar3 % iVar4 + 9]
                           ,param_2);
      if (cVar2 != '\0') {
        return 1;
      }
      iVar4 = *param_1;
      piVar1 = piVar1 + 1;
    } while (iVar3 < iVar4);
  }
  return 0;
}


