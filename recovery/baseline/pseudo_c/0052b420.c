/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052b420 */

void __fastcall FUN_0052b420(int param_1)

{
  char cVar1;
  int iVar2;
  
  cVar1 = FUN_0052ab90(param_1);
  if ((cVar1 != '\0') && (iVar2 = FUN_005099b0(), iVar2 != 5)) {
    if (*(int *)(param_1 + 8) == 0) {
      iVar2 = 0;
    }
    else {
      iVar2 = *(int *)(param_1 + 8) + -4;
    }
    while ((iVar2 != param_1 && (cVar1 = FUN_0052a360(param_1,iVar2), cVar1 == '\0'))) {
      cVar1 = FUN_0052bee0(iVar2);
      if ((cVar1 != '\0') && (cVar1 = FUN_0052a860(iVar2,param_1), cVar1 != '\0')) {
        if (*(char *)(iVar2 + 0x59b) != '\0') {
          (**(code **)(**(int **)(iVar2 + 0x13a7) + 0x18))(iVar2,param_1);
        }
        if (*(char *)(param_1 + 0x59b) != '\0') {
          (**(code **)(**(int **)(param_1 + 0x13a7) + 0x24))(param_1,iVar2);
        }
      }
      if (*(int *)(iVar2 + 8) == 0) {
        iVar2 = 0;
      }
      else {
        iVar2 = *(int *)(iVar2 + 8) + -4;
      }
    }
  }
  return;
}


