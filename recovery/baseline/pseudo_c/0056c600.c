/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c600 */

void FUN_0056c600(char param_1,undefined4 param_2,undefined4 param_3)

{
  char cVar1;
  undefined4 uVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  char *pcVar6;
  int iStack_8;
  int iStack_4;
  
  iVar4 = FUN_005cfdc2(&param_2,param_2);
  if (iVar4 != 0) {
    iVar4 = FUN_005cfe22(param_2);
    iVar5 = FUN_005cfce4(&iStack_8,iVar4 + 1);
    if ((iVar5 != 0) && (iStack_4 = iStack_8, iStack_8 != 0)) {
      if ((0 < iVar4) && (iVar5 = FUN_005cfdb6(param_2,iStack_8,iVar4), iVar5 != 0)) {
        *(undefined1 *)(iStack_8 + iVar4) = 0;
        pcVar6 = (char *)FUN_006c5b47(iStack_8,&DAT_0074ee60);
        uVar2 = param_3;
        while (pcVar6 != (char *)0x0) {
          cVar1 = *pcVar6;
          if ((cVar1 == '-') || (cVar1 == '+')) {
            iVar4 = 1;
          }
          else {
            iVar4 = 0;
          }
          if ((((cVar1 != '-') || (param_1 != '\0')) &&
              (cVar3 = FUN_0056c340(pcVar6 + iVar4), cVar3 == '\0')) &&
             (iVar4 = FUN_0056c390(cVar1 != '-',pcVar6 + iVar4,uVar2), iVar4 == 0)) {
            DAT_00c5caf4 = 1;
          }
          pcVar6 = (char *)FUN_006c5b47(0,&DAT_0074ee60);
          iStack_8 = iStack_4;
        }
      }
      FUN_005cfccc(iStack_8);
    }
    FUN_005cfd08(param_2);
  }
  return;
}


