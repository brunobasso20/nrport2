/* NR2003.exe @ 005bdd50 FUN_005bdd50 */

int FUN_005bdd50(int param_1)

{
  int iVar1;
  
  iVar1 = 0;
  if (param_1 != 0) {
    do {
      param_1 = *(int *)(param_1 + 8);
      iVar1 = iVar1 + 1;
    } while (param_1 != 0);
  }
  return iVar1;
}

