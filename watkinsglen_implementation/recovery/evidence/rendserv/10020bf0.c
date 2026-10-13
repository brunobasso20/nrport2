/* FUN_10020bf0 */

undefined4 __fastcall FUN_10020bf0(void *param_1)

{
  int *piVar1;
  uint *puVar2;
  int iVar3;
  int **ppiVar4;
  bool bVar5;
  undefined3 extraout_var;
  int iVar6;
  int iVar7;
  success sVar8;
  void *pvVar9;
  int iVar10;
  int *piVar11;
  int iVar12;
  void *this;
  int *piVar13;
  int local_34;
  int *piStack_30;
  int *piStack_2c;
  int iStack_28;
  void *pvStack_24;
  void *pvStack_20;
  void *pvStack_1c;
  void *apvStack_18 [2];
  int iStack_10;
  void *apvStack_c [3];

  local_34 = 1;
  while( true ) {
    do {
      bVar5 = FUN_10021b30((int)param_1);
      if (CONCAT31(extraout_var,bVar5) == 0) {
        if (local_34 != 0) {
          return 1;
        }
        goto LAB_10020e19;
      }
      iVar6 = (**(code **)(**(int **)(*(int *)((int)param_1 + 0x70) + 0x18) + 0x20))();
      iVar6 = *(int *)(iVar6 + 0x59);
      apvStack_c[0] = (void *)0x0;
      apvStack_c[1] = (void *)0x0;
      iVar12 = 0;
      iStack_10 = 0;
      apvStack_c[2] = (void *)0x0;
      *(int *)((int)param_1 + 0x58) = iVar6;
      *(undefined4 *)((int)param_1 + 0x54) = 0;
      if (0 < iVar6) {
        do {
          iVar7 = FUN_10021070(param_1);
          if (iVar7 != 0) {
            iStack_10 = *(int *)(*(int *)((int)param_1 + 0x78) + 8);
            iVar12 = 1;
            while ((local_34 != 0 && (iVar7 = FUN_10021120(param_1), iVar7 != 0))) {
              apvStack_18[iVar12 + 2] = *(void **)(*(int *)((int)param_1 + 0x78) + 8);
              local_34 = FUN_100211e0((int)param_1);
              iVar12 = iVar12 + 1;
            }
          }
          iVar7 = *(int *)((int)param_1 + 0x54) + 1;
          *(int *)((int)param_1 + 0x54) = iVar7;
        } while (iVar7 < iVar6);
      }
      if (local_34 == 0) goto LAB_10020e19;
      iVar7 = (**(code **)(**(int **)(*(int *)((int)param_1 + 0x70) + 0x18) + 0x20))();
    } while (iVar12 < 3);
    iVar10 = *(int *)(iVar7 + 0x5d);
    piStack_30 = (int *)0x0;
    piStack_2c = (int *)0x0;
    iVar3 = *(int *)(iVar10 + 0xc);
    if (iVar3 != 0) {
      *(uint *)(iVar3 + 0x88) = *(uint *)(iVar3 + 0x88) | 8;
      piStack_30 = FUN_100150d0(iVar3);
      iVar10 = *(int *)(iVar7 + 0x5d);
      puVar2 = (uint *)(*(int *)(iVar10 + 0xc) + 0x88);
      *puVar2 = *puVar2 & 0xfffffff7;
      if (piStack_30 == (int *)0x0) {
        local_34 = 0;
      }
    }
    iVar6 = iVar6 * 0x53a;
    iVar10 = *(int *)(iVar6 + -0x52a + iVar10);
    if (iVar10 != 0) break;
LAB_10020d52:
    if (local_34 == 0) goto LAB_1002102f;
    sVar8 = _memAlloc(&pvStack_24,0x218);
    if (((sVar8 == 0) || (pvStack_24 == (void *)0x0)) ||
       (iVar6 = iVar6 + *(int *)(iVar7 + 0x5d),
       iStack_28 = FUN_1001e530(pvStack_24,(int)piStack_30,(int)piStack_2c,iStack_10,
                                (int)apvStack_c[0],(int)apvStack_18[iVar12],
                                (int)apvStack_18[iVar12 + 1],*(int *)(iVar6 + -0x51a),
                                *(int *)(iVar6 + -0x516)), iStack_28 == 0)) goto LAB_10020e19;
    if (((piStack_30 == (int *)0x0) || (((uint)piStack_30[3] >> 4 & 1) == 0)) &&
       ((piStack_2c == (int *)0x0 || (((uint)piStack_2c[3] >> 4 & 1) == 0)))) {
      this = (void *)((int)param_1 + 0x34);
      FUN_10023620(this,(int *)apvStack_18);
      FUN_10023690(this,apvStack_18 + 1,apvStack_18,&iStack_28);
      pvVar9 = apvStack_18[1];
    }
    else {
      this = (void *)((int)param_1 + 0x44);
      FUN_10023620(this,(int *)&pvStack_20);
      FUN_10023690(this,&pvStack_1c,&pvStack_20,&iStack_28);
      pvVar9 = pvStack_1c;
    }
    if (pvVar9 == this) goto LAB_10020e19;
  }
  *(uint *)(iVar10 + 0x88) = *(uint *)(iVar10 + 0x88) | 8;
  piStack_2c = FUN_100150d0(iVar10);
  iVar10 = *(int *)(iVar6 + -0x52a + *(int *)(iVar7 + 0x5d));
  *(uint *)(iVar10 + 0x88) = *(uint *)(iVar10 + 0x88) & 0xfffffff7;
  if (piStack_2c != (int *)0x0) goto LAB_10020d52;
LAB_1002102f:
  FUN_10005260(piStack_30);
  FUN_10005260(piStack_2c);
LAB_10020e19:
  piVar1 = (int *)((int)param_1 + 0x34);
  piVar13 = *(int **)((int)param_1 + 0x38);
  while (piVar13 != piVar1) {
    ppiVar4 = (int **)piVar13[2];
    if (ppiVar4 != (int **)0x0) {
      FUN_1001e780(ppiVar4);
      _memFree(ppiVar4);
    }
    if ((piVar13 != piVar1) && (*(int *)((int)param_1 + 0x3c) != 0)) {
      piVar11 = (int *)piVar13[1];
      *(int **)(*piVar13 + 4) = piVar11;
      *(int *)piVar13[1] = *piVar13;
      piVar13[1] = 0;
      *piVar13 = 0;
      _memFree(piVar13);
      *(int *)((int)param_1 + 0x3c) = *(int *)((int)param_1 + 0x3c) + -1;
      piVar13 = piVar11;
    }
  }
  piVar13 = *(int **)((int)param_1 + 0x48);
  if (*(int **)((int)param_1 + 0x48) != (int *)((int)param_1 + 0x44)) {
    do {
      ppiVar4 = (int **)piVar13[2];
      if (ppiVar4 != (int **)0x0) {
        FUN_1001e780(ppiVar4);
        _memFree(ppiVar4);
      }
      piVar11 = piVar13;
      if ((piVar13 != piVar1) && (*(int *)((int)param_1 + 0x3c) != 0)) {
        piVar11 = (int *)piVar13[1];
        *(int **)(*piVar13 + 4) = piVar11;
        *(int *)piVar13[1] = *piVar13;
        piVar13[1] = 0;
        *piVar13 = 0;
        _memFree(piVar13);
        *(int *)((int)param_1 + 0x3c) = *(int *)((int)param_1 + 0x3c) + -1;
      }
      piVar13 = piVar11;
    } while (piVar11 != (int *)((int)param_1 + 0x44));
  }
  piVar1 = *(int **)((int)param_1 + 0x18);
  while (piVar1 != (int *)((int)param_1 + 0x14)) {
    ppiVar4 = (int **)piVar1[2];
    if (ppiVar4 != (int **)0x0) {
      FUN_1001fbf0(ppiVar4);
      _memFree(ppiVar4);
    }
    if ((piVar1 != (int *)((int)param_1 + 0x14)) && (*(int *)((int)param_1 + 0x1c) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)((int)param_1 + 0x1c) = *(int *)((int)param_1 + 0x1c) + -1;
      piVar1 = piVar13;
    }
  }
  piVar1 = *(int **)((int)param_1 + 0x28);
  while (piVar1 != (int *)((int)param_1 + 0x24)) {
    ppiVar4 = (int **)piVar1[2];
    if (ppiVar4 != (int **)0x0) {
      FUN_1001fbf0(ppiVar4);
      _memFree(ppiVar4);
    }
    if ((piVar1 != (int *)((int)param_1 + 0x24)) && (*(int *)((int)param_1 + 0x2c) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)((int)param_1 + 0x2c) = *(int *)((int)param_1 + 0x2c) + -1;
      piVar1 = piVar13;
    }
  }
  piVar1 = *(int **)((int)param_1 + 8);
  while (piVar1 != (int *)((int)param_1 + 4)) {
    if ((void *)piVar1[2] != (void *)0x0) {
      _memFree((void *)piVar1[2]);
    }
    if ((piVar1 != (int *)((int)param_1 + 4)) && (*(int *)((int)param_1 + 0xc) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)((int)param_1 + 0xc) = *(int *)((int)param_1 + 0xc) + -1;
      piVar1 = piVar13;
    }
  }
  return 0;
}
