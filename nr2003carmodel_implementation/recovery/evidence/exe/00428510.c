/* NR2003.exe @ 00428510 FUN_00428510 */

void FUN_00428510(int param_1)

{
  char cVar1;
  int *piVar2;
  int iVar3;
  
  if ((DAT_00c72160 != (int *)0x0) && (param_1 != 0)) {
    iVar3 = 0;
    piVar2 = &DAT_008726fc;
    do {
      cVar1 = FUN_0056c150(iVar3,0xffffffff);
      if (cVar1 != '\0') {
        FUN_00427a30(iVar3);
        if (*piVar2 != 0) {
          (**(code **)(*DAT_00c72160 + 0x94))(*piVar2,param_1,0,0);
        }
      }
      piVar2 = piVar2 + 0x380;
      iVar3 = iVar3 + 1;
    } while ((int)piVar2 < 0x876cfc);
  }
  return;
}

