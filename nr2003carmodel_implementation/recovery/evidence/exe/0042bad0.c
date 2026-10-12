/* NR2003.exe @ 0042bad0 FUN_0042bad0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0042bad0(int param_1,int param_2)

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
    if (*(undefined4 **)(param_1 + 0x338) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x338))(0);
    }
    piVar7 = *(int **)(param_1 + 0x33c);
    if (piVar7 != (int *)0x0) goto LAB_0042bbaa;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0x338) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x338))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0x33c);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042bbaa:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  if ((NAN(local_2c[0]) || NAN(_DAT_006ea4a0)) == (local_2c[0] == _DAT_006ea4a0)) {
    uVar11 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x340) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x340))(0);
    }
    piVar7 = *(int **)(param_1 + 0x344);
    if (piVar7 != (int *)0x0) goto LAB_0042bc15;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0x340) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x340))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0x344);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042bc15:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  if ((NAN(local_2c[2]) || NAN(_DAT_006ea4a0)) == (local_2c[2] == _DAT_006ea4a0)) {
    uVar10 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x348) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x348))(0);
    }
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0x348) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x348))(0x3f800000);
    }
    uVar10 = 0xff;
  }
  if ((NAN(local_2c[3]) || NAN(_DAT_006ea4a0)) == (local_2c[3] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x34c) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x34c))(0);
    }
    uVar10 = uVar10 | iVar6 << 8;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0x34c) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x34c))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff00;
  }
  if ((NAN(local_2c[4]) || NAN(_DAT_006ea4a0)) == (local_2c[4] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x350) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x350))(0);
    }
    uVar10 = uVar10 | iVar6 << 0x10;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0x350) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x350))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff0000;
  }
  if ((NAN(local_2c[5]) || NAN(_DAT_006ea4a0)) == (local_2c[5] == _DAT_006ea4a0)) {
    iVar6 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x354) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x354))(0);
    }
    uVar10 = uVar10 | iVar6 << 0x18;
  }
  else {
    bVar3 = true;
    if (*(undefined4 **)(param_1 + 0x354) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x354))(0x3f800000);
    }
    uVar10 = uVar10 | 0xff000000;
  }
  if (*(int **)(param_1 + 0x358) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x358) + 4))(uVar10);
  }
  if ((NAN(local_2c[6]) || NAN(_DAT_006ea4a0)) == (local_2c[6] == _DAT_006ea4a0)) {
    uVar11 = FUN_006c5018();
    if (*(undefined4 **)(param_1 + 0x35c) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x35c))(0);
    }
    piVar7 = *(int **)(param_1 + 0x360);
    if (piVar7 != (int *)0x0) goto LAB_0042bde0;
  }
  else {
    bVar2 = true;
    if (*(undefined4 **)(param_1 + 0x35c) != (undefined4 *)0x0) {
      (**(code **)**(undefined4 **)(param_1 + 0x35c))(0x3f800000);
    }
    piVar7 = *(int **)(param_1 + 0x360);
    if (piVar7 != (int *)0x0) {
      uVar11 = 0xff;
LAB_0042bde0:
      (**(code **)(*piVar7 + 4))(uVar11);
    }
  }
  iVar6 = FUN_006c5018();
  uVar10 = FUN_006c5018();
  uVar4 = FUN_006c5018();
  uVar5 = FUN_006c5018();
  if ((0 < iVar6) && (*(undefined4 **)(param_1 + 800) != (undefined4 *)0x0)) {
    (**(code **)**(undefined4 **)(param_1 + 800))(0);
  }
  if (*(int **)(param_1 + 0x364) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x364) + 4))
              (((uVar10 | iVar6 << 8) << 8 | uVar4) << 8 | uVar5);
  }
  if (local_30 == 0) {
    puVar8 = *(undefined4 **)(param_1 + 0x368);
LAB_0042bed0:
    if (puVar8 != (undefined4 *)0x0) {
      (**(code **)*puVar8)(0);
    }
  }
  else {
    if (local_30 == 1) {
      puVar8 = *(undefined4 **)(param_1 + 0x368);
    }
    else {
      if (local_30 != 2) {
        return;
      }
      if (*(undefined4 **)(param_1 + 0x368) != (undefined4 *)0x0) {
        (**(code **)**(undefined4 **)(param_1 + 0x368))(0x40000000);
      }
      puVar8 = *(undefined4 **)(param_1 + 0x36c);
      if (bVar2) {
        if (puVar8 != (undefined4 *)0x0) {
          (**(code **)*puVar8)(0x3f800000);
        }
      }
      else if (puVar8 != (undefined4 *)0x0) {
        (**(code **)*puVar8)(0);
      }
      puVar8 = *(undefined4 **)(param_1 + 0x370);
      if (!bVar3) goto LAB_0042bed0;
    }
    if (puVar8 != (undefined4 *)0x0) {
      (**(code **)*puVar8)(0x3f800000);
      return;
    }
  }
  return;
}

