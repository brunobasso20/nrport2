/* NR2003.exe @ 00425ee0 FUN_00425ee0 */

void FUN_00425ee0(char *param_1,int param_2)

{
  char cVar1;
  int iVar2;
  int iVar3;
  uint uVar4;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  char *pcVar5;
  
  param_1[param_2 + -1] = '\0';
  cVar1 = *param_1;
  while ((cVar1 != '\0' && (iVar2 = FUN_006c4cd1((int)cVar1,unaff_EDI,unaff_ESI), iVar2 != 0))) {
    iVar2 = -1;
    pcVar5 = param_1 + 1;
    do {
      if (iVar2 == 0) break;
      iVar2 = iVar2 + -1;
      cVar1 = *pcVar5;
      pcVar5 = pcVar5 + 1;
    } while (cVar1 != '\0');
    FUN_006c5390();
    cVar1 = *param_1;
  }
  uVar4 = 0xffffffff;
  pcVar5 = param_1;
  do {
    if (uVar4 == 0) break;
    uVar4 = uVar4 - 1;
    cVar1 = *pcVar5;
    pcVar5 = pcVar5 + 1;
  } while (cVar1 != '\0');
  iVar2 = ~uVar4 - 1;
  while ((iVar2 != 0 &&
         (iVar3 = FUN_006c4cd1((int)param_1[iVar2 + -1],unaff_EDI,unaff_ESI), iVar3 != 0))) {
    iVar2 = iVar2 + -1;
    param_1[iVar2] = '\0';
  }
  return;
}

