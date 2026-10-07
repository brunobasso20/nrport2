/* NR2003.exe @ 005b05c0 FUN_005b05c0 */

void FUN_005b05c0(void)

{
  char cVar1;
  uint uVar2;
  char *pcVar3;
  char local_102;
  char local_101;
  undefined local_100 [256];
  
  uVar2 = FUN_005b7c00();
  do {
    if ((int)uVar2 < 1) {
      return;
    }
    pcVar3 = (char *)FUN_005b7b20();
    cVar1 = *pcVar3;
    if (cVar1 == '\0') {
      if ((int)uVar2 < 2) {
        return;
      }
      FUN_005b7b40(1);
      FUN_005b7a60(&local_102,1);
      DAT_00e7d664 = local_102 != '\0';
    }
    else if (cVar1 == '\x01') {
      if (0xff < uVar2) {
        FUN_005b7b40(1);
        FUN_005b7a60(local_100,0xff);
        FUN_005b06d0(local_100);
      }
    }
    else if (cVar1 == '\x02') {
      if ((int)uVar2 < 2) {
        return;
      }
      FUN_005b7b40(1);
      FUN_005b7a60(&local_101,1);
      DAT_00e7d665 = local_101 != '\0';
    }
    cVar1 = FUN_005b0590();
    if (cVar1 != '\0') {
      FUN_005b05b0();
    }
    uVar2 = FUN_005b7c00();
  } while( true );
}

