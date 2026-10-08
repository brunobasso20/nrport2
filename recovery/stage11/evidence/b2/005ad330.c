/* NR2003.exe @ 005ad330 FUN_005ad330 */

void FUN_005ad330(void)

{
  int iVar1;
  int iVar2;
  
  iVar2 = 0;
  do {
    iVar1 = FUN_005aa360(iVar2);
    (&DAT_00e73288)[iVar2] = iVar1 + 0x1493;
    iVar2 = iVar2 + 1;
  } while (iVar2 < 0x30);
  return;
}

