/* NR2003.exe @ 00520330 FUN_00520330 */

void __thiscall FUN_00520330(int param_1_00,char param_1)

{
  char cVar1;
  float *pfVar2;
  int iVar3;
  float10 fVar4;
  
  if ((*(char *)(*(int *)(param_1_00 + 5) + 0x10d) == '\0') ||
     (*(char *)(*(int *)(param_1_00 + 5) + 0x111) == '\0')) {
    *(undefined *)(param_1_00 + 10) = 0;
  }
  else {
    iVar3 = 0;
    pfVar2 = (float *)(param_1_00 + 0xf);
    do {
      fVar4 = (float10)FUN_00520910(iVar3,0);
      *pfVar2 = (float)fVar4;
      iVar3 = iVar3 + 1;
      pfVar2 = pfVar2 + 1;
    } while (iVar3 < 0x1b);
    cVar1 = FUN_00520e50();
    if (cVar1 != '\0') {
      *(undefined *)(param_1_00 + 10) = 1;
      return;
    }
    cVar1 = *(char *)(param_1_00 + 10);
    *(char *)(param_1_00 + 10) = param_1;
    if (*(char *)(param_1_00 + 9) != '\0') {
      if (cVar1 == '\0') {
        if (param_1 != '\0') {
          *(char *)(*(int *)(param_1_00 + 5) + 0xb3f) =
               *(char *)(*(int *)(param_1_00 + 5) + 0xb3f) + '\x01';
          return;
        }
      }
      else if (param_1 == '\0') {
        *(char *)(*(int *)(param_1_00 + 5) + 0xb3f) =
             *(char *)(*(int *)(param_1_00 + 5) + 0xb3f) + -1;
        return;
      }
    }
  }
  return;
}

