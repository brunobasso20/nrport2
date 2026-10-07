/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005125ba */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005125ba(int *param_1,int *param_2)

{
  float fVar1;
  float fVar2;
  int iVar3;
  int iVar4;
  float10 fVar5;
  int *piVar6;
  int *piVar7;
  int *piVar8;
  char cVar9;
  float10 fVar10;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  piVar8 = param_2;
  piVar7 = param_1;
  iVar3 = param_1[0x16];
  *param_2 = 0;
  fVar2 = (float)param_1[iVar3 * 9 + 0x162] * _DAT_006ea454 + (float)param_1[iVar3 * 9 + 0x161];
  if (*param_1 == 1) {
    param_2[1] = (int)(fVar2 * (float)param_1[0x10] +
                       (float)param_1[2] * (float)param_1[0x11] * _DAT_006ea454 +
                      (float)param_1[0xc]);
    param_2[9] = (int)(fVar2 * (float)param_1[0x11] +
                      ((float)param_1[0xd] -
                      (float)param_1[2] * (float)param_1[0x10] * _DAT_006ea454));
  }
  else {
    piVar6 = (int *)((float)param_1[0x14] * _DAT_006ea454 + (float)param_1[0x13]);
    fVar10 = (float10)(float)piVar6;
    fVar5 = (float10)fcos(fVar10);
    fVar10 = (float10)fsin(fVar10);
    local_14 = (float)fVar5;
    local_10 = (float)fVar10;
    fVar1 = (float)param_1[0x11];
    param_2[1] = (int)(local_10 * (fVar1 - fVar2) + (float)param_1[0xc]);
    param_2[9] = (int)((float)param_1[0xd] - local_14 * (fVar1 - fVar2));
    param_2 = piVar6;
  }
  iVar4 = *piVar8;
  *piVar8 = iVar4 + 1;
  fVar2 = (float)param_1[0x16b] * _DAT_006ea454 + (float)param_1[0x16a];
  if (*param_1 == 1) {
    piVar8[iVar4 + 2] =
         (int)(fVar2 * (float)param_1[0x10] +
               (float)param_1[2] * (float)param_1[0x11] * _DAT_006ea454 + (float)param_1[0xc]);
    piVar8[iVar4 + 10] =
         (int)(fVar2 * (float)param_1[0x11] +
              ((float)param_1[0xd] - (float)param_1[2] * (float)param_1[0x10] * _DAT_006ea454));
  }
  else {
    param_2 = (int *)((float)param_1[0x14] * _DAT_006ea454 + (float)param_1[0x13]);
    fVar5 = (float10)fcos((float10)(float)param_2);
    fVar10 = (float10)fsin((float10)(float)param_2);
    local_14 = (float)fVar5;
    local_10 = (float)fVar10;
    fVar1 = (float)param_1[0x11];
    piVar8[iVar4 + 2] = (int)(local_10 * (fVar1 - fVar2) + (float)param_1[0xc]);
    piVar8[iVar4 + 10] = (int)((float)param_1[0xd] - local_14 * (fVar1 - fVar2));
  }
  *piVar8 = *piVar8 + 1;
  fVar2 = (float)param_1[0x16b] + (float)param_1[0x16a];
  if (*param_1 == 1) {
    local_1c = (float)param_1[2] * (float)param_1[0x11] + fVar2 * (float)param_1[0x10] +
               (float)param_1[0xc];
    local_20 = fVar2 * (float)param_1[0x11] +
               ((float)param_1[0xd] - (float)param_1[2] * (float)param_1[0x10]);
  }
  else {
    param_2 = (int *)((float)param_1[0x14] + (float)param_1[0x13]);
    fVar5 = (float10)fcos((float10)(float)param_2);
    fVar10 = (float10)fsin((float10)(float)param_2);
    local_14 = (float)fVar5;
    local_10 = (float)fVar10;
    local_1c = local_10 * ((float)param_1[0x11] - fVar2) + (float)param_1[0xc];
    local_20 = (float)param_1[0xd] - local_14 * ((float)param_1[0x11] - fVar2);
  }
  if ((*param_1 == 2) && (_DAT_006ea454 < (float)param_1[0x11])) {
    fVar10 = (float10)((float)param_1[0x14] * _DAT_006ea44c + (float)param_1[0x13]);
    fVar5 = (float10)fcos(fVar10);
    fVar10 = (float10)fsin(fVar10);
    fVar2 = (float)param_1[0x11] - ((float)param_1[0x16b] * _DAT_006ea44c + (float)param_1[0x16a]);
    param_2 = (int *)((float)fVar10 * fVar2 + (float)param_1[0xc]);
    fVar2 = (float)param_1[0xd] - (float)fVar5 * fVar2;
    fVar1 = (float)param_1[0x16b] * _DAT_006ec6d8 + (float)param_1[0x16a];
    if (*param_1 == 1) {
      local_10 = (float)param_1[2] * (float)param_1[0x11] * _DAT_006ec6d8 +
                 fVar1 * (float)param_1[0x10] + (float)param_1[0xc];
      local_18 = fVar1 * (float)param_1[0x11] +
                 ((float)param_1[0xd] - (float)param_1[2] * (float)param_1[0x10] * _DAT_006ec6d8);
    }
    else {
      fVar10 = (float10)((float)param_1[0x14] * _DAT_006ec6d8 + (float)param_1[0x13]);
      fVar5 = (float10)fcos(fVar10);
      fVar10 = (float10)fsin(fVar10);
      local_c = (float)fVar5;
      local_10 = (float)fVar10 * ((float)param_1[0x11] - fVar1) + (float)param_1[0xc];
      local_18 = (float)param_1[0xd] - local_c * ((float)param_1[0x11] - fVar1);
    }
    local_10 = (float)param_2 - local_10;
    local_18 = fVar2 - local_18;
    local_14 = (float)param_1[0x16a] - (float)param_1[0x16b] * _DAT_006ea508;
    if (*param_1 == 1) {
      local_8 = (local_14 * (float)param_1[0x10] -
                (float)param_1[2] * (float)param_1[0x11] * _DAT_006ea508) + (float)param_1[0xc];
      local_4 = local_14 * (float)param_1[0x11] +
                ((float)param_1[0xd] - (float)param_1[2] * (float)param_1[0x10] * _DAT_006f465c);
    }
    else {
      local_c = (float)param_1[0x13] - (float)param_1[0x14] * _DAT_006ea508;
      fVar5 = (float10)fcos((float10)local_c);
      fVar10 = (float10)fsin((float10)local_c);
      local_14 = (float)param_1[0x11] - local_14;
      local_8 = (float)fVar10 * local_14 + (float)param_1[0xc];
      local_4 = (float)param_1[0xd] - (float)fVar5 * local_14;
    }
    iVar4 = *piVar8;
    local_8 = (float)piVar8[iVar4] - local_8;
    local_4 = (float)piVar8[iVar4 + 8] - local_4;
    param_1 = (int *)fVar2;
    cVar9 = FUN_00512d7a(piVar8[iVar4],piVar8[iVar4 + 8],local_8,local_4,param_2,fVar2,local_10,
                         local_18,piVar8 + iVar4 + 1,piVar8 + iVar4 + 9);
    if (cVar9 != '\0') {
      *piVar8 = *piVar8 + 1;
    }
    fVar2 = (float)piVar7[0x16b] * _DAT_006f4658 + (float)piVar7[0x16a];
    if (*piVar7 == 1) {
      local_10 = (float)piVar7[2] * (float)piVar7[0x11] * _DAT_006f4658 +
                 fVar2 * (float)piVar7[0x10] + (float)piVar7[0xc];
      local_18 = fVar2 * (float)piVar7[0x11] +
                 ((float)piVar7[0xd] - (float)piVar7[2] * (float)piVar7[0x10] * _DAT_006f4658);
    }
    else {
      local_4 = (float)piVar7[0x14] * _DAT_006f4658 + (float)piVar7[0x13];
      fVar5 = (float10)fcos((float10)local_4);
      fVar10 = (float10)fsin((float10)local_4);
      local_c = (float)fVar5;
      local_8 = (float)fVar10;
      local_10 = local_8 * ((float)piVar7[0x11] - fVar2) + (float)piVar7[0xc];
      local_18 = (float)piVar7[0xd] - local_c * ((float)piVar7[0x11] - fVar2);
    }
    local_10 = (float)param_2 - local_10;
    local_18 = (float)param_1 - local_18;
    local_14 = (float)piVar7[0x16b] * _DAT_006efad8 + (float)piVar7[0x16a];
    if (*piVar7 == 1) {
      fVar2 = (float)piVar7[2] * (float)piVar7[0x11] * _DAT_006efad8 +
              local_14 * (float)piVar7[0x10] + (float)piVar7[0xc];
      fVar1 = local_14 * (float)piVar7[0x11] +
              ((float)piVar7[0xd] - (float)piVar7[2] * (float)piVar7[0x10] * _DAT_006efad8);
    }
    else {
      local_4 = (float)piVar7[0x14] * _DAT_006efad8 + (float)piVar7[0x13];
      fVar5 = (float10)fcos((float10)local_4);
      fVar10 = (float10)fsin((float10)local_4);
      local_c = (float)fVar5;
      local_8 = (float)fVar10;
      local_14 = (float)piVar7[0x11] - local_14;
      fVar2 = local_8 * local_14 + (float)piVar7[0xc];
      fVar1 = (float)piVar7[0xd] - local_c * local_14;
    }
    cVar9 = FUN_00512d7a(local_1c,local_20,local_1c - fVar2,local_20 - fVar1,param_2,param_1,
                         local_10,local_18,piVar8 + *piVar8 + 1,piVar8 + *piVar8 + 9);
    if (cVar9 != '\0') {
      *piVar8 = *piVar8 + 1;
    }
  }
  piVar8[*piVar8 + 1] = (int)local_1c;
  piVar8[*piVar8 + 9] = (int)local_20;
  iVar4 = *piVar8;
  *piVar8 = iVar4 + 1;
  param_1 = (int *)((float)piVar7[iVar3 * 9 + 0x162] + (float)piVar7[iVar3 * 9 + 0x161]);
  if (*piVar7 == 1) {
    piVar8[iVar4 + 2] =
         (int)((float)piVar7[2] * (float)piVar7[0x11] + (float)param_1 * (float)piVar7[0x10] +
              (float)piVar7[0xc]);
    piVar8[iVar4 + 10] =
         (int)((float)param_1 * (float)piVar7[0x11] +
              ((float)piVar7[0xd] - (float)piVar7[2] * (float)piVar7[0x10]));
  }
  else {
    param_2 = (int *)((float)piVar7[0x14] + (float)piVar7[0x13]);
    fVar5 = (float10)fcos((float10)(float)param_2);
    fVar10 = (float10)fsin((float10)(float)param_2);
    local_8 = (float)fVar5;
    local_4 = (float)fVar10;
    fVar2 = (float)piVar7[0x11];
    piVar8[iVar4 + 2] = (int)(local_4 * (fVar2 - (float)param_1) + (float)piVar7[0xc]);
    piVar8[iVar4 + 10] = (int)((float)piVar7[0xd] - local_8 * (fVar2 - (float)param_1));
  }
  *piVar8 = *piVar8 + 1;
  if ((*piVar7 == 2) && ((float)piVar7[0x11] < _DAT_006ea454)) {
    FUN_00519540(0x3f000000,
                 (float)piVar7[iVar3 * 9 + 0x162] * _DAT_006ea44c + (float)piVar7[iVar3 * 9 + 0x161]
                 ,&local_14,&local_18);
    FUN_00519540(0x3ee66666,
                 (float)piVar7[iVar3 * 9 + 0x162] * _DAT_006f4658 + (float)piVar7[iVar3 * 9 + 0x161]
                 ,&param_2,&param_1);
    param_2 = (int *)(local_14 - (float)param_2);
    param_1 = (int *)(local_18 - (float)param_1);
    FUN_00519540(0x3f866666,
                 (float)piVar7[iVar3 * 9 + 0x162] * _DAT_006efad8 + (float)piVar7[iVar3 * 9 + 0x161]
                 ,&local_1c,&local_20);
    iVar4 = *piVar8;
    local_1c = (float)piVar8[iVar4] - local_1c;
    local_20 = (float)piVar8[iVar4 + 8] - local_20;
    cVar9 = FUN_00512d7a(piVar8[iVar4],piVar8[iVar4 + 8],local_1c,local_20,local_14,local_18,param_2
                         ,param_1,piVar8 + iVar4 + 1,piVar8 + iVar4 + 9);
    if (cVar9 != '\0') {
      *piVar8 = *piVar8 + 1;
    }
    FUN_00519540(0x3f0ccccd,
                 (float)piVar7[iVar3 * 9 + 0x162] * _DAT_006ec6d8 + (float)piVar7[iVar3 * 9 + 0x161]
                 ,&param_2,&param_1);
    param_2 = (int *)(local_14 - (float)param_2);
    param_1 = (int *)(local_18 - (float)param_1);
    FUN_00519540(0xbd4ccccd,
                 (float)piVar7[iVar3 * 9 + 0x161] - (float)piVar7[iVar3 * 9 + 0x162] * _DAT_006ea508
                 ,&local_1c,&local_20);
    local_1c = (float)piVar8[1] - local_1c;
    local_20 = (float)piVar8[9] - local_20;
    cVar9 = FUN_00512d7a(piVar8[1],piVar8[9],local_1c,local_20,local_14,local_18,param_2,param_1,
                         piVar8 + *piVar8 + 1,piVar8 + *piVar8 + 9);
    if (cVar9 != '\0') {
      *piVar8 = *piVar8 + 1;
    }
  }
  return;
}


