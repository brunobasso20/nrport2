/* NR2003.exe @ 0057c410 FUN_0057c410 */

undefined4 FUN_0057c410(int *param_1,int param_2,int *param_3)

{
  int iVar1;
  int *piVar2;
  
  if (param_2 < 0xd7) {
    piVar2 = (int *)((int)&DAT_00d37cc8 + param_2 * 0x1d);
    do {
      if (((piVar2 + -4 != param_3) && ((piVar2[-2] & param_3[2]) != 0)) &&
         (iVar1 = *piVar2, iVar1 == param_3[4])) {
        if (((iVar1 == 1) && (piVar2[1] == param_3[5])) &&
           (*(char *)(piVar2 + 3) == *(char *)(param_3 + 7))) {
          *param_1 = param_2;
          return 1;
        }
        if (((iVar1 == 2) && (piVar2[1] == param_3[5])) && (piVar2[2] == param_3[6])) {
          *param_1 = param_2;
          return 1;
        }
        if (((iVar1 == 4) && (piVar2[1] == param_3[5])) && (piVar2[2] == param_3[6])) {
          *param_1 = param_2;
          return 1;
        }
      }
      piVar2 = (int *)((int)piVar2 + 0x1d);
      param_2 = param_2 + 1;
    } while ((int)piVar2 < 0xd39523);
  }
  return 0;
}

