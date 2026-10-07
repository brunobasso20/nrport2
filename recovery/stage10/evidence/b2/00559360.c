/* NR2003.exe @ 00559360 FUN_00559360 */

undefined4 FUN_00559360(void)

{
  char cVar1;
  char *pcVar2;
  int iVar3;
  char *pcVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  undefined local_12c [4];
  undefined1 *local_128;
  char local_124 [33];
  char local_103 [259];
  
  local_128 = &DAT_00c055c0;
  puVar5 = (undefined4 *)&DAT_00c03350;
  puVar6 = (undefined4 *)&DAT_00c055c0;
  for (iVar3 = 0x3bf; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar6 = *puVar5;
    puVar5 = puVar5 + 1;
    puVar6 = puVar6 + 1;
  }
  *(undefined *)puVar6 = *(undefined *)puVar5;
  pcVar2 = (char *)FUN_0055a680();
  pcVar4 = local_124;
  do {
    cVar1 = *pcVar2;
    pcVar2 = pcVar2 + 1;
    *pcVar4 = cVar1;
    pcVar4 = pcVar4 + 1;
  } while (cVar1 != '\0');
  pcVar2 = (char *)thunk_FUN_00445ed0();
  pcVar4 = local_103;
  do {
    cVar1 = *pcVar2;
    pcVar2 = pcVar2 + 1;
    *pcVar4 = cVar1;
    pcVar4 = pcVar4 + 1;
  } while (cVar1 != '\0');
  cVar1 = FUN_00500800();
  if (cVar1 != '\0') {
    cVar1 = FUN_00501480();
    if (cVar1 != '\0') {
      FUN_00501b30();
    }
  }
  bgRequestFGAction(FUN_00559400,local_12c,&local_128);
  FUN_00559820();
  FUN_00550c60();
  return 1;
}

