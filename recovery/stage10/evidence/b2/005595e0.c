/* NR2003.exe @ 005595e0 FUN_005595e0 */

undefined4 FUN_005595e0(undefined4 param_1,undefined4 param_2,char *param_3)

{
  char cVar1;
  int iVar2;
  char *pcVar3;
  char local_104 [260];
  
  iVar2 = -(int)param_3;
  do {
    cVar1 = *param_3;
    param_3[(int)(local_104 + iVar2)] = cVar1;
    param_3 = param_3 + 1;
  } while (cVar1 != '\0');
  if (local_104[0] == '\\') {
    iVar2 = -1;
    pcVar3 = local_104;
    do {
      if (iVar2 == 0) break;
      iVar2 = iVar2 + -1;
      cVar1 = *pcVar3;
      pcVar3 = pcVar3 + 1;
    } while (cVar1 != '\0');
    FUN_006c5390();
  }
  iVar2 = FUN_005596d0();
  if (iVar2 == 0) {
    FUN_00424230();
    iVar2 = FUN_005596d0();
    if (iVar2 == 0) {
      FUN_004242f0();
      iVar2 = FUN_005596d0();
      if (iVar2 == 0) {
        do {
          cVar1 = (&DAT_00c064c9)[iVar2];
          (&stack0x00006a34)[iVar2] = cVar1;
          iVar2 = iVar2 + 1;
        } while (cVar1 != '\0');
        return 0;
      }
    }
  }
  return 1;
}

