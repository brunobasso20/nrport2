/* NR2003.exe @ 0057c790 FUN_0057c790 */

void FUN_0057c790(void)

{
  int iVar1;
  int *piVar2;
  int iVar3;
  int local_35c [215];
  
  iVar3 = 0;
  piVar2 = &DAT_00d37ccc;
  do {
    if ((piVar2[-1] == 4) && ((piVar2[-3] & DAT_00d3b028) != 0)) {
      iVar1 = 0;
      if (0 < iVar3) {
        do {
          if (local_35c[iVar1] == *piVar2) break;
          iVar1 = iVar1 + 1;
        } while (iVar1 < iVar3);
      }
      if (iVar1 == iVar3) {
        local_35c[iVar3] = *piVar2;
        iVar3 = iVar3 + 1;
      }
    }
    piVar2 = (int *)((int)piVar2 + 0x1d);
    if (0xd39526 < (int)piVar2) {
      FUN_005d0140(iVar3,local_35c);
      return;
    }
  } while( true );
}

