/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005861e0 */

undefined * FUN_005861e0(void)

{
  char cVar1;
  undefined *puVar2;
  undefined *puVar3;
  char *pcVar4;
  int local_4;
  
  puVar2 = (undefined *)0x0;
  pcVar4 = &DAT_00d7cae0;
  puVar3 = &DAT_00d7b7a0;
  local_4 = 0x20;
  do {
    if ((*pcVar4 != '\0') && (cVar1 = FUN_00585da0(puVar3,puVar2), cVar1 != '\0')) {
      puVar2 = puVar3;
    }
    pcVar4 = pcVar4 + 1;
    puVar3 = puVar3 + 0x9a;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  if (puVar2 == (undefined *)0x0) {
    pcVar4 = &DAT_00d7cae0;
    puVar3 = &DAT_00d7b7a0;
    local_4 = 0x20;
    do {
      if ((*pcVar4 != '\0') && (cVar1 = FUN_00585dd0(puVar3,puVar2), cVar1 != '\0')) {
        puVar2 = puVar3;
      }
      pcVar4 = pcVar4 + 1;
      puVar3 = puVar3 + 0x9a;
      local_4 = local_4 + -1;
    } while (local_4 != 0);
    if (puVar2 == (undefined *)0x0) {
      pcVar4 = &DAT_00d7cae0;
      puVar3 = &DAT_00d7b7a0;
      local_4 = 0x20;
      do {
        if ((*pcVar4 != '\0') && (cVar1 = FUN_00585e00(puVar3,puVar2), cVar1 != '\0')) {
          puVar2 = puVar3;
        }
        pcVar4 = pcVar4 + 1;
        puVar3 = puVar3 + 0x9a;
        local_4 = local_4 + -1;
      } while (local_4 != 0);
    }
  }
  return puVar2;
}


