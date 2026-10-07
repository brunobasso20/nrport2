/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0054fed0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0054fed0(void)

{
  char *pcVar1;
  int iVar2;
  char cVar3;
  undefined1 local_19;
  int local_18;
  char *local_14;
  int local_10;
  int local_c;
  undefined1 local_8 [4];
  undefined1 local_4 [4];
  
  FUN_0057b1e0(&local_18,&local_14,local_4,local_8,&local_10,&local_19,7);
  if (local_18 == 1) {
    cVar3 = *local_14;
    while (((cVar3 != '\0' && ('/' < cVar3)) && (cVar3 < ':'))) {
      pcVar1 = local_14 + 1;
      local_14 = local_14 + 1;
      cVar3 = *pcVar1;
    }
    iVar2 = (uint)(*local_14 != '>') * 2 + -1;
    if ((DAT_00bf6ebb != '\0') &&
       ((cVar3 = FUN_00550280(), cVar3 == '\0' || (DAT_00bf6ebc != local_10)))) {
      FUN_00501b30();
      bgRequestFGAction(FUN_00550060,(void *)0x0,(void *)0x0);
      DAT_00bf6ebb = '\0';
    }
    DAT_00bf6ebc = local_10;
    _DAT_0074c95c = iVar2;
    if (((DAT_00bf6ebb == '\0') && (cVar3 = FUN_00550280(), cVar3 != '\0')) &&
       (cVar3 = FUN_005d0820(DAT_00bf6ebc), cVar3 != '\0')) {
      FUN_00501b30();
      bgRequestFGAction(FUN_00550000,&local_c,(void *)0x0);
      if (local_c != 0) {
        DAT_00bf6ebb = 1;
        return;
      }
    }
  }
  else if (DAT_00bf6ebb != '\0') {
    FUN_00501b30();
    bgRequestFGAction(FUN_00550060,(void *)0x0,(void *)0x0);
    DAT_00bf6ebb = '\0';
  }
  return;
}


