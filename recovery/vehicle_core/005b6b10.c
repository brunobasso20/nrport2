/* Ghidra pseudo-C; NR2003.exe @ 005b6b10 */

void FUN_005b6b10(char *param_1,int param_2,undefined4 param_3,char *param_4,byte param_5)

{
  char cVar1;
  char *pcVar2;
  char *pcVar3;
  char *pcVar4;
  int iVar5;
  
  pcVar3 = param_1;
  if (*(int *)(param_4 + 4) != -1) {
    iVar5 = 0;
    do {
      pcVar2 = (char *)FUN_00574370(iVar5);
      if ((pcVar2 != (char *)0x0) && (*(int *)(pcVar2 + 0x9c) == *(int *)(param_4 + 4))) {
        if (0x12 < param_2) {
          pcVar3 = pcVar2 + 0x24;
          *param_1 = '(';
          pcVar4 = param_1 + 1;
          if (*pcVar3 != '\0') {
            goto LAB_005b6b6e;
          }
          if (*pcVar2 != '\0') {
            *pcVar4 = *pcVar2;
            pcVar4 = param_1 + 2;
          }
          if (pcVar2[0x10] != '\0') {
            *pcVar4 = pcVar2[0x10];
            pcVar4 = pcVar4 + 1;
          }
          goto LAB_005b6b95;
        }
        break;
      }
      iVar5 = iVar5 + 1;
    } while (iVar5 < 0x30);
  }
  goto LAB_005b6bd6;
  while( true ) {
    *pcVar4 = *pcVar3;
    pcVar4 = pcVar4 + 1;
    pcVar3 = pcVar3 + 1;
    if (7 < (int)(pcVar3 + (-0x24 - (int)pcVar2))) break;
LAB_005b6b6e:
    if (*pcVar3 == '\0') break;
  }
LAB_005b6b95:
  cVar1 = *param_4;
  while (cVar1 == ' ') {
    pcVar3 = param_4 + 1;
    param_4 = param_4 + 1;
    cVar1 = *pcVar3;
  }
  *pcVar4 = '#';
  cVar1 = *param_4;
  while (pcVar3 = pcVar4 + 1, cVar1 != '\0') {
    *pcVar3 = cVar1;
    pcVar2 = param_4 + 1;
    param_4 = param_4 + 1;
    pcVar4 = pcVar3;
    cVar1 = *pcVar2;
  }
  *pcVar3 = ')';
  pcVar3 = pcVar4 + 2;
  if ((param_5 & 0x10) != 0) {
    *pcVar3 = '-';
    pcVar4[3] = '-';
    pcVar4[4] = '>';
    pcVar3 = pcVar4 + 5;
  }
  *pcVar3 = ' ';
  pcVar3 = pcVar3 + 1;
LAB_005b6bd6:
  FUN_006c4b00(pcVar3,param_3,param_1 + param_2 + (-1 - (int)pcVar3));
  param_1[param_2 + -1] = '\0';
  return;
}

