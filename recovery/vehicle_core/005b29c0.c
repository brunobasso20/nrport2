/* Ghidra pseudo-C; NR2003.exe @ 005b29c0 */

undefined4 FUN_005b29c0(void)

{
  int iVar1;
  char *pcVar2;
  
  iVar1 = 0;
  DAT_00e84654 = 0;
  if (0 < DAT_0072c2e0) {
    pcVar2 = s_chassis_00727290;
    do {
      FUN_005b2b10(pcVar2);
      iVar1 = iVar1 + 1;
      pcVar2 = pcVar2 + 0x505;
    } while (iVar1 < DAT_0072c2e0);
  }
  iVar1 = 0;
  if (0 < DAT_0072c2e0) {
    pcVar2 = s_chassis_00727290;
    do {
      FUN_005b2a30(pcVar2,pcVar2 + 0x20,s_chassis_00727290,DAT_0072c2e0);
      iVar1 = iVar1 + 1;
      pcVar2 = pcVar2 + 0x505;
    } while (iVar1 < DAT_0072c2e0);
  }
  return DAT_00e84654;
}

