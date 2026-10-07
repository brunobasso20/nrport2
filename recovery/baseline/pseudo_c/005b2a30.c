/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b2a30 */

void FUN_005b2a30(int param_1,byte *param_2,byte *param_3,int param_4)

{
  byte bVar1;
  byte *pbVar2;
  int iVar3;
  byte *pbVar4;
  bool bVar5;
  
  do {
    pbVar2 = param_2;
    pbVar4 = param_3;
    if (param_4 < 1) {
      FUN_005b2af0(param_1);
      return;
    }
    do {
      bVar1 = *pbVar2;
      bVar5 = bVar1 < *pbVar4;
      if (bVar1 != *pbVar4) {
LAB_005b2a6c:
        iVar3 = (1 - (uint)bVar5) - (uint)(bVar5 != 0);
        goto LAB_005b2a71;
      }
      if (bVar1 == 0) break;
      bVar1 = pbVar2[1];
      bVar5 = bVar1 < pbVar4[1];
      if (bVar1 != pbVar4[1]) goto LAB_005b2a6c;
      pbVar2 = pbVar2 + 2;
      pbVar4 = pbVar4 + 2;
    } while (bVar1 != 0);
    iVar3 = 0;
LAB_005b2a71:
    if (iVar3 == 0) {
      *(byte **)(param_1 + 0x6d) = param_3;
      if (*(int *)(param_3 + 0x75) != 0) {
        FUN_005b2ac0(param_1,*(int *)(param_3 + 0x75));
        return;
      }
      *(int *)(param_3 + 0x75) = param_1;
      return;
    }
    param_4 = param_4 + -1;
    param_3 = param_3 + 0x505;
  } while( true );
}


