/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056ca90 */

undefined4 FUN_0056ca90(int param_1,int param_2)

{
  char cVar1;
  bool bVar2;
  int iVar3;
  undefined4 uVar4;
  int *piVar5;
  int *piVar6;
  int iVar7;
  undefined4 *puVar8;
  int extraout_ECX;
  int extraout_ECX_00;
  int iVar9;
  int *piVar10;
  int *piVar11;
  int iVar12;
  int *local_1d;
  undefined1 local_19;
  undefined4 local_18;
  int local_14;
  int local_10;
  int *local_c;
  int *local_8;
  
  if (DAT_00c5c2e8 != 0) {
    DAT_00c5caec = param_1;
    DAT_00c5caf0 = 0;
    local_14 = 0;
    FUN_0045b1f0();
    local_c = &local_10;
    iVar9 = 0;
    param_1 = 0;
    iVar3 = FUN_0056c940(3);
    if (0 < iVar3) {
      do {
        uVar4 = FUN_0056c9f0(iVar9);
        local_19 = FUN_0056c980(iVar9);
        local_18 = uVar4;
        FUN_0056d560();
        iVar3 = FUN_0045baa0(0x15,1,&DAT_0073473c);
        if ((iVar3 == 0) || (piVar5 = (int *)FUN_0056d4a0(&local_19), piVar5 == (int *)0x0)) {
          FUN_0056d490(&local_1d);
        }
        else {
          bVar2 = true;
          piVar6 = &local_10;
          piVar10 = local_8;
          while (piVar10 != (int *)0x0) {
            cVar1 = FUN_0056d310(piVar10 + 4);
            if (cVar1 == '\0') {
              piVar11 = (int *)piVar10[3];
            }
            else {
              piVar11 = (int *)piVar10[2];
            }
            bVar2 = cVar1 != '\0';
            piVar6 = piVar10;
            iVar9 = param_1;
            piVar10 = piVar11;
          }
          piVar5[1] = (int)piVar6;
          if (bVar2) {
            piVar6[2] = (int)piVar5;
          }
          else {
            piVar6[3] = (int)piVar5;
          }
          *piVar5 = 1;
          piVar6 = (int *)piVar5[1];
          piVar10 = piVar5;
          if (piVar6 != &local_10) {
            do {
              if (*piVar6 != 1) break;
              piVar11 = *(int **)(piVar6[1] + 8);
              if (piVar6 == piVar11) {
                piVar11 = *(int **)(piVar6[1] + 0xc);
                if ((piVar11 == (int *)0x0) || (*piVar11 != 1)) {
                  if (piVar10 == (int *)piVar6[3]) {
                    FUN_0045bad0();
                    piVar10 = piVar6;
                  }
                  *(undefined4 *)piVar10[1] = 0;
                  **(undefined4 **)(piVar10[1] + 4) = 1;
                  FUN_0045bb10();
                }
                else {
                  *piVar6 = 0;
                  *piVar11 = 0;
                  **(undefined4 **)(piVar10[1] + 4) = 1;
                  piVar10 = *(int **)(piVar10[1] + 4);
                }
              }
              else if ((piVar11 == (int *)0x0) || (*piVar11 != 1)) {
                if (piVar10 == (int *)piVar6[2]) {
                  FUN_0045bb10();
                  piVar10 = piVar6;
                }
                *(undefined4 *)piVar10[1] = 0;
                **(undefined4 **)(piVar10[1] + 4) = 1;
                FUN_0045bad0();
              }
              else {
                *piVar6 = 0;
                *piVar11 = 0;
                **(undefined4 **)(piVar10[1] + 4) = 1;
                piVar10 = *(int **)(piVar10[1] + 4);
              }
              piVar6 = (int *)piVar10[1];
            } while (piVar6 != &local_10);
          }
          *local_8 = 0;
          local_14 = local_14 + 1;
          local_1d = piVar5;
        }
        iVar9 = iVar9 + 1;
        param_1 = iVar9;
        iVar3 = FUN_0056c940(3);
      } while (iVar9 < iVar3);
    }
    if ((char)param_2 == '\0') {
      FUN_0056d3a0(&param_2);
      iVar9 = FUN_0056c940(3);
      if (-1 < iVar9 + -1) {
        iVar3 = (iVar9 + -1) * 5;
        do {
          puVar8 = (undefined4 *)(iVar3 + DAT_00c5c2e8);
          iVar3 = iVar3 + -5;
          *puVar8 = *(undefined4 *)(param_2 + 0x10);
          *(undefined1 *)(puVar8 + 1) = *(undefined1 *)(param_2 + 0x14);
          param_2 = FUN_0045b280();
          iVar9 = iVar9 + -1;
        } while (iVar9 != 0);
      }
    }
    else {
      if (local_8 == (int *)0x0) {
        FUN_0056d490(&param_2);
      }
      else {
        param_2 = FUN_0045b2b0();
      }
      iVar3 = 0;
      iVar9 = FUN_0056c940(3);
      if (0 < iVar9) {
        iVar12 = 0;
        iVar9 = extraout_ECX;
        do {
          iVar3 = iVar3 + 1;
          puVar8 = (undefined4 *)(iVar12 + DAT_00c5c2e8);
          iVar12 = iVar12 + 5;
          *puVar8 = *(undefined4 *)(iVar9 + 0x10);
          *(undefined1 *)(puVar8 + 1) = *(undefined1 *)(iVar9 + 0x14);
          param_2 = FUN_0045b280();
          iVar7 = FUN_0056c940(3);
          iVar9 = extraout_ECX_00;
        } while (iVar3 < iVar7);
      }
    }
    while (0 < local_14) {
      puVar8 = (undefined4 *)FUN_0056d3a0(&param_2);
      FUN_0056d3d0(&param_1,*puVar8);
    }
    DAT_00c5caec = 0;
    DAT_00c5caf0 = 0;
    FUN_0056d4d0();
  }
  return 1;
}


