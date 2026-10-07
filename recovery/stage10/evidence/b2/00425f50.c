/* NR2003.exe @ 00425f50 FUN_00425f50 */

void FUN_00425f50(char *param_1)

{
  char *pcVar1;
  char cVar2;
  int iVar3;
  undefined4 unaff_ESI;
  
  cVar2 = *param_1;
  while (cVar2 != '\0') {
    iVar3 = FUN_006c4d21((int)cVar2,unaff_ESI);
    if (iVar3 == 0) {
      *param_1 = '_';
    }
    pcVar1 = param_1 + 1;
    param_1 = param_1 + 1;
    cVar2 = *pcVar1;
  }
  return;
}

