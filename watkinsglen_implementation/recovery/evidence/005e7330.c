/* NR2003.exe @ 005e7330 recovered_005e7330 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall recovered_005e7330(double *param_1,int param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 *puVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  undefined4 *puVar8;
  char *pcVar9;
  int *piVar10;
  int unaff_EBP;
  int unaff_EDI;
  undefined2 *puVar11;
  undefined4 *puStack_68;
  int iStack_64;
  undefined4 uStack_60;
  double *pdStack_5c;
  undefined4 uStack_58;
  double dStack_54;
  double dStack_4c;
  undefined *puStack_44;
  undefined4 uStack_40;
  undefined4 *puStack_3c;
  int iStack_38;
  undefined4 uStack_24;
  undefined4 uStack_20;
  double dStack_1c;
  undefined auStack_14 [16];
  double *pdStack_4;

  iStack_38 = param_2;
  puStack_3c = (undefined4 *)0x5e7347;
  pdStack_4 = param_1;
  iVar1 = FUN_005e0300();
  if (iVar1 != 1) {
    return 0;
  }
  puStack_3c = &uStack_24;
  iStack_38 = 4;
  uStack_24 = 7;
  uStack_40 = 0x5e736e;
  iVar1 = FUN_005cff5a();
  if (iVar1 == 0) {
    return 0;
  }
  if (*(int *)(param_2 + 5) == 0) {
    if (7 < unaff_EBP) {
      return 0;
    }
    if (unaff_EBP < 6) {
      puStack_44 = auStack_14;
      uStack_40 = 8;
      dStack_4c = (double)CONCAT44(0x5e73af,dStack_4c._0_4_);
      iVar1 = FUN_005cff5a();
      if (iVar1 == 0) {
        return 0;
      }
      *(float *)((int)param_1 + 0xc) = (float)dStack_1c;
      goto LAB_005e73c6;
    }
  }
  puStack_44 = (undefined *)((int)param_1 + 0xc);
  uStack_40 = 4;
  dStack_4c = (double)CONCAT44(0x5e73f3,dStack_4c._0_4_);
  iVar1 = FUN_005cff5a();
  if (iVar1 == 0) {
    return 0;
  }
LAB_005e73c6:
  dStack_4c = (double)*(float *)((int)param_1 + 0xc);
  dStack_54 = (double)CONCAT44(0x5e73d3,dStack_54._0_4_);
  iVar1 = FUN_006c79d2();
  if (iVar1 != 0) {
    return 0;
  }
  if ((float)_DAT_006ee688 < ABS(*(float *)((int)param_1 + 0xc))) {
    return 0;
  }
  if ((*(int *)(param_2 + 5) == 0) && (unaff_EDI < 6)) {
    dStack_4c = (double)CONCAT44(8,&dStack_1c);
    dStack_54 = (double)CONCAT44(0x5e743c,dStack_54._0_4_);
    iVar1 = FUN_005cff5a();
    if (iVar1 == 0) {
      return 0;
    }
    *(float *)(param_1 + 2) = (float)(double)CONCAT44(uStack_20,uStack_24);
  }
  else {
    dStack_4c = (double)CONCAT44(4,param_1 + 2);
    dStack_54 = (double)CONCAT44(0x5e7480,dStack_54._0_4_);
    iVar1 = FUN_005cff5a();
    if (iVar1 == 0) {
      return 0;
    }
  }
  dStack_54 = (double)*(float *)(param_1 + 2);
  uStack_58 = 0x5e7460;
  iVar1 = FUN_006c79d2();
  if (iVar1 != 0) {
    return 0;
  }
  if ((float)_DAT_006ee688 < ABS(*(float *)(param_1 + 2))) {
    return 0;
  }
  if ((*(int *)(param_2 + 5) == 0) && ((int)puStack_3c < 3)) {
    *(undefined *)((int)param_1 + 0x14) = 0;
  }
  else {
    dStack_54 = (double)CONCAT44(1,(int)param_1 + 0x14);
    uStack_58 = 0x5e74e3;
    iVar1 = FUN_005cff5a();
    if (iVar1 == 0) {
      return 0;
    }
  }
  if ((*(int *)(param_2 + 5) == 0) && ((int)puStack_3c < 4)) {
    *(undefined4 *)((int)param_1 + 0x55) = 1;
  }
  else {
    dStack_54 = (double)CONCAT44(4,(int)param_1 + 0x55);
    uStack_58 = 0x5e74fe;
    iVar1 = FUN_005cff5a();
    if (iVar1 == 0) {
      return 0;
    }
  }
  dStack_54 = (double)CONCAT44(8,(double *)((int)param_1 + 0x15));
  uStack_58 = 0x5e7519;
  iVar1 = FUN_005cff5a();
  if (iVar1 == 0) {
    return 0;
  }
  if (_DAT_006ef718 < *(double *)((int)param_1 + 0x15)) {
    return 0;
  }
  uStack_58 = 8;
  uStack_60 = 0x5e7551;
  pdStack_5c = (double *)((int)param_1 + 0x1d);
  iVar1 = FUN_005cff5a();
  if (iVar1 == 0) {
    return 0;
  }
  if (_DAT_006ef718 < *(double *)((int)param_1 + 0x1d)) {
    return 0;
  }
  iStack_64 = (int)param_1 + 0x25;
  uStack_60 = 8;
  puStack_68 = (undefined4 *)0x5e7589;
  iVar1 = FUN_005cff5a();
  if (iVar1 == 0) {
    return 0;
  }
  puStack_68 = (undefined4 *)&DAT_00000008;
  iVar1 = FUN_005cff5a((int)param_1 + 0x2d);
  if (iVar1 == 0) {
    return 0;
  }
  iVar1 = (int)param_1 + 0x35;
  iVar2 = FUN_005cff5a(iVar1,8);
  if (iVar2 == 0) {
    return 0;
  }
  iVar2 = (int)param_1 + 0x3d;
  iVar3 = FUN_005cff5a(iVar2,8);
  if (iVar3 == 0) {
    return 0;
  }
  iVar3 = FUN_005cff5a((int *)((int)param_1 + 0x45),4);
  if (iVar3 == 0) {
    return 0;
  }
  if ((*(int *)(param_2 + 5) == 0) && (iVar1 < 7)) {
    *(undefined4 *)((int)param_1 + 0x49) = 0;
  }
  else {
    iVar1 = FUN_005cff5a((int)param_1 + 0x49,4);
    if (iVar1 == 0) {
      return 0;
    }
  }
  if (*(int *)((int)param_1 + 0x49) == 1) {
    if (*(int *)(param_2 + 5) == 0) {
      iVar1 = FUN_005cfce4(&pdStack_5c,0x28);
      *(uint *)((int)param_1 + 0x4d) = -(uint)(iVar1 != 0) & (uint)pdStack_5c;
    }
    if ((*(int *)((int)param_1 + 0x4d) != 0) &&
       (iVar1 = FUN_005cff5a(*(int *)((int)param_1 + 0x4d),0x28), iVar1 == 0)) {
      return 0;
    }
  }
  if (*(int *)((int)param_1 + 0x45) == -1) {
    return 0;
  }
  iVar1 = FUN_005cff5a((int)param_1 + 0x51,4);
  if (iVar1 != 0) {
    if ((*(int *)(param_2 + 5) == 0) && (iVar2 < 5)) {
      *(undefined4 *)((int)param_1 + 0x59) = 1;
    }
    else {
      iVar1 = FUN_005cff5a((int)param_1 + 0x59,4);
      if (iVar1 == 0) {
        return 0;
      }
    }
    if (*(int *)(param_2 + 5) == 0) {
      iVar1 = *(int *)((int)param_1 + 0x59);
      iVar3 = FUN_005cfce4(&puStack_68,iVar1 * 0x53a);
      if ((iVar3 == 0) || (puStack_68 == (undefined4 *)0x0)) {
        puVar4 = (undefined4 *)0x0;
      }
      else {
        puVar4 = puStack_68;
        if (-1 < iVar1 + -1) {
          puVar6 = puStack_68 + 5;
          iStack_64 = iVar1;
          do {
            iVar1 = 0;
            puVar8 = puVar6 + 7;
            do {
              puVar6[iVar1 + -5] = 0;
              puVar6[iVar1] = 0;
              *puVar8 = 0x1010101;
              iVar1 = iVar1 + 1;
              *(undefined2 *)(puVar8 + 1) = 0x101;
              puVar8 = (undefined4 *)((int)puVar8 + 6);
            } while (iVar1 < 5);
            puVar6 = (undefined4 *)((int)puVar6 + 0x53a);
            iStack_64 = iStack_64 + -1;
          } while (iStack_64 != 0);
        }
      }
      *(undefined4 **)((int)param_1 + 0x5d) = puVar4;
      if (puVar4 == (undefined4 *)0x0) {
        return 0;
      }
    }
    iVar1 = 0;
    if (0 < *(int *)((int)param_1 + 0x59)) {
      iStack_64 = 0;
      do {
        piVar10 = (int *)(*(int *)((int)param_1 + 0x5d) + iStack_64);
        if ((*(int *)(param_2 + 5) == 0) && (iVar2 < 5)) {
          piVar10[10] = 0;
          piVar10[0xb] = 0;
        }
        else {
          iVar3 = FUN_005cff5a(piVar10 + 10,8);
          if (iVar3 == 0) {
            return 0;
          }
        }
        puStack_68 = (undefined4 *)((int)piVar10 + 0x29a);
        puVar4 = (undefined4 *)((int)piVar10 + 0xaa);
        puVar11 = (undefined2 *)((int)piVar10 + 0x52);
        pcVar9 = (char *)((int)piVar10 + 0x32);
        iVar3 = 0;
        do {
          DAT_00f6e3e0 = DAT_00f6e464;
          iVar5 = FUN_005cff48(piVar10);
          DAT_00f6e3e0 = 0;
          if (iVar5 == 0) {
            DAT_00f6e3e0 = 0;
            return 0;
          }
          iVar5 = *piVar10;
          if ((iVar5 != 0) &&
             ((((*(int *)(iVar5 + 0xc) != 0 || (*(int *)(iVar5 + 0x10) != 0)) ||
               (*(int *)(iVar5 + 0x14) != 0)) ||
              ((*(int *)(iVar5 + 0x18) != 0 || (*(int *)(iVar5 + 0x20) != 0)))))) {
            iVar5 = FUN_005cff48(piVar10 + 5);
            if (iVar5 == 0) {
              return 0;
            }
            if (((*(int *)(param_2 + 5) == 0) && (*(int *)(*piVar10 + 0x18) != 0)) &&
               (*(int *)(piVar10[5] + 0x40) == 0)) {
              FUN_005e0f60(*(undefined4 *)(*piVar10 + 0x90));
            }
            if (*(int *)(piVar10[5] + 0x70) != 4) {
              return 0;
            }
            if (1 < iVar2) {
              iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,0,*(undefined4 *)(*piVar10 + 0xc));
              if (iVar5 == 0) {
                return 0;
              }
              iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,1,*(undefined4 *)(*piVar10 + 0x10));
              if (iVar5 == 0) {
                return 0;
              }
              if (*(char *)(*piVar10 + 0x9c) == '\0') {
                iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,2,*(undefined4 *)(*piVar10 + 0x18));
              }
              else {
                *pcVar9 = pcVar9[-2];
                if (pcVar9[-2] == '\0') {
                  *puVar11 = puVar11[-2];
                  *puVar4 = puVar4[-8];
                  puVar4[1] = puVar4[-7];
                  puVar4[2] = puVar4[-6];
                  puVar4[3] = puVar4[-5];
                  puVar6 = puStack_68 + -0xc;
                  puVar8 = puStack_68;
                  for (iVar7 = 6; iVar7 != 0; iVar7 = iVar7 + -1) {
                    *puVar8 = *puVar6;
                    puVar6 = puVar6 + 1;
                    puVar8 = puVar8 + 1;
                  }
                  param_2 = dStack_54._0_4_;
                  param_1 = pdStack_5c;
                }
              }
              if (iVar5 == 0) {
                return 0;
              }
              iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,3,*(undefined4 *)(*piVar10 + 0x14));
              if (iVar5 == 0) {
                return 0;
              }
              iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,4,*(undefined4 *)(*piVar10 + 0x1c));
              if (iVar5 == 0) {
                return 0;
              }
              iVar5 = FUN_005e71f0(param_2,iVar1,iVar3,5,*(undefined4 *)(*piVar10 + 0x20));
              if (iVar5 == 0) {
                return 0;
              }
            }
          }
          pcVar9 = pcVar9 + 6;
          iVar3 = iVar3 + 1;
          puVar11 = puVar11 + 6;
          puVar4 = puVar4 + 0x18;
          puStack_68 = puStack_68 + 0x24;
          piVar10 = piVar10 + 1;
        } while (iVar3 < 5);
        iVar1 = iVar1 + 1;
        iStack_64 = iStack_64 + 0x53a;
      } while (iVar1 < *(int *)((int)param_1 + 0x59));
    }
    return 1;
  }
  return 0;
}
