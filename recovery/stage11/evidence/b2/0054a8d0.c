/* NR2003.exe @ 0054a8d0 FUN_0054a8d0 */

void FUN_0054a8d0(int param_1,int param_2,char param_3)

{
  bool bVar1;
  char cVar2;
  uint uVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  int iVar7;
  undefined4 uVar8;
  
  if (param_3 == '\0') {
    uVar3 = *(uint *)(param_1 + 0xc);
  }
  else {
    uVar3 = *(uint *)(param_1 + 8);
  }
  if (((uVar3 & 0xffffff) == 0x13) || ((uVar3 & 0x2000000) != 0)) {
    if ((*(int *)(param_1 + 0x54) == 0) || (*(int *)(*(int *)(param_1 + 0x54) + 0x1a4) != param_2))
    {
      iVar4 = param_1 + 0x1c;
    }
    else {
      iVar4 = param_1 + 0x28;
    }
    iVar4 = FUN_0054a710(param_2,iVar4);
    if ((iVar4 != -1) && (iVar4 = *(int *)(&DAT_006f5500 + iVar4 * 0x20), iVar4 != -1)) {
      bVar1 = inBackground();
      if (bVar1) {
        uVar5 = FUN_00562f70();
        uVar6 = FUN_00592db0(uVar5);
        cVar2 = FUN_0054aa20(param_2,uVar6,param_1,iVar4);
        if (cVar2 != '\0') {
          iVar4 = FUN_0055ab00();
          uVar8 = DAT_00c7e75c;
          if (param_2 != iVar4) {
            uVar8 = (&DAT_00883500)[param_2];
          }
          FUN_00592dc0(uVar5,1);
          FUN_0054b0d0(uVar6,uVar8,0);
          return;
        }
      }
      else {
        iVar7 = FUN_004f5970(param_2);
        uVar5 = FUN_00567630(param_2);
        cVar2 = FUN_0054aa20(param_2,uVar5,param_1,iVar4);
        if (cVar2 != '\0') {
          iVar4 = FUN_0055ab00();
          uVar6 = DAT_00c7e75c;
          if ((param_2 != iVar4) &&
             (uVar6 = (&DAT_00883500)[param_2], *(char *)(iVar7 + 0x59b) != '\0')) {
            uVar8 = FUN_00567610(param_2);
            FUN_0052e270(uVar8,uVar5);
          }
          FUN_00567660(param_2);
          FUN_0054b0d0(uVar5,uVar6,0);
        }
      }
    }
  }
  return;
}

