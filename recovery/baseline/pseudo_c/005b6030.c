/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b6030 */

undefined4
FUN_005b6030(undefined4 *param_1,undefined4 *param_2,int param_3,int param_4,char *param_5)

{
  char cVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  char *pcVar5;
  char *pcVar6;
  char *apcStack_50 [4];
  char cStack_40;
  char acStack_3f [31];
  undefined1 local_20 [32];
  
  pcVar5 = param_5;
  uVar3 = 0xffffffff;
  pcVar6 = param_5;
  do {
    if (uVar3 == 0) break;
    uVar3 = uVar3 - 1;
    cVar1 = *pcVar6;
    pcVar6 = pcVar6 + 1;
  } while (cVar1 != '\0');
  if ((int)(~uVar3 - 1) < param_4) {
    FUN_006c4f81(local_20,&DAT_00752310);
    iVar2 = FUN_006c4ac9(pcVar5,local_20,&param_5,&cStack_40,param_3);
    if (iVar2 == 3) {
      *(undefined1 *)(param_3 + -1 + param_4) = 0;
      apcStack_50[0] = &DAT_00723544;
      apcStack_50[1] = s__01d_0072353c;
      apcStack_50[2] = s__02d_00723534;
      apcStack_50[3] = &DAT_0072352c;
      pcVar5 = &cStack_40;
      while ((cStack_40 != '\0' && ((cStack_40 < '0' || ('9' < cStack_40))))) {
        pcVar6 = pcVar5 + 1;
        pcVar5 = pcVar5 + 1;
        cStack_40 = *pcVar6;
      }
      cVar1 = *pcVar5;
      iVar4 = 0;
      iVar2 = 0;
      if (cVar1 != '\0') {
        do {
          if ((cVar1 < '0') || ('9' < cVar1)) {
            if (*pcVar5 != '\0') goto LAB_005b615a;
            break;
          }
          pcVar5 = pcVar5 + 1;
          iVar4 = iVar4 + 1;
          iVar2 = cVar1 + -0x30 + iVar2 * 10;
          cVar1 = *pcVar5;
        } while (cVar1 != '\0');
        if ((0 < iVar4) && (iVar4 < 4)) {
          if (((iVar4 == 1) || ((9 < iVar2 && (iVar4 == 2)))) || ((99 < iVar2 && (iVar4 == 3)))) {
            iVar4 = 0;
          }
          pcVar5 = apcStack_50[iVar4];
          param_1[1] = iVar2 + iVar4 * 1000;
          *param_1 = 0;
          FUN_006c4f81(param_1,pcVar5,iVar2);
          *param_2 = param_5;
          return 1;
        }
      }
LAB_005b615a:
      param_1[1] = 0xffffffff;
      *param_1 = 0;
      *param_2 = param_5;
      return 1;
    }
  }
  return 0;
}


