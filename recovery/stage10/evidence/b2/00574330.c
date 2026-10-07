/* NR2003.exe @ 00574330 FUN_00574330 */

void FUN_00574330(void)

{
  char *pcVar1;
  int iVar2;
  
  iVar2 = 0;
  pcVar1 = &DAT_00c72731;
  do {
    if ((pcVar1[-1] == '\0') && (*pcVar1 != '\0')) {
      *pcVar1 = '\0';
      DAT_00c74dd0 = 1;
      FUN_005aa420(iVar2);
    }
    pcVar1 = pcVar1 + 0xce;
    iVar2 = iVar2 + 1;
  } while ((int)pcVar1 < 0xc74dd1);
  return;
}

