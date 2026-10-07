/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005e5b40 */

/* WARNING: Removing unreachable block (ram,0x005e5f19) */
/* WARNING: Removing unreachable block (ram,0x005e5f86) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_005e5b40(int param_1_00,int param_1)

{
  double *pdVar1;
  int *piVar2;
  undefined4 uVar3;
  bool bVar4;
  int iVar5;
  int iVar6;
  float10 fVar7;
  char cVar8;
  undefined4 uStack_38;
  int iStack_34;
  int iStack_24;
  undefined4 local_1c [6];
  
  iStack_34 = param_1;
  uStack_38 = (undefined4 *)0x5e5b57;
  iVar5 = FUN_005e0300();
  if (iVar5 == 1) {
    uStack_38 = local_1c;
    iStack_34 = 4;
    local_1c[0] = 2;
    iVar5 = FUN_005cff5a();
    if ((iVar5 != 0) && ((*(int *)(param_1 + 5) != 0 || ((0 < iStack_24 && (iStack_24 < 3)))))) {
      iVar5 = FUN_005cff5a((int *)(param_1_00 + 0x42),4);
      if (iVar5 != 0) {
        iVar5 = *(int *)(param_1_00 + 0x42);
        if (0 < iVar5) {
          iVar5 = FUN_006c38fc((int *)(param_1_00 + 0x4e),iVar5 * 4);
          if (iVar5 == 0) {
            return 0;
          }
          if (*(int *)(param_1_00 + 0x4e) == 0) {
            return 0;
          }
          iVar5 = 0;
          bVar4 = true;
          if (0 < *(int *)(param_1_00 + 0x42)) {
            do {
              if (!bVar4) {
                return 0;
              }
              uVar3 = *(undefined4 *)(*(int *)(param_1_00 + 0x4e) + iVar5 * 4);
              iVar6 = FUN_005cff48(&stack0xffffffd8);
              if (iVar6 == 0) {
                bVar4 = false;
              }
              else {
                *(undefined4 *)(*(int *)(param_1_00 + 0x4e) + iVar5 * 4) = uVar3;
              }
              iVar5 = iVar5 + 1;
            } while (iVar5 < *(int *)(param_1_00 + 0x42));
            if (!bVar4) {
              return 0;
            }
          }
        }
        iVar5 = FUN_005cff5a((int *)(param_1_00 + 0x46),4);
        if (iVar5 != 0) {
          iVar5 = *(int *)(param_1_00 + 0x46);
          if (0 < iVar5) {
            iVar5 = FUN_006c38fc((int *)(param_1_00 + 0x52),iVar5 * 4);
            if (iVar5 == 0) {
              return 0;
            }
            if (*(int *)(param_1_00 + 0x52) == 0) {
              return 0;
            }
            iVar5 = 0;
            uStack_38 = (undefined4 *)CONCAT13(1,(undefined3)uStack_38);
            if (0 < *(int *)(param_1_00 + 0x46)) {
              do {
                if (uStack_38._3_1_ == '\0') {
                  return 0;
                }
                uVar3 = *(undefined4 *)(*(int *)(param_1_00 + 0x52) + iVar5 * 4);
                iVar6 = FUN_005cff48(&stack0xffffffd0);
                if (iVar6 == 0) {
                  uStack_38 = (undefined4 *)((uint)uStack_38 & 0xffffff);
                }
                else {
                  *(undefined4 *)(*(int *)(param_1_00 + 0x52) + iVar5 * 4) = uVar3;
                }
                iVar5 = iVar5 + 1;
              } while (iVar5 < *(int *)(param_1_00 + 0x46));
              if (uStack_38._3_1_ == '\0') {
                return 0;
              }
            }
          }
          iVar5 = FUN_005cff5a((int *)(param_1_00 + 0x4a),4);
          if (iVar5 != 0) {
            iVar5 = *(int *)(param_1_00 + 0x4a);
            if (0 < iVar5) {
              iVar5 = FUN_006c38fc((int *)(param_1_00 + 0x56),iVar5 * 4);
              if (iVar5 == 0) {
                return 0;
              }
              if (*(int *)(param_1_00 + 0x56) == 0) {
                return 0;
              }
              iVar5 = 0;
              cVar8 = '\x01';
              if (0 < *(int *)(param_1_00 + 0x4a)) {
                do {
                  if (cVar8 == '\0') {
                    return 0;
                  }
                  uStack_38 = *(undefined4 **)(*(int *)(param_1_00 + 0x56) + iVar5 * 4);
                  iVar6 = FUN_005cff48(&uStack_38);
                  if (iVar6 == 0) {
                    cVar8 = '\0';
                  }
                  else {
                    *(undefined4 **)(*(int *)(param_1_00 + 0x56) + iVar5 * 4) = uStack_38;
                  }
                  iVar5 = iVar5 + 1;
                } while (iVar5 < *(int *)(param_1_00 + 0x4a));
                if (cVar8 == '\0') {
                  return 0;
                }
              }
            }
            iVar5 = FUN_005cff5a((int *)(param_1_00 + 0xc),4);
            if ((((iVar5 != 0) && (*(int *)(param_1_00 + 0xc) != -1)) &&
                (iVar5 = FUN_005cff5a(param_1_00 + 0x10,8), iVar5 != 0)) &&
               (iVar5 = FUN_005cff5a(param_1_00 + 0x18,8), iVar5 != 0)) {
              pdVar1 = (double *)(param_1_00 + 0x20);
              iVar5 = FUN_005cff5a(pdVar1,8);
              if (((((iVar5 != 0) && (_DAT_006ea4b0 <= *pdVar1)) &&
                   ((*pdVar1 < _DAT_006f89b8 != (*pdVar1 == _DAT_006f89b8) &&
                    ((iVar5 = FUN_005cff5a(param_1_00 + 0x28,8), iVar5 != 0 &&
                     (iVar5 = FUN_005cff5a(param_1_00 + 0x30,8), iVar5 != 0)))))) &&
                  (iVar5 = FUN_005cff5a(param_1_00 + 0x38), iVar5 != 0)) &&
                 ((iVar5 = FUN_005cff5a(param_1_00 + 0x40,1), iVar5 != 0 &&
                  (iVar5 = FUN_005cff5a(param_1_00 + 0x41,1), iVar5 != 0)))) {
                if (*(int *)(param_1_00 + 0xc) == 0) {
                  fsin((float10)*pdVar1);
                  fcos((float10)*pdVar1);
                  fVar7 = (float10)FUN_006c72b0();
                  if ((float10)_DAT_006f89f0 < fVar7) {
                    return 0;
                  }
                  fsin((float10)*(double *)(param_1_00 + 0x38));
                  fcos((float10)*(double *)(param_1_00 + 0x38));
                  fVar7 = (float10)FUN_006c72b0();
                  if ((float10)_DAT_006f89f0 < fVar7) {
                    return 0;
                  }
                }
                if ((_DAT_006ea4b0 <= *(double *)(param_1_00 + 0x38)) &&
                   (*(double *)(param_1_00 + 0x38) < _DAT_006f89b8 !=
                    (*(double *)(param_1_00 + 0x38) == _DAT_006f89b8))) {
                  piVar2 = (int *)(param_1_00 + 0x5a);
                  iVar5 = FUN_005cff5a(piVar2,4);
                  if ((iVar5 != 0) &&
                     ((*piVar2 < 1 ||
                      (((iVar5 = FUN_006c38fc(param_1_00 + 0x62,*piVar2 * 0xc), iVar5 != 0 &&
                        (*(int *)(param_1_00 + 0x62) != 0)) &&
                       (iVar5 = FUN_005cff5a(*(int *)(param_1_00 + 0x62),*piVar2 * 0xc), iVar5 != 0)
                       ))))) {
                    piVar2 = (int *)(param_1_00 + 0x5e);
                    iVar5 = FUN_005cff5a(piVar2,4);
                    if (iVar5 != 0) {
                      if (0 < *piVar2) {
                        iVar5 = FUN_006c38fc((int *)(param_1_00 + 0x66),*piVar2 << 4);
                        if (iVar5 == 0) {
                          return 0;
                        }
                        iVar5 = *(int *)(param_1_00 + 0x66);
                        if (iVar5 == 0) {
                          return 0;
                        }
                        iVar5 = FUN_005cff5a(iVar5,*piVar2 << 4);
                        if (iVar5 == 0) {
                          return 0;
                        }
                      }
                      return 1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return 0;
}


