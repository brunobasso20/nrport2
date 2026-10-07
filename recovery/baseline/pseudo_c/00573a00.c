/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573a00 */

void FUN_00573a00(undefined1 *param_1,char *param_2)

{
  char cVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  char *pcVar5;
  
  uVar3 = 0xffffffff;
  pcVar5 = param_2;
  do {
    if (uVar3 == 0) break;
    uVar3 = uVar3 - 1;
    cVar1 = *pcVar5;
    pcVar5 = pcVar5 + 1;
  } while (cVar1 != '\0');
  param_1[~uVar3 + 1] = 0;
  iVar2 = ~uVar3 - 2;
  while( true ) {
    if (iVar2 < 0) {
      *param_1 = 99;
      param_1[1] = 0x5f;
      return;
    }
    cVar1 = param_2[iVar2];
    if ((cVar1 == '\\') || (cVar1 == ':')) break;
    param_1[iVar2 + 2] = cVar1;
    iVar2 = iVar2 + -1;
  }
  param_1[iVar2] = cVar1;
  param_1[iVar2 + 1] = 99;
  param_1[iVar2 + 2] = 0x5f;
  if (iVar2 < 1) {
    return;
  }
  iVar4 = (int)param_2 - (int)param_1;
  do {
    *param_1 = param_1[iVar4];
    param_1 = param_1 + 1;
    iVar2 = iVar2 + -1;
  } while (iVar2 != 0);
  return;
}


