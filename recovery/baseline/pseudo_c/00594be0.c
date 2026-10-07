/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00594be0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00594be0(int param_1,int param_2,char param_3)

{
  char cVar1;
  undefined1 uVar2;
  short sVar3;
  bool bVar4;
  char *pcVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  int *piVar11;
  undefined4 uVar12;
  int local_134;
  int local_120;
  undefined2 local_11c [142];
  
  bVar4 = inServer();
  if (bVar4) {
    iVar10 = 0;
    iVar9 = 0;
    local_134 = 0;
    pcVar5 = (char *)(param_1 + 9);
    iVar8 = 0x30;
    do {
      if (*pcVar5 != -1) {
        iVar9 = iVar9 + 1;
      }
      pcVar5 = pcVar5 + 10;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
    piVar11 = &local_120;
    do {
      *piVar11 = 0;
      *(undefined2 *)(piVar11 + 1) = 0;
      iVar8 = FUN_004f5970(iVar10);
      iVar6 = FUN_004f5970(iVar10);
      iVar7 = FUN_004f5970(iVar10);
      if (((((*(char *)(iVar7 + 0x59a) != '\0') ||
            (iVar7 = FUN_004f5970(iVar10), *(char *)(iVar7 + 0x1182) != '\0')) &&
           (sVar3 = *(short *)(iVar8 + 0x1226), sVar3 != 0)) && (iVar6 != DAT_00760b38)) &&
         ((iVar6 = FUN_005940d0(param_1,iVar10), iVar6 == -1 ||
          (*(char *)(iVar8 + 0x122a) != *(char *)(param_1 + 8 + iVar6 * 10))))) {
        cVar1 = *(char *)(iVar8 + 0x1232);
        uVar2 = *(undefined1 *)(iVar8 + 0x122a);
        *(char *)(piVar11 + 1) = (char)iVar10;
        *(undefined1 *)((int)piVar11 + 5) = uVar2;
        if (cVar1 == '\0') {
          iVar6 = FUN_004f5970(iVar10);
          if ((*(char *)(iVar6 + 0x59a) == '\0') &&
             (iVar6 = FUN_004f5970(iVar10), *(char *)(iVar6 + 0x1182) != '\0')) {
            rndUniform(0);
            iVar6 = FUN_006c5018();
            iVar6 = *piVar11 + iVar6;
LAB_00594e5a:
            *piVar11 = iVar6;
          }
          else {
            if (param_3 == '\0') {
              rndUniform(0);
              iVar6 = FUN_006c5018();
              iVar6 = *(short *)(iVar8 + 0x1226) - iVar6;
              goto LAB_00594e5a;
            }
            rndUniform(0);
            iVar8 = FUN_006c5018();
            *piVar11 = 0x15e - iVar8;
          }
        }
        else {
          *piVar11 = sVar3 + 0xfa;
          FUN_004f6e10(8,0);
          FUN_004f6e10(10,0);
          FUN_004f6e10(9,0);
          FUN_004f6e10(3,0);
          switch(DAT_00bdbd00) {
          case 0:
            uVar12 = 5;
            break;
          case 1:
          case 2:
          case 3:
            uVar12 = 6;
            break;
          case 4:
            uVar12 = 7;
            break;
          case 5:
            uVar12 = 4;
            break;
          default:
            goto switchD_00594d56_caseD_6;
          }
          FUN_004f6e10(uVar12,0);
switchD_00594d56_caseD_6:
          iVar8 = FUN_006c5018();
          iVar8 = 0x32 - iVar8;
          if (iVar8 < 0) {
            *piVar11 = *piVar11;
          }
          else {
            if (99 < iVar8) {
              iVar8 = 99;
            }
            *piVar11 = *piVar11 + iVar8;
          }
        }
        local_134 = local_134 + 1;
      }
      iVar10 = iVar10 + 1;
      piVar11 = (int *)((int)piVar11 + 6);
    } while (iVar10 < 0x30);
    if (param_2 - iVar9 < local_134) {
      local_134 = param_2 - iVar9;
    }
    if ((0 < local_134) && (iVar8 = 0, 0 < local_134)) {
      do {
        iVar9 = -1;
        iVar10 = 0;
        iVar6 = 0;
        piVar11 = &local_120;
        do {
          if (iVar10 < *piVar11) {
            iVar9 = iVar6;
            iVar10 = *piVar11;
          }
          iVar6 = iVar6 + 1;
          piVar11 = (int *)((int)piVar11 + 6);
        } while (iVar6 < 0x30);
        if (iVar9 == -1) {
          return;
        }
        FUN_00594b50(param_1,*(undefined1 *)(local_11c + iVar9 * 3));
        iVar8 = iVar8 + 1;
        *(undefined4 *)((int)&local_120 + iVar9 * 6) = 0;
        local_11c[iVar9 * 3] = 0;
      } while (iVar8 < local_134);
    }
  }
  return;
}


