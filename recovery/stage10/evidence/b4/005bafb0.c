/* NR2003.exe @ 005bafb0 FUN_005bafb0 */

void FUN_005bafb0(int *param_1)

{
  int iVar1;
  int *piVar2;
  
  iVar1 = 0;
  if (0 < *param_1) {
    piVar2 = param_1 + 1;
    do {
      FUN_0057c5d0(*piVar2,piVar2[1]);
      iVar1 = iVar1 + 1;
      piVar2 = piVar2 + 2;
    } while (iVar1 < *param_1);
  }
  iVar1 = 0;
  if (0 < *param_1) {
    piVar2 = param_1 + 1;
    do {
      if (piVar2[1] != 0) {
        FUN_0057a7e0(*piVar2);
      }
      iVar1 = iVar1 + 1;
      piVar2 = piVar2 + 2;
    } while (iVar1 < *param_1);
  }
  FUN_0057a740();
  return;
}

