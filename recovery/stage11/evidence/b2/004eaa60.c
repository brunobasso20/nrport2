/* NR2003.exe @ 004eaa60 FUN_004eaa60 */

undefined4 FUN_004eaa60(int param_1,int param_2,int param_3)

{
  int iVar1;
  int *piVar2;
  int iVar3;
  
  if (param_3 < 0) {
    param_3 = 0;
    if (0 < param_2) {
      do {
        iVar1 = *(int *)(param_1 + param_3 * 4);
        if (iVar1 != 0) {
          iVar3 = 0;
          piVar2 = (int *)(iVar1 + 0x3a0);
          do {
            if ((piVar2[-0x44] != 0) || (*piVar2 != 0)) {
              if (param_3 < param_2) goto LAB_004eaad1;
              goto LAB_004eaaac;
            }
            iVar3 = iVar3 + 1;
            piVar2 = piVar2 + 0x11;
          } while (iVar3 < 2);
        }
        param_3 = param_3 + 1;
      } while (param_3 < param_2);
    }
LAB_004eaaac:
    param_3 = 0;
    if (0 < param_2) {
      do {
        iVar1 = *(int *)(param_1 + param_3 * 4);
        if ((iVar1 != 0) && (*(int *)(iVar1 + 0x10) == 0)) goto LAB_004eaacd;
        param_3 = param_3 + 1;
      } while (param_3 < param_2);
    }
  }
  else {
LAB_004eaacd:
    if (param_3 < param_2) {
LAB_004eaad1:
      if (((-1 < param_3) && (iVar1 = *(int *)(param_1 + param_3 * 4), iVar1 != 0)) &&
         (*(int *)(iVar1 + 0x10) == 0)) {
        FUN_004eabf0();
        iVar3 = 0;
        if (0 < param_2) {
          do {
            if ((iVar3 != param_3) && (*(int *)(param_1 + iVar3 * 4) != 0)) {
              FUN_004eac10(*(undefined4 *)(iVar1 + 0x14));
            }
            iVar3 = iVar3 + 1;
          } while (iVar3 < param_2);
        }
        return 1;
      }
    }
  }
  return 0;
}

