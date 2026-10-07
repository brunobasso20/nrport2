/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b2b20 */

char * FUN_005b2b20(byte *param_1)

{
  byte bVar1;
  byte *pbVar2;
  int iVar3;
  char *pcVar4;
  byte *pbVar5;
  int iVar6;
  bool bVar7;
  
  iVar6 = 0;
  if (0 < DAT_0072c2e0) {
    pcVar4 = s_chassis_00727290;
    pbVar2 = param_1;
    pbVar5 = (byte *)pcVar4;
LAB_005b2b3b:
    do {
      bVar1 = *pbVar2;
      bVar7 = bVar1 < (byte)*pcVar4;
      if (bVar1 == *pcVar4) {
        if (bVar1 != 0) {
          bVar1 = pbVar2[1];
          bVar7 = bVar1 < (byte)pcVar4[1];
          if (bVar1 != pcVar4[1]) goto LAB_005b2b5f;
          pcVar4 = pcVar4 + 2;
          pbVar2 = pbVar2 + 2;
          if (bVar1 != 0) goto LAB_005b2b3b;
        }
        iVar3 = 0;
      }
      else {
LAB_005b2b5f:
        iVar3 = (1 - (uint)bVar7) - (uint)(bVar7 != 0);
      }
      if (iVar3 == 0) {
        return s_chassis_00727290 + iVar6 * 0x505;
      }
      iVar6 = iVar6 + 1;
      pcVar4 = (char *)(pbVar5 + 0x505);
      pbVar2 = param_1;
      pbVar5 = (byte *)pcVar4;
    } while (iVar6 < DAT_0072c2e0);
  }
  return (char *)0x0;
}


