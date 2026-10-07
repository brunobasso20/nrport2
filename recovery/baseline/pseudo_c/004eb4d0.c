/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004eb4d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_004eb4d0(int *param_1,undefined4 *param_2,uint param_3,undefined4 param_4)

{
  float fVar1;
  int iVar2;
  char cVar3;
  char cVar4;
  float *pfVar5;
  uint uVar6;
  uint uVar7;
  int iVar8;
  int *piVar9;
  undefined4 *puVar10;
  float10 fVar11;
  float *pfStack_110;
  int iStack_10c;
  float local_108;
  int aiStack_104 [2];
  float afStack_fc [63];
  
  iVar8 = param_1[0x1e7];
  if (0 < iVar8) {
    piVar9 = (int *)param_1[0x1e6];
    do {
      if ((int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] != (int *)0x0) {
        (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x10))(param_3);
      }
      piVar9 = piVar9 + 1;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
  }
  local_108 = 0.0;
  fVar11 = (float10)_DAT_006e97d8;
  if (*(char *)((int)param_1 + 0x7c3) != '\0') {
    fVar11 = (float10)(**(code **)(*param_1 + 0x34))();
    fVar11 = (fVar11 - (float10)_DAT_006ea504) * (float10)_DAT_006f3964;
    if ((float10)_DAT_006ea454 <= fVar11) {
      if ((float10)_DAT_006e97d8 < fVar11) {
        fVar11 = (float10)_DAT_006e97d8;
      }
    }
    else {
      fVar11 = (float10)_DAT_006ea454;
    }
    local_108 = (float)((float10)_DAT_006e97d8 - fVar11);
  }
  if (param_1[0x1e5] < 1) {
    return 0;
  }
  if ((*(char *)((int)param_1 + 0x7c3) != '\0') && (iVar8 = 0, 0 < param_1[0x1e5])) {
    pfVar5 = (float *)(param_1 + 0x1a5);
    do {
      fVar1 = *pfVar5;
      afStack_fc[iVar8 * 2] = *pfVar5;
      iVar8 = iVar8 + 1;
      *pfVar5 = (float)(fVar11 * (float10)fVar1);
      pfVar5 = pfVar5 + 2;
    } while (iVar8 < param_1[0x1e5]);
  }
  piVar9 = (int *)param_1[0x1e4];
  if ((*piVar9 != 0) && ((int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] != (int *)0x0)) {
    cVar3 = (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x24))();
    if ((((float)_DAT_006ef6d8 < (float)param_1[0x1a5]) && (*(char *)(*piVar9 + 0xb8) != '\0')) &&
       ((iVar8 = *(int *)(*piVar9 + 0xb9), *(char *)((int)param_1 + iVar8 * 0xd + 0x47c) != '\0' ||
        ((float)_DAT_006ed098 < *(float *)((int)param_1 + iVar8 * 0xd + 0x478))))) {
      iVar8 = *(int *)param_1[iVar8 + 0x184];
      cVar4 = (**(code **)(iVar8 + 0x24))();
      (**(code **)(iVar8 + 0xc))(&DAT_00997c10,param_3,cVar4 == '\0');
      cVar4 = (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x24))();
      if (cVar4 == (char)param_4) {
        if ((char)param_4 == '\0') {
          FUN_004ebae0(param_2,&DAT_00997c10,param_3,param_1[0x1a5]);
        }
        else {
          FUN_004eba10(param_2,&DAT_00997c10,param_3,param_1[0x1a5]);
        }
      }
      else {
        FUN_004eb960(param_2,&DAT_00997c10,((cVar3 != '\0') + 1) * param_3,param_1[0x1a5]);
      }
      goto LAB_004eb757;
    }
    (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x10))(param_3);
  }
  uVar6 = (2 - (uint)((char)param_4 != '\0')) * param_3;
  puVar10 = param_2;
  for (uVar7 = (uVar6 & 0x7fffffff) >> 1; uVar7 != 0; uVar7 = uVar7 - 1) {
    *puVar10 = 0;
    puVar10 = puVar10 + 1;
  }
  for (uVar6 = uVar6 * 2 & 3; uVar6 != 0; uVar6 = uVar6 - 1) {
    *(undefined1 *)puVar10 = 0;
    puVar10 = (undefined4 *)((int)puVar10 + 1);
  }
LAB_004eb757:
  if (1 < param_1[0x1e5]) {
    pfStack_110 = (float *)(param_1 + 0x1a7);
    iStack_10c = param_1[0x1e5] + -1;
    do {
      piVar9 = piVar9 + 1;
      if ((*piVar9 != 0) && ((int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] != (int *)0x0)) {
        cVar3 = (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x24))();
        aiStack_104[0] = (cVar3 != '\0') + 1;
        if (((*pfStack_110 <= (float)_DAT_006ef6d8) || (*(char *)(*piVar9 + 0xb8) == '\0')) ||
           ((iVar8 = *(int *)(*piVar9 + 0xb9), *(char *)((int)param_1 + iVar8 * 0xd + 0x47c) == '\0'
            && (*(float *)((int)param_1 + iVar8 * 0xd + 0x478) <= (float)_DAT_006ed098)))) {
          (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x10))(param_3);
        }
        else {
          iVar8 = *(int *)param_1[iVar8 + 0x184];
          cVar3 = (**(code **)(iVar8 + 0x24))();
          (**(code **)(iVar8 + 0xc))(&DAT_00997c10,param_3,cVar3 == '\0');
          cVar3 = (**(code **)(*(int *)param_1[*(int *)(*piVar9 + 0xb9) + 0x184] + 0x24))();
          if (cVar3 == (char)param_4) {
            if ((char)param_4 == '\0') {
              FUN_004ebdc0(param_2,&DAT_00997c10,param_3,*pfStack_110);
            }
            else {
              FUN_004ebc40();
            }
          }
          else {
            FUN_004ebb30(param_2,&DAT_00997c10,aiStack_104[0] * param_3,*pfStack_110);
          }
        }
      }
      pfStack_110 = pfStack_110 + 2;
      iStack_10c = iStack_10c + -1;
    } while (iStack_10c != 0);
  }
  if (*(char *)((int)param_1 + 0x7c3) != '\0') {
    iVar8 = 0;
    if (0 < param_1[0x1e5]) {
      pfVar5 = (float *)(param_1 + 0x1a5);
      do {
        iVar2 = iVar8 * 2;
        iVar8 = iVar8 + 1;
        *pfVar5 = afStack_fc[iVar2];
        pfVar5 = pfVar5 + 2;
      } while (iVar8 < param_1[0x1e5]);
    }
    uVar6 = (**(code **)(*param_1 + 0x38))(param_2,param_3,param_4,local_108,1,aiStack_104);
    if (uVar6 < param_3) {
      *(undefined1 *)((int)param_1 + 0x7c3) = 0;
    }
  }
  return param_3;
}


