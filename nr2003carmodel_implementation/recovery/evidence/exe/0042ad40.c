/* NR2003.exe @ 0042ad40 FUN_0042ad40 */

void FUN_0042ad40(uint *param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  int local_4;
  
  iVar4 = 0;
  do {
    cVar1 = FUN_0056c150(iVar4,0xffffffff);
    if (cVar1 != '\0') {
      FUN_00427a30(iVar4);
      iVar3 = 1;
      local_4 = 0;
      do {
        iVar2 = FUN_0042b030(iVar4,local_4);
        iVar5 = local_4;
        if (iVar2 == 0) {
          while (iVar5 = iVar5 + -1, -1 < iVar5) {
            FUN_0042b0c0(iVar4,iVar5);
          }
          iVar5 = 0;
          if (0 < iVar4) {
            do {
              cVar1 = FUN_0056c150(iVar5,0xffffffff);
              if (cVar1 != '\0') {
                iVar3 = FUN_00427a30(iVar5);
                iVar2 = 0;
                if (0 < iVar3) {
                  do {
                    FUN_0042b0c0(iVar5,iVar2);
                    iVar2 = iVar2 + 1;
                  } while (iVar2 < iVar3);
                }
              }
              iVar5 = iVar5 + 1;
            } while (iVar5 < iVar4);
          }
          *param_1 = 0;
        }
        local_4 = local_4 + 1;
      } while (local_4 < iVar3);
    }
    iVar4 = iVar4 + 1;
  } while (iVar4 < 5);
  iVar4 = FUN_0042ae00();
  *param_1 = (uint)(iVar4 != 0);
  return;
}

