/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056e810 */

undefined4 __thiscall FUN_0056e810(byte *param_1_00,byte *param_1)

{
  byte bVar1;
  char cVar2;
  byte *pbVar3;
  int iVar4;
  byte *pbVar5;
  bool bVar6;
  
  pbVar3 = param_1_00;
  pbVar5 = param_1;
  do {
    bVar1 = *pbVar3;
    bVar6 = bVar1 < *pbVar5;
    if (bVar1 != *pbVar5) {
LAB_0056e847:
      iVar4 = (1 - (uint)bVar6) - (uint)(bVar6 != 0);
      goto LAB_0056e84c;
    }
    if (bVar1 == 0) break;
    bVar1 = pbVar3[1];
    bVar6 = bVar1 < pbVar5[1];
    if (bVar1 != pbVar5[1]) goto LAB_0056e847;
    pbVar3 = pbVar3 + 2;
    pbVar5 = pbVar5 + 2;
  } while (bVar1 != 0);
  iVar4 = 0;
LAB_0056e84c:
  if (iVar4 == 0) {
    pbVar3 = param_1 + 0x20;
    pbVar5 = param_1_00 + 0x20;
    do {
      bVar1 = *pbVar5;
      bVar6 = bVar1 < *pbVar3;
      if (bVar1 != *pbVar3) {
LAB_0056e87a:
        iVar4 = (1 - (uint)bVar6) - (uint)(bVar6 != 0);
        goto LAB_0056e87f;
      }
      if (bVar1 == 0) break;
      bVar1 = pbVar5[1];
      bVar6 = bVar1 < pbVar3[1];
      if (bVar1 != pbVar3[1]) goto LAB_0056e87a;
      pbVar5 = pbVar5 + 2;
      pbVar3 = pbVar3 + 2;
    } while (bVar1 != 0);
    iVar4 = 0;
LAB_0056e87f:
    if (((iVar4 == 0) && (cVar2 = FUN_0056e8e0(param_1 + 0x44), cVar2 != '\0')) &&
       (*(int *)(param_1_00 + 0x67) == *(int *)(param_1 + 0x67))) {
      iVar4 = 0;
      if (0 < *(int *)(param_1_00 + 0x67)) {
        pbVar3 = param_1_00 + 0x6b;
        do {
          cVar2 = FUN_0056ea60(pbVar3 + ((int)param_1 - (int)param_1_00));
          if (cVar2 != '\0') {
            return 0;
          }
          iVar4 = iVar4 + 1;
          pbVar3 = pbVar3 + 8;
        } while (iVar4 < *(int *)(param_1_00 + 0x67));
      }
      return 1;
    }
  }
  return 0;
}


