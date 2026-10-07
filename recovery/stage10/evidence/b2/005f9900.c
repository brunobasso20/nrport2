/* NR2003.exe @ 005f9900 FUN_005f9900 */

int FUN_005f9900(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  char *pcVar4;
  int in_stack_00001110;
  undefined2 *in_stack_00001114;
  
  FUN_006c5af0();
  if (in_stack_00001114 == (undefined2 *)0x0) {
    return 0;
  }
  if (in_stack_00001110 == 0) {
    *in_stack_00001114 = 0;
    return 1;
  }
  iVar3 = 0;
  iVar2 = FUN_005f9820();
  if (iVar2 != 0) {
    iVar2 = FUN_01014b60();
    if (iVar2 != 0) {
      iVar2 = -1;
      pcVar4 = (char *)0x0;
      do {
        if (iVar2 == 0) break;
        iVar2 = iVar2 + -1;
        cVar1 = *pcVar4;
        pcVar4 = pcVar4 + 1;
      } while (cVar1 != '\0');
      FUN_005faa20();
      iVar3 = 1;
    }
    FUN_01014be0();
    if (iVar3 == 0) {
      *in_stack_00001114 = 0;
    }
  }
  return iVar3;
}

