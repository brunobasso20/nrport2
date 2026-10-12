/* NR2003.exe @ 0042b6c0 FUN_0042b6c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0042b6c0(int param_1,int param_2)

{
  float fVar1;
  bool bVar2;
  bool bVar3;
  uint uVar4;
  uint uVar5;
  int iVar6;
  int *piVar7;
  undefined4 *puVar8;
  float *pfVar9;
  uint uVar10;
  undefined4 uVar11;
  uint local_30;
  float local_2c [11];
  
  bVar2 = false;
  local_30 = 0;
  bVar3 = false;
  iVar6 = 0;
  pfVar9 = (float *)(param_2 + 0xa0);
  do {
    fVar1 = *pfVar9;
    local_2c[iVar6] = fVar1;
    if (_DAT_006ea454 < fVar1) {
      if (local_30 == 0) {
        local_30 = 1;
      }
      if (((NAN(fVar1) || NAN(_DAT_006ea4a0)) != (fVar1 == _DAT_006ea4a0)) && (local_30 < 2)) {
        local_30 = 2;
      }
    }
    iVar6 = iVar6 + 1;
    pfVar9 = pfVar9 + 1;
  } while (iVar6 < 0xb);
  if ((NAN(local_2c[1]) || NAN(_DAT_006ea4a0)) == (local_2c[1] == _DAT_006ea4a0)) {
    uVar11 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xbc) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xbc))(0);
    }
    piVar7 = *(int **)(param_1 + 0xa0);
    if (piVar7 != (int *)0x0) goto LAB_0042b79a;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0xbc) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xbc))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0xa0);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042b79a:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  if ((NAN(local_2c[0]) || NAN(_DAT_006ea4a0)) == (local_2c[0] == _DAT_006ea4a0)) {
    uVar11 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xc4) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xc4))(0);
    }
    piVar7 = *(int **)(param_1 + 0xa8);
    if (piVar7 != (int *)0x0) goto LAB_0042b805;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0xc4) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xc4))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0xa8);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042b805:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  if ((NAN(local_2c[2]) || NAN(_DAT_006ea4a0)) == (local_2c[2] == _DAT_006ea4a0)) {
    uVar10 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xb0) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb0))(0);
    }
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0xb0) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb0))(0x3f800000);
    }
    uVar10 = 0xff;
  }
  if ((NAN(local_2c[3]) || NAN(_DAT_006ea4a0)) == (local_2c[3] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xac) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xac))(0);
    }
    uVar10 = uVar10 | iVar6 << 8;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0xac) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xac))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff00;
  }
  if ((NAN(local_2c[4]) || NAN(_DAT_006ea4a0)) == (local_2c[4] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xb8) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb8))(0);
    }
    uVar10 = uVar10 | iVar6 << 0x10;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0xb8) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb8))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff0000;
  }
  if ((NAN(local_2c[5]) || NAN(_DAT_006ea4a0)) == (local_2c[5] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xb4) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb4))(0);
    }
    uVar10 = uVar10 | iVar6 << 0x18;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0xb4) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xb4))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff000000;
  }
  if (*(int **)(param_1 + 0x9c) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x9c) + 4))(uVar10);
  }
  if ((NAN(local_2c[6]) || NAN(_DAT_006ea4a0)) == (local_2c[6] == _DAT_006ea4a0)) {
    uVar11 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0xc0) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xc0))(0);
    }
    piVar7 = *(int **)(param_1 + 0xa4);
    if (piVar7 != (int *)0x0) goto LAB_0042b9d0;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0xc0) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0xc0))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0xa4);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042b9d0:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  iVar6 = FUN_006c5018();
  uVar10 = FUN_006c5018();
  uVar4 = FUN_006c5018();
  uVar5 = FUN_006c5018();
  if ((0 < iVar6) && (*(undefined4 **)(param_1 + 0x54) != (undefined4 *)0x0)) {
    (**(code **)**(undefined4 **)(param_1 + 0x54))(0);
  }
  if (*(int **)(param_1 + 0x98) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x98) + 4))(((uVar10 | iVar6 << 8) << 8 | uVar4) << 8 | uVar5)
    ;
  }
  if (local_30 == 0) {
    puVar8 = *(undefined4 **)(param_1 + 0xd0);
LAB_0042babd:
    if (puVar8 != (undefined4 *)0x0) {
      (**(code **)*puVar8)(0);
    }
  }
  else {
    if (local_30 == 1) {
      puVar8 = *(undefined4 **)(param_1 + 0xd0);
    }
    else {
      if (local_30 != 2) {
        return;
      }
      if (*(undefined4 **)(param_1 + 0xd0) != (undefined4 *)0x0) {
        (**(code **)**(undefined4 **)(param_1 + 0xd0))(0x40000000);
      }
      puVar8 = *(undefined4 **)(param_1 + 200);
      if (bVar2) {
        if (puVar8 != (undefined4 *)0x0) {
          (**(code **)*puVar8)(0x3f800000);
        }
      }
      else if (puVar8 != (undefined4 *)0x0) {
        (**(code **)*puVar8)(0);
      }
      puVar8 = *(undefined4 **)(param_1 + 0xcc);
      if (!bVar3) goto LAB_0042babd;
    }
    if (puVar8 != (undefined4 *)0x0) {
      (**(code **)*puVar8)(0x3f800000);
      return;
    }
  }
  return;
}

