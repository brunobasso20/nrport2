/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052b520 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052b520(float param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  byte bVar4;
  float10 fVar5;
  float fVar6;
  undefined1 *puVar7;
  undefined1 auStack_18 [4];
  undefined1 auStack_14 [4];
  float fStack_10;
  float local_8;
  float local_4;
  
  if (*(int *)((int)param_1 + 4) == 0) {
    return;
  }
  *(undefined4 *)((int)param_1 + 0x1b79) = *(undefined4 *)((int)param_1 + 0x1b71);
  *(undefined4 *)((int)param_1 + 0x1b75) = *(undefined4 *)((int)param_1 + 0x1b71);
  *(undefined4 *)((int)param_1 + 0x1bad) = *(undefined4 *)((int)param_1 + 0x1b85);
  *(undefined4 *)((int)param_1 + 0x1bb1) = *(undefined4 *)((int)param_1 + 0x1b89);
  iVar3 = 8;
  do {
    FUN_00530110(param_1);
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  local_4 = *(float *)((int)param_1 + 0x1b85) + *(float *)((int)param_1 + 0x1b89);
  if (ABS(local_4) < _DAT_006ea4cc) {
    fVar1 = *(float *)((int)param_1 + 0x1b95);
    if (*(float *)((int)param_1 + 0x1b95) < *(float *)((int)param_1 + 0x1bad)) {
      fVar1 = *(float *)((int)param_1 + 0x1bad);
    }
    *(float *)((int)param_1 + 0x1bad) = fVar1;
    local_4 = *(float *)((int)param_1 + 0x1bb1);
    fVar1 = *(float *)((int)param_1 + 0x1b99);
    if (*(float *)((int)param_1 + 0x1b99) < local_4) {
      fVar1 = local_4;
    }
    *(float *)((int)param_1 + 0x1bb1) = fVar1;
  }
  local_8 = *(float *)((int)param_1 + 0x1bb1) + *(float *)((int)param_1 + 0x1bad);
  fVar1 = *(float *)((int)param_1 + 0x186e);
  fVar5 = (float10)(**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x40))();
  if ((float)fVar5 < fStack_10) {
    fStack_10 = (float)fVar5 / fStack_10;
    *(float *)((int)param_1 + 0x1bad) = fStack_10 * *(float *)((int)param_1 + 0x1bad);
    *(float *)((int)param_1 + 0x1bb1) = fStack_10 * *(float *)((int)param_1 + 0x1bb1);
  }
  puVar7 = auStack_14;
  (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x48))
            (param_1,*(undefined4 *)((int)param_1 + 0x186e));
  iVar3 = (**(code **)(**(int **)((int)param_1 + 0x13b3) + 0x4c))(param_1);
  fVar2 = *(float *)((int)param_1 + 0x1886) -
          *(float *)(*(int *)(iVar3 + 0xc) + 0x14 + *(int *)((int)param_1 + 0x186e) * 0x1c);
  if (fVar1 <= *(float *)((int)param_1 + 0x1ba1)) {
    fVar6 = fVar1;
    if (fVar1 < *(float *)((int)param_1 + 0x1ba5)) {
      fVar6 = *(float *)((int)param_1 + 0x1ba5);
    }
  }
  else {
    fVar6 = *(float *)((int)param_1 + 0x1ba1);
  }
  if (fVar6 == fVar1) goto LAB_0052b880;
  if (fVar1 <= fVar6) {
    fVar1 = (fVar6 - param_1 * *(float *)((int)param_1 + 0x1bad)) / (float)puVar7;
    *(float *)((int)param_1 + 0x1bb1) = fVar1;
    if (fVar1 + *(float *)((int)param_1 + 0x1bad) <= (float)auStack_18) goto LAB_0052b880;
    fVar1 = (float)auStack_18 - *(float *)((int)param_1 + 0x1bad);
    *(float *)((int)param_1 + 0x1bb1) = fVar1;
    if ((float)puVar7 * (float)auStack_18 <= fVar6) goto LAB_0052b880;
    fVar6 = (param_1 * *(float *)((int)param_1 + 0x1bad) + fVar1 * (float)puVar7) - fVar6;
    *(float *)((int)param_1 + 0x1bad) = fVar6 + *(float *)((int)param_1 + 0x1bad);
    *(float *)((int)param_1 + 0x1bb1) = *(float *)((int)param_1 + 0x1bb1) - fVar6;
    if (*(float *)((int)param_1 + 0x1bad) < _DAT_006ea454) {
      *(undefined4 *)((int)param_1 + 0x1bad) = 0;
    }
    bVar4 = *(float *)((int)param_1 + 0x1bb1) < _DAT_006ea454 |
            (byte)((ushort)((ushort)(NAN(*(float *)((int)param_1 + 0x1bb1)) || NAN(_DAT_006ea454))
                           << 10) >> 8);
  }
  else {
    fVar1 = (fVar6 - (float)puVar7 * *(float *)((int)param_1 + 0x1bb1)) / param_1;
    *(float *)((int)param_1 + 0x1bad) = fVar1;
    if (fVar1 + *(float *)((int)param_1 + 0x1bb1) <= (float)auStack_18) goto LAB_0052b880;
    fVar1 = (float)auStack_18 - *(float *)((int)param_1 + 0x1bb1);
    *(float *)((int)param_1 + 0x1bad) = fVar1;
    if (fVar6 <= param_1 * (float)auStack_18) goto LAB_0052b880;
    fVar6 = ((float)puVar7 * *(float *)((int)param_1 + 0x1bb1) + param_1 * fVar1) - fVar6;
    *(float *)((int)param_1 + 0x1bad) = fVar1 + fVar6;
    fVar6 = *(float *)((int)param_1 + 0x1bb1) - fVar6;
    *(float *)((int)param_1 + 0x1bb1) = fVar6;
    if (*(float *)((int)param_1 + 0x1bad) < _DAT_006ea454) {
      *(undefined4 *)((int)param_1 + 0x1bad) = 0;
    }
    bVar4 = fVar6 < _DAT_006ea454 |
            (byte)((ushort)((ushort)(NAN(fVar6) || NAN(_DAT_006ea454)) << 10) >> 8);
  }
  if ((POPCOUNT(bVar4) & 1U) != 0) {
    *(undefined4 *)((int)param_1 + 0x1bb1) = 0;
  }
LAB_0052b880:
  fVar1 = *(float *)((int)param_1 + 0x1ba1) - *(float *)((int)param_1 + 0x1ba5);
  *(undefined4 *)((int)param_1 + 0x1ba9) = 0x3f800000;
  if (fVar1 < _DAT_006f51cc) {
    *(float *)((int)param_1 + 0x1ba9) = fVar1 * _DAT_006f51c8 + _DAT_006efb28;
  }
  fVar1 = *(float *)((int)param_1 + 0x1ba1) - fVar2;
  fVar2 = fVar2 - *(float *)((int)param_1 + 0x1ba5);
  if (fVar2 < fVar1) {
    fVar1 = fVar2;
  }
  fVar2 = _DAT_006ea454;
  if ((_DAT_006ea454 <= fVar1) && (fVar2 = fVar1, _DAT_006ef678 <= fVar1)) {
    return;
  }
  *(float *)((int)param_1 + 0x1ba9) =
       (fVar2 * _DAT_006f51c8 + _DAT_006ed020) * *(float *)((int)param_1 + 0x1ba9);
  return;
}


