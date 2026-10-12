/* NR2003.exe @ 0059aa50 FUN_0059aa50 */

void FUN_0059aa50(int param_1)

{
  undefined4 uVar1;
  int iVar2;
  int *piVar3;
  
  uVar1 = DAT_00ebbd7c;
  if (DAT_00ebbd84 != '\0') {
    if (*(int *)(param_1 + 0x1db) != 0) {
      (***(code ***)(*(int *)(param_1 + 0x1db) + 4))(DAT_00ebbd7c);
    }
    iVar2 = 0;
    if (0 < *(int *)(param_1 + 0x1e3)) {
      piVar3 = (int *)(param_1 + 0x1ca4);
      do {
        (***(code ***)(*piVar3 + 4))(uVar1);
        iVar2 = iVar2 + 1;
        piVar3 = piVar3 + 1;
      } while (iVar2 < *(int *)(param_1 + 0x1e3));
    }
    (**(code **)**(undefined4 **)(param_1 + 0x5c))(uVar1);
  }
  return;
}

