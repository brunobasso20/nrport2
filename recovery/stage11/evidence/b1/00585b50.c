/* NR2003.exe @ 00585b50 FUN_00585b50 */

void FUN_00585b50(void)

{
  int iVar1;
  char *pcVar2;
  undefined *puVar3;
  
  pcVar2 = &DAT_00d7cae0;
  puVar3 = &DAT_00d7b7a0;
  iVar1 = 0x20;
  do {
    if (*pcVar2 != '\0') {
      FUN_005855a0(puVar3);
    }
    pcVar2 = pcVar2 + 1;
    puVar3 = puVar3 + 0x9a;
    iVar1 = iVar1 + -1;
  } while (iVar1 != 0);
  return;
}

