/* rend_dxg.dll @ 10047770 FUN_10047770 */

undefined4 __fastcall FUN_10047770(int param_1)

{
  int *piVar1;
  uint *puVar2;
  int iVar3;
  void *pvVar4;
  undefined4 *puVar5;
  int iVar6;
  int iVar7;
  success sVar8;
  uint uVar9;
  int iVar10;
  int *piVar11;
  int iVar12;
  int *piVar13;
  undefined4 *puVar14;
  int local_30;
  int iStack_28;
  int iStack_24;
  int iStack_1c;
  undefined4 *puStack_18;
  void *pvStack_14;
  undefined auStack_10 [4];
  int iStack_c;
  undefined auStack_8 [4];
  int iStack_4;

  local_30 = 1;
  do {
    iVar6 = FUN_10049260();
    if (iVar6 == 0) {
      if (local_30 != 0) {
        return 1;
      }
      break;
    }
    iVar7 = (**(code **)(**(int **)(*(int *)(param_1 + 0x70) + 0x18) + 0x20))();
    iVar6 = *(int *)(iVar7 + 0x59);
    FUN_10047350(iVar7);
    if (*(int *)(iVar7 + 0x4d) == 0) {
      iVar12 = 0;
    }
    else {
      iVar12 = *(int *)(*(int *)(iVar7 + 0x4d) + 4);
    }
    uVar9 = iVar12 * 8 + 0x10;
    sVar8 = _memAlloc(&puStack_18,uVar9);
    puVar5 = puStack_18;
    if ((sVar8 != 0) && (puStack_18 != (undefined4 *)0x0)) {
      iVar12 = 0;
      puVar14 = puStack_18;
      for (uVar9 = uVar9 >> 2; uVar9 != 0; uVar9 = uVar9 - 1) {
        *puVar14 = 0;
        puVar14 = puVar14 + 1;
      }
      *(undefined4 *)(param_1 + 0x54) = 0;
      for (iVar10 = 0; iVar10 != 0; iVar10 = iVar10 + -1) {
        *(undefined *)puVar14 = 0;
        puVar14 = (undefined4 *)((int)puVar14 + 1);
      }
      *(int *)(param_1 + 0x58) = iVar6;
      if (0 < iVar6) {
        do {
          iVar10 = FUN_10047ca0();
          if (iVar10 != 0) {
            *puVar5 = *(undefined4 *)(*(int *)(param_1 + 0x78) + 8);
            iVar12 = 1;
            while (local_30 != 0) {
              iVar10 = FUN_10047d50();
              if (iVar10 == 0) {
                if (local_30 != 0) goto LAB_10047860;
                break;
              }
              puVar5[iVar12] = *(undefined4 *)(*(int *)(param_1 + 0x78) + 8);
              local_30 = FUN_10047e10();
              iVar12 = iVar12 + 1;
            }
            local_30 = 1;
          }
LAB_10047860:
          *(int *)(param_1 + 0x54) = *(int *)(param_1 + 0x54) + 1;
        } while (*(int *)(param_1 + 0x54) < iVar6);
      }
      if (((local_30 == 0) || (*(int *)(iVar7 + 0x4d) != 0)) ||
         (iVar7 = (**(code **)(**(int **)(*(int *)(param_1 + 0x70) + 0x18) + 0x20))(), iVar12 < 3))
      goto LAB_10047a74;
      iVar10 = *(int *)(iVar7 + 0x5d);
      iStack_28 = 0;
      iStack_24 = 0;
      iVar3 = *(int *)(iVar10 + 0xc);
      if (iVar3 != 0) {
        *(uint *)(iVar3 + 0x88) = *(uint *)(iVar3 + 0x88) | 8;
        iStack_28 = FUN_10007060(iVar3,1,0);
        iVar10 = *(int *)(iVar7 + 0x5d);
        puVar2 = (uint *)(*(int *)(iVar10 + 0xc) + 0x88);
        *puVar2 = *puVar2 & 0xfffffff7;
        if (iStack_28 == 0) {
          local_30 = 0;
        }
      }
      iVar6 = iVar6 * 0x53a;
      iVar10 = *(int *)(iVar6 + -0x52a + iVar10);
      if (iVar10 == 0) {
LAB_1004794c:
        if (local_30 == 0) goto LAB_10047a50;
        sVar8 = _memAlloc(&pvStack_14,600);
        if ((sVar8 == 0) || (pvStack_14 == (void *)0x0)) {
          iStack_1c = 0;
          goto LAB_10047a67;
        }
        iVar6 = iVar6 + *(int *)(iVar7 + 0x5d);
        iStack_1c = FUN_10044430(iStack_28,iStack_24,*puVar5,puVar5[1],puVar5[iVar12 + -2],
                                 puVar5[iVar12 + -1],*(undefined4 *)(iVar6 + -0x51a),
                                 *(undefined4 *)(iVar6 + -0x516));
        if (iStack_1c == 0) goto LAB_10047a67;
        if (((iStack_28 == 0) || ((*(uint *)(iStack_28 + 0xc) >> 4 & 1) == 0)) &&
           ((iStack_24 == 0 || ((*(uint *)(iStack_24 + 0xc) >> 4 & 1) == 0)))) {
          FUN_1004a6f0(auStack_8);
          FUN_1005f870(&iStack_4,auStack_8,&iStack_1c);
          if (iStack_4 == param_1 + 0x34) goto LAB_10047a67;
        }
        else {
          FUN_1004a6f0(auStack_10);
          FUN_1005f870(&iStack_c,auStack_10,&iStack_1c);
          if (iStack_c == param_1 + 0x44) goto LAB_10047a67;
        }
      }
      else {
        *(uint *)(iVar10 + 0x88) = *(uint *)(iVar10 + 0x88) | 8;
        iStack_24 = FUN_10007060(iVar10,1,0);
        iVar10 = *(int *)(iVar6 + -0x52a + *(int *)(iVar7 + 0x5d));
        *(uint *)(iVar10 + 0x88) = *(uint *)(iVar10 + 0x88) & 0xfffffff7;
        if (iStack_24 != 0) goto LAB_1004794c;
LAB_10047a50:
        FUN_100073d0(iStack_28);
        FUN_100073d0(iStack_24);
LAB_10047a67:
        local_30 = 0;
      }
LAB_10047a74:
      _memFree(puVar5);
    }
  } while (local_30 != 0);
  piVar1 = (int *)(param_1 + 0x34);
  piVar13 = *(int **)(param_1 + 0x38);
  while (piVar13 != piVar1) {
    pvVar4 = (void *)piVar13[2];
    if (pvVar4 != (void *)0x0) {
      FUN_10044680();
      _memFree(pvVar4);
    }
    if ((piVar13 != piVar1) && (*(int *)(param_1 + 0x3c) != 0)) {
      piVar11 = (int *)piVar13[1];
      *(int **)(*piVar13 + 4) = piVar11;
      *(int *)piVar13[1] = *piVar13;
      piVar13[1] = 0;
      *piVar13 = 0;
      _memFree(piVar13);
      *(int *)(param_1 + 0x3c) = *(int *)(param_1 + 0x3c) + -1;
      piVar13 = piVar11;
    }
  }
  piVar13 = *(int **)(param_1 + 0x48);
  if (*(int **)(param_1 + 0x48) != (int *)(param_1 + 0x44)) {
    do {
      pvVar4 = (void *)piVar13[2];
      if (pvVar4 != (void *)0x0) {
        FUN_10044680();
        _memFree(pvVar4);
      }
      piVar11 = piVar13;
      if ((piVar13 != piVar1) && (*(int *)(param_1 + 0x3c) != 0)) {
        piVar11 = (int *)piVar13[1];
        *(int **)(*piVar13 + 4) = piVar11;
        *(int *)piVar13[1] = *piVar13;
        piVar13[1] = 0;
        *piVar13 = 0;
        _memFree(piVar13);
        *(int *)(param_1 + 0x3c) = *(int *)(param_1 + 0x3c) + -1;
      }
      piVar13 = piVar11;
    } while (piVar11 != (int *)(param_1 + 0x44));
  }
  piVar1 = *(int **)(param_1 + 0x18);
  while (piVar1 != (int *)(param_1 + 0x14)) {
    pvVar4 = (void *)piVar1[2];
    if (pvVar4 != (void *)0x0) {
      FUN_10045ea0();
      _memFree(pvVar4);
    }
    if ((piVar1 != (int *)(param_1 + 0x14)) && (*(int *)(param_1 + 0x1c) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)(param_1 + 0x1c) = *(int *)(param_1 + 0x1c) + -1;
      piVar1 = piVar13;
    }
  }
  piVar1 = *(int **)(param_1 + 0x28);
  while (piVar1 != (int *)(param_1 + 0x24)) {
    pvVar4 = (void *)piVar1[2];
    if (pvVar4 != (void *)0x0) {
      FUN_10045ea0();
      _memFree(pvVar4);
    }
    if ((piVar1 != (int *)(param_1 + 0x24)) && (*(int *)(param_1 + 0x2c) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)(param_1 + 0x2c) = *(int *)(param_1 + 0x2c) + -1;
      piVar1 = piVar13;
    }
  }
  piVar1 = *(int **)(param_1 + 8);
  while (piVar1 != (int *)(param_1 + 4)) {
    if ((void *)piVar1[2] != (void *)0x0) {
      _memFree((void *)piVar1[2]);
    }
    if ((piVar1 != (int *)(param_1 + 4)) && (*(int *)(param_1 + 0xc) != 0)) {
      piVar13 = (int *)piVar1[1];
      *(int **)(*piVar1 + 4) = piVar13;
      *(int *)piVar1[1] = *piVar1;
      piVar1[1] = 0;
      *piVar1 = 0;
      _memFree(piVar1);
      *(int *)(param_1 + 0xc) = *(int *)(param_1 + 0xc) + -1;
      piVar1 = piVar13;
    }
  }
  return 0;
}
