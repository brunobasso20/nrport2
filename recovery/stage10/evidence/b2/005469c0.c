/* NR2003.exe @ 005469c0 FUN_005469c0 */

void FUN_005469c0(char *param_1,undefined4 param_2,int param_3,int param_4)

{
  char cVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  undefined uVar5;
  short *psVar6;
  undefined4 *puVar7;
  char *pcVar8;
  char *pcVar9;
  undefined4 *puVar10;
  char *pcVar11;
  char acStack_10 [16];
  
  FUN_006c4f81(param_1,&DAT_0074c8a4,param_3);
  if (0 < param_3) {
    psVar6 = (short *)(param_4 + 2);
    do {
      switch(psVar6[-1]) {
      case 2:
        uVar5 = 0x54;
        break;
      case 3:
        uVar5 = 0x43;
        break;
      case 4:
        uVar5 = 0x50;
        break;
      case 5:
        uVar5 = 0x51;
        break;
      case 6:
        uVar5 = 0x4f;
        break;
      case 7:
        uVar5 = 0x52;
        break;
      default:
        uVar5 = 0x3f;
      }
      if (*psVar6 == 0x7fff) {
        iVar4 = FUN_006c5018();
        pcVar11 = s__c_dS_0074c8b0;
      }
      else {
        iVar4 = (int)*psVar6;
        pcVar11 = s__c_dL_0074c8a8;
      }
      FUN_006c4f81(acStack_10,pcVar11,uVar5,iVar4);
      uVar2 = 0xffffffff;
      pcVar11 = acStack_10;
      do {
        pcVar8 = pcVar11;
        if (uVar2 == 0) break;
        uVar2 = uVar2 - 1;
        pcVar8 = pcVar11 + 1;
        cVar1 = *pcVar11;
        pcVar11 = pcVar8;
      } while (cVar1 != '\0');
      uVar2 = ~uVar2;
      psVar6 = psVar6 + 4;
      iVar4 = -1;
      pcVar11 = param_1;
      do {
        pcVar9 = pcVar11;
        if (iVar4 == 0) break;
        iVar4 = iVar4 + -1;
        pcVar9 = pcVar11 + 1;
        cVar1 = *pcVar11;
        pcVar11 = pcVar9;
      } while (cVar1 != '\0');
      puVar7 = (undefined4 *)(pcVar8 + -uVar2);
      puVar10 = (undefined4 *)(pcVar9 + -1);
      for (uVar3 = uVar2 >> 2; uVar3 != 0; uVar3 = uVar3 - 1) {
        *puVar10 = *puVar7;
        puVar7 = puVar7 + 1;
        puVar10 = puVar10 + 1;
      }
      param_3 = param_3 + -1;
      for (uVar2 = uVar2 & 3; uVar2 != 0; uVar2 = uVar2 - 1) {
        *(undefined *)puVar10 = *(undefined *)puVar7;
        puVar7 = (undefined4 *)((int)puVar7 + 1);
        puVar10 = (undefined4 *)((int)puVar10 + 1);
      }
    } while (param_3 != 0);
  }
  return;
}

