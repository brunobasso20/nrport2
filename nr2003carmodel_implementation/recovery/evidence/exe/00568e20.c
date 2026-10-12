/* NR2003.exe @ 00568e20 FUN_00568e20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_00568e20(int param_1_00,int param_1,int param_3,float param_4,undefined4 param_5)

{
  int *piVar1;
  int *piVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  float10 fVar7;
  
  FUN_00568c60((undefined4 *)(param_1_00 + 0x196));
  piVar2 = (int *)(param_1_00 + 4);
  *(undefined4 *)(param_1_00 + 0x196) = *(undefined4 *)(param_1_00 + 4);
  iVar4 = *(int *)(param_1_00 + 0x19a);
  if (iVar4 != *(int *)(param_1_00 + 8)) {
    if (iVar4 != 0) {
      FUN_004c0e30();
    }
    *(int *)(param_1_00 + 0x19a) = *(int *)(param_1_00 + 8);
    FUN_004f0120();
  }
  *(undefined4 *)(param_1_00 + 0x19e) = *(undefined4 *)(param_1_00 + 0xc);
  puVar5 = (undefined4 *)(param_1_00 + 0x10);
  puVar6 = (undefined4 *)(param_1_00 + 0x1a2);
  for (iVar4 = 0x2a; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar6 = *puVar5;
    puVar5 = puVar5 + 1;
    puVar6 = puVar6 + 1;
  }
  *(undefined *)puVar6 = *(undefined *)puVar5;
  puVar5 = (undefined4 *)(param_1_00 + 0xb9);
  puVar6 = (undefined4 *)(param_1_00 + 0x24b);
  for (iVar4 = 0x2a; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar6 = *puVar5;
    puVar5 = puVar5 + 1;
    puVar6 = puVar6 + 1;
  }
  *(undefined *)puVar6 = *(undefined *)puVar5;
  *(undefined *)(param_1_00 + 0x2f4) = *(undefined *)(param_1_00 + 0x162);
  *(undefined *)(param_1_00 + 0x2f5) = *(undefined *)(param_1_00 + 0x163);
  *(undefined *)(param_1_00 + 0x2f6) = *(undefined *)(param_1_00 + 0x164);
  puVar5 = (undefined4 *)(param_1_00 + 0x2f7);
  iVar4 = 3;
  do {
    *puVar5 = *(undefined4 *)(((int)piVar2 - (param_1_00 + 0x196)) + (int)puVar5);
    puVar5 = puVar5 + 1;
    iVar4 = iVar4 + -1;
  } while (iVar4 != 0);
  *(undefined4 *)(param_1_00 + 0x303) = *(undefined4 *)(param_1_00 + 0x171);
  *(undefined4 *)(param_1_00 + 0x307) = *(undefined4 *)(param_1_00 + 0x175);
  *(undefined4 *)(param_1_00 + 0x30b) = *(undefined4 *)(param_1_00 + 0x179);
  *(undefined4 *)(param_1_00 + 0x30f) = *(undefined4 *)(param_1_00 + 0x17d);
  *(undefined4 *)(param_1_00 + 0x313) = *(undefined4 *)(param_1_00 + 0x181);
  *(undefined4 *)(param_1_00 + 0x317) = *(undefined4 *)(param_1_00 + 0x185);
  *(undefined *)(param_1_00 + 0x31b) = *(undefined *)(param_1_00 + 0x189);
  *(undefined4 *)(param_1_00 + 0x31c) = *(undefined4 *)(param_1_00 + 0x18a);
  *(undefined4 *)(param_1_00 + 800) = *(undefined4 *)(param_1_00 + 0x18e);
  if (*(int *)(param_1_00 + 0x324) != *(int *)(param_1_00 + 0x192)) {
    if (*(int *)(param_1_00 + 0x324) != 0) {
      FUN_004c0e30();
    }
    iVar4 = *(int *)(param_1_00 + 0x192);
    *(int *)(param_1_00 + 0x324) = iVar4;
    if (iVar4 != 0) {
      *(int *)(iVar4 + 4) = *(int *)(iVar4 + 4) + 1;
    }
  }
  *piVar2 = param_1;
  piVar1 = (int *)FUN_006c4980();
  puVar5 = *(undefined4 **)(param_1_00 + 8);
  if (puVar5 != (undefined4 *)*piVar1) {
    if ((puVar5 != (undefined4 *)0x0) &&
       (iVar4 = puVar5[1], puVar5[1] = iVar4 + -1, iVar4 + -1 == 0)) {
      (**(code **)*puVar5)(1);
    }
    iVar4 = *piVar1;
    *(int *)(param_1_00 + 8) = iVar4;
    if (iVar4 != 0) {
      *(int *)(iVar4 + 4) = *(int *)(iVar4 + 4) + 1;
    }
  }
  FUN_006c4a00();
  *(undefined4 *)(param_1_00 + 0xc) = param_5;
  if ((param_3 == 1) || (*(int *)(param_1_00 + 0x196) != *piVar2)) {
    *(undefined *)(param_1_00 + 0x162) = 0;
    piVar2 = (int *)FUN_004ed0c0();
    puVar5 = *(undefined4 **)(param_1_00 + 0x192);
    if (puVar5 != (undefined4 *)*piVar2) {
      if ((puVar5 != (undefined4 *)0x0) &&
         (iVar4 = puVar5[1], puVar5[1] = iVar4 + -1, iVar4 + -1 == 0)) {
        (**(code **)*puVar5)(1);
      }
      iVar4 = *piVar2;
      *(int *)(param_1_00 + 0x192) = iVar4;
      if (iVar4 != 0) {
        *(int *)(iVar4 + 4) = *(int *)(iVar4 + 4) + 1;
      }
    }
    FUN_004ed160();
  }
  switch(param_1) {
  case 1:
    if ((*(int *)(param_1_00 + 0x196) == 2) || (*(int *)(param_1_00 + 0x196) == 3)) {
      *(undefined4 *)(param_1_00 + 0x348) = 0;
      fVar7 = (float10)FUN_00569210(*(undefined4 *)(param_1_00 + 0x344));
      fVar7 = (float10)FUN_00569260((float)fVar7);
      *(float *)(param_1_00 + 0x344) = (float)fVar7;
    }
    else {
      *(undefined4 *)(param_1_00 + 0x348) = 0;
      *(undefined4 *)(param_1_00 + 0x344) = 0;
    }
    break;
  case 2:
  case 3:
    *(undefined4 *)(param_1_00 + 0x348) = 0x3f800000;
    if (*(int *)(param_1_00 + 0x196) == 1) {
      fVar7 = (float10)FUN_00569250(*(undefined4 *)(param_1_00 + 0x344));
      fVar7 = (float10)FUN_00569230((float)fVar7);
      *(float *)(param_1_00 + 0x344) = (float)fVar7;
    }
    else {
      *(undefined4 *)(param_1_00 + 0x344) = 0;
    }
    if (param_1 == 2) {
      *(undefined4 *)(param_1_00 + 0x350) = 0x3f800000;
    }
    else {
      *(undefined4 *)(param_1_00 + 0x350) = 0xbf800000;
    }
    break;
  case 0x10:
    if (*(int *)(param_1_00 + 0x196) == 0x10) {
      *(undefined4 *)(param_1_00 + 0x171) = *(undefined4 *)(param_1_00 + 0x303);
      *(undefined4 *)(param_1_00 + 0x175) = *(undefined4 *)(param_1_00 + 0x307);
      *(undefined4 *)(param_1_00 + 0x179) = *(undefined4 *)(param_1_00 + 0x30b);
      *(undefined4 *)(param_1_00 + 0x17d) = *(undefined4 *)(param_1_00 + 0x30f);
      *(undefined4 *)(param_1_00 + 0x181) = *(undefined4 *)(param_1_00 + 0x313);
      *(undefined4 *)(param_1_00 + 0x185) = *(undefined4 *)(param_1_00 + 0x317);
    }
    break;
  case 0x13:
  case 0x14:
  case 0x15:
    *(undefined4 *)(param_1_00 + 0x165) = 0xffffffff;
    *(undefined4 *)(param_1_00 + 0x169) = 0xffffffff;
    *(undefined4 *)(param_1_00 + 0x16d) = 0xffffffff;
  }
  if (param_3 == 0) {
    iVar4 = taskGetRate();
    if (_DAT_006e97d8 / (float)iVar4 < param_4 !=
        (NAN(_DAT_006e97d8 / (float)iVar4) || NAN(param_4))) {
      *(undefined4 *)(param_1_00 + 0x334) = 0;
      *(undefined4 *)(param_1_00 + 0x338) = 0;
      iVar4 = taskGetRate();
      *(undefined4 *)(param_1_00 + 0x340) = 0;
      *(float *)(param_1_00 + 0x33c) = _DAT_006e97d8 / ((float)iVar4 * param_4);
      return;
    }
    FUN_00568c60(param_1_00 + 0x196);
    *(undefined4 *)(param_1_00 + 0x338) = 0x3f800000;
    *(undefined4 *)(param_1_00 + 0x33c) = 0;
    *(undefined4 *)(param_1_00 + 0x340) = 0;
  }
  else if (param_3 == 1) {
    FUN_00568c60(param_1_00 + 0x196);
    *(undefined4 *)(param_1_00 + 0x338) = 0x3f800000;
    *(undefined4 *)(param_1_00 + 0x33c) = 0;
    taskGetRate();
    uVar3 = FUN_006c5018();
    *(undefined4 *)(param_1_00 + 0x340) = uVar3;
    return;
  }
  return;
}

