/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00510f00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_00510f00(int param_1,float param_2,int param_3)

{
  double dVar1;
  double dVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  double dVar5;
  double dVar6;
  int *piVar7;
  float10 fVar8;
  undefined4 in_stack_ffffff74;
  undefined4 in_stack_ffffff78;
  undefined8 in_stack_ffffff7c;
  undefined8 in_stack_ffffff84;
  undefined8 in_stack_ffffff8c;
  undefined8 in_stack_ffffff94;
  undefined8 in_stack_ffffff9c;
  undefined8 in_stack_ffffffa4;
  undefined8 in_stack_ffffffac;
  undefined8 in_stack_ffffffb4;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  undefined8 in_stack_ffffffd4;
  double dVar13;
  undefined8 in_stack_ffffffdc;
  double dVar14;
  double local_14;
  
  uVar11 = *(undefined4 *)(param_1 + 0x10);
  uVar12 = *(undefined4 *)(param_1 + 0x14);
  dVar1 = *(double *)(param_1 + 0x10);
  uVar9 = *(undefined4 *)(param_1 + 0x18);
  uVar10 = *(undefined4 *)(param_1 + 0x1c);
  dVar2 = *(double *)(param_1 + 0x18);
  uVar3 = *(undefined4 *)(param_1 + 0x28);
  uVar4 = *(undefined4 *)(param_1 + 0x2c);
  dVar13 = *(double *)(param_1 + 0x28);
  dVar14 = *(double *)(param_1 + 0x30);
  piVar7 = (int *)(DAT_00bcf734 + param_3 * 0x1550);
  *piVar7 = (*(int *)(param_1 + 0xc) != 0) + 1;
  piVar7[0x16] = *(int *)(param_1 + 0x46);
  piVar7[0x15] = *(int *)(param_1 + 0x42);
  piVar7[0x17] = 0;
  piVar7[0x18] = -1;
  piVar7[0x19] = -1;
  piVar7[1] = (int)param_2;
  piVar7[7] = 0;
  piVar7[0x551] = 0;
  piVar7[0x550] = 0;
  piVar7[0x553] = 0;
  piVar7[0x552] = 0;
  if (*piVar7 == 1) {
    dVar13 = dVar13 - dVar1;
    dVar14 = dVar14 - dVar2;
    fVar8 = (float10)FUN_006c6ea0(in_stack_ffffff74,in_stack_ffffff78,in_stack_ffffff7c,
                                  in_stack_ffffff84,in_stack_ffffff8c,in_stack_ffffff94,
                                  in_stack_ffffff9c,in_stack_ffffffa4,in_stack_ffffffac,
                                  in_stack_ffffffb4,uVar9,uVar10,uVar3,uVar4,uVar11,uVar12,dVar13,
                                  dVar14);
    dVar1 = (double)fVar8;
    dVar13 = dVar13 / dVar1;
    dVar14 = dVar14 / dVar1;
    piVar7[2] = (int)(float)fVar8;
    piVar7[3] = (int)(float)((float10)_DAT_006e9808 / (float10)dVar1);
    piVar7[4] = 0;
    piVar7[5] = (int)(float)(((float10)dVar1 + (float10)_DAT_006f4640) / (float10)dVar1);
    piVar7[0xe] = (int)(float)dVar13;
    piVar7[0xf] = (int)(float)dVar14;
    piVar7[0x10] = (int)-(float)piVar7[0xf];
    piVar7[0x11] = piVar7[0xe];
    piVar7[0xe] = (int)((float)piVar7[0xe] * (float)piVar7[3]);
    piVar7[0xf] = (int)((float)piVar7[0xf] * (float)piVar7[3]);
    piVar7[0xc] = (int)(float)(double)CONCAT44(uVar12,uVar11);
    piVar7[0xd] = (int)(float)(double)CONCAT44(uVar10,uVar9);
  }
  else {
    local_14 = *(double *)(param_1 + 0x38) - *(double *)(param_1 + 0x20);
    if (local_14 <= _DAT_006e97f8) {
      if (local_14 < _DAT_006f4638) {
        local_14 = _DAT_006efb78 + local_14;
      }
    }
    else {
      local_14 = local_14 - _DAT_006efb78;
    }
    piVar7[0x13] = (int)(float)*(double *)(param_1 + 0x20);
    piVar7[0x14] = (int)(float)local_14;
    piVar7[0x12] = (int)(float)((float10)_DAT_006e9808 / (float10)local_14);
    fVar8 = (float10)FUN_006c6df0(in_stack_ffffff74,in_stack_ffffff78,in_stack_ffffff7c,
                                  in_stack_ffffff84,in_stack_ffffff8c,in_stack_ffffff94,
                                  in_stack_ffffff9c,in_stack_ffffffa4,in_stack_ffffffac,
                                  in_stack_ffffffb4,uVar9,uVar10,uVar3,uVar4,uVar11,uVar12,
                                  in_stack_ffffffd4,in_stack_ffffffdc);
    dVar13 = (double)fVar8;
    fVar8 = (float10)FUN_006c6d40();
    dVar14 = (double)fVar8;
    dVar1 = *(double *)(param_1 + 0x28) - *(double *)(param_1 + 0x10);
    dVar2 = *(double *)(param_1 + 0x30) - *(double *)(param_1 + 0x18);
    dVar5 = dVar2 * dVar13 - dVar1 * dVar14;
    dVar5 = (dVar2 * dVar2 + dVar1 * dVar1) / (dVar5 + dVar5);
    dVar6 = local_14 * dVar5;
    dVar1 = *(double *)(param_1 + 0x10);
    dVar2 = *(double *)(param_1 + 0x18);
    piVar7[0x11] = (int)(float)dVar5;
    piVar7[0xc] = (int)(float)(dVar1 - dVar5 * dVar14);
    piVar7[0xd] = (int)(float)(dVar5 * dVar13 + dVar2);
    piVar7[0xe] = (int)(float)fVar8;
    piVar7[0xf] = (int)-(float)dVar13;
    piVar7[4] = 0x3f800000;
    if (local_14 < _DAT_006ea4b0) {
      piVar7[0xe] = (int)-(float)piVar7[0xe];
      piVar7[0xf] = (int)-(float)piVar7[0xf];
      piVar7[4] = -0x40800000;
    }
    piVar7[0x10] = (int)ABS((float)dVar5);
    piVar7[2] = (int)(float)dVar6;
    piVar7[3] = (int)(float)((float10)_DAT_006e9808 / (float10)dVar6);
    piVar7[5] = (int)(float)(((float10)dVar6 + (float10)_DAT_006f4640) / (float10)dVar6);
  }
  piVar7[8] = (int)(float)dVar13;
  piVar7[9] = (int)(float)dVar14;
  piVar7[10] = 0;
  piVar7[0xb] = (int)(float)-((float10)dVar14 * (float10)(double)CONCAT44(uVar10,uVar9) +
                             (float10)dVar13 * (float10)(double)CONCAT44(uVar12,uVar11));
  FUN_005113ba();
  for (param_3 = 1; param_3 <= piVar7[0x15]; param_3 = param_3 + 1) {
    FUN_005115ea();
  }
  FUN_005114aa();
  FUN_0051172a();
  for (param_3 = 1; param_3 <= piVar7[0x16]; param_3 = param_3 + 1) {
    FUN_005117ba();
  }
  FUN_0051177a();
  FUN_0051193a();
  for (param_3 = 0; param_3 < *(int *)(param_1 + 0x4a); param_3 = param_3 + 1) {
    FUN_00511c9a();
  }
  FUN_00511aca();
  return (float10)param_2 + (float10)(float)piVar7[2];
}


