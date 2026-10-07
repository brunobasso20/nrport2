/* NR2003.exe @ 005bdc60 FUN_005bdc60 */

int * FUN_005bdc60(int *param_1)

{
  int iVar1;
  int *piVar2;
  int *piVar3;
  uint extraout_ECX;
  
  piVar2 = param_1;
  iVar1 = FUN_005bd610(&param_1,param_1);
  if (iVar1 != 0) {
    return param_1;
  }
  iVar1 = FUN_005bd200(piVar2);
  if ((extraout_ECX & 2) == 0) {
    if (iVar1 != 0) {
      return (int *)((int)extraout_ECX >> 2);
    }
    if (1 < piVar2[3]) {
      piVar2 = (int *)FUN_005bd5a0();
      return piVar2;
    }
    piVar3 = (int *)0x0;
  }
  else {
    if (iVar1 == 0) {
      piVar2 = (int *)FUN_005bd5a0();
      return piVar2;
    }
    iVar1 = FUN_005bdd00((int *)((int)extraout_ECX >> 2));
    piVar3 = (int *)(*piVar2 >> 2);
    if (iVar1 != 0) {
      return piVar3;
    }
    if (((&DAT_00ec02c8)[(int)piVar3] == 0) && ((int *)(&DAT_00ed7840)[(int)piVar3] != piVar2)) {
      piVar2 = (int *)FUN_005bd5a0();
      return piVar2;
    }
  }
  return piVar3;
}

