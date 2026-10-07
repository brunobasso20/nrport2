/* NR2003.exe @ 00545760 FUN_00545760 */

void FUN_00545760(void)

{
  char cVar1;
  int iVar2;
  uint uVar3;
  int local_4;
  
  FUN_00544de0(FUN_00545710);
  uVar3 = 0;
  do {
    iVar2 = FUN_004f5970(uVar3);
    if ((*(char *)(iVar2 + 0x59a) == '\0') &&
       (iVar2 = FUN_004f5970(uVar3), *(char *)(iVar2 + 0x1182) != '\0')) {
      local_4 = 0;
      cVar1 = FUN_005c2db0(&local_4);
      while ((cVar1 != '\0' &&
             ((iVar2 = FUN_005c2d40(local_4), iVar2 != 2 ||
              (iVar2 = FUN_005c2e10(local_4),
              ((&DAT_00be11bb)[iVar2 * 0xfb + (uVar3 >> 5)] & 1 << ((byte)uVar3 & 0x1f)) != 0))))) {
        cVar1 = FUN_005c2db0(&local_4);
      }
      if (local_4 == 0) {
        iVar2 = FUN_004f5970(uVar3);
        *(undefined *)(iVar2 + 0x1182) = 0;
      }
    }
    uVar3 = uVar3 + 1;
  } while ((int)uVar3 < 0x30);
  FUN_005a85c0();
  return;
}

