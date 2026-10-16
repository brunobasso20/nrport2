/* NR2003.exe @ 004ec640 recovered_004ec640 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __thiscall recovered_004ec640(int param_1,float param_2,undefined4 param_3,float *param_4)

{
  float fVar1;
  char cVar2;
  char cVar3;
  int iVar4;
  float *pfVar5;
  uint uVar6;
  uint uVar7;
  undefined4 *unaff_EBX;
  int iVar8;
  undefined4 *puVar9;
  int *piVar10;
  float10 fVar11;
  char unaff_retaddr;

  if ((*(int *)(param_1 + 0x7a4) == 0) ||
     (iVar4 = **(int **)(param_1 + 0x7a0),
     *(int *)(param_1 + 0x610 + *(int *)(iVar4 + 0xb9) * 4) == 0)) {
    return 0;
  }
  iVar8 = *(int *)(param_1 + 0x7ac);
  if (0 < iVar8) {
    piVar10 = *(int **)(param_1 + 0x7a8);
    do {
      (**(code **)(**(int **)(param_1 + 0x610 + *(int *)(*piVar10 + 0xb9) * 4) + 0x10))(param_3);
      piVar10 = piVar10 + 1;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
  }
  if (*(char *)(iVar4 + 0xb8) == '\0') {
    piVar10 = *(int **)(param_1 + 0x610 + *(int *)(iVar4 + 0xb9) * 4);
    iVar4 = *piVar10;
    cVar2 = (**(code **)(iVar4 + 0x24))();
    iVar4 = (**(code **)(iVar4 + 0xc))(&DAT_00a4b7b0,param_3,cVar2 == '\0');
    uVar7 = (2 - (uint)(unaff_retaddr != '\0')) * iVar4 * 2;
    for (uVar6 = uVar7 >> 2; uVar6 != 0; uVar6 = uVar6 - 1) {
      *unaff_EBX = 0;
      unaff_EBX = unaff_EBX + 1;
    }
    for (uVar7 = uVar7 & 3; uVar7 != 0; uVar7 = uVar7 - 1) {
      *(undefined *)unaff_EBX = 0;
      unaff_EBX = (undefined4 *)((int)unaff_EBX + 1);
    }
    fVar11 = (float10)(**(code **)(*piVar10 + 0x1c))();
    *param_4 = (float)fVar11;
    return iVar4;
  }
  piVar10 = *(int **)(param_1 + 0x610 + *(int *)(iVar4 + 0xb9) * 4);
  iVar4 = *piVar10;
  cVar2 = (**(code **)(iVar4 + 0x24))();
  iVar8 = (**(code **)(iVar4 + 0xc))(&DAT_00a4b7b0,param_3,cVar2 == '\0');
  cVar2 = (**(code **)(*piVar10 + 0x24))();
  iVar4 = *(int *)(param_1 + 0x794);
  fVar1 = _DAT_006ea454;
  if (0 < iVar4) {
    pfVar5 = (float *)(param_1 + 0x694);
    do {
      fVar1 = fVar1 + *pfVar5;
      pfVar5 = pfVar5 + 2;
      iVar4 = iVar4 + -1;
    } while (iVar4 != 0);
    if (_DAT_006e97d8 < fVar1) {
      fVar1 = _DAT_006e97d8;
    }
  }
  fVar1 = fVar1 * param_2;
  if ((char)param_3 == '\0') {
    cVar3 = (**(code **)(*piVar10 + 0x24))();
    if (cVar3 == unaff_retaddr) {
      if (unaff_retaddr == '\0') {
        FUN_004ebae0(unaff_EBX,&DAT_00a4b7b0,iVar8,fVar1);
      }
      else {
        FUN_004eba10(unaff_EBX,&DAT_00a4b7b0,iVar8,fVar1);
      }
    }
    else {
      if ((float)_DAT_006f39a8 < fVar1) {
        uVar7 = ((cVar2 != '\0') + 1) * iVar8 * 2;
        iVar4 = *piVar10;
        puVar9 = (undefined4 *)&DAT_00a4b7b0;
        for (uVar6 = uVar7 >> 2; uVar6 != 0; uVar6 = uVar6 - 1) {
          *unaff_EBX = *puVar9;
          puVar9 = puVar9 + 1;
          unaff_EBX = unaff_EBX + 1;
        }
        for (uVar7 = uVar7 & 3; uVar7 != 0; uVar7 = uVar7 - 1) {
          *(undefined *)unaff_EBX = *(undefined *)puVar9;
          puVar9 = (undefined4 *)((int)puVar9 + 1);
          unaff_EBX = (undefined4 *)((int)unaff_EBX + 1);
        }
        fVar11 = (float10)(**(code **)(iVar4 + 0x1c))();
        *param_4 = (float)fVar11;
        return iVar8;
      }
      FUN_004eb960(unaff_EBX,&DAT_00a4b7b0,(2 - (uint)(unaff_retaddr != '\0')) * iVar8,fVar1);
    }
  }
  else {
    cVar2 = (**(code **)(*piVar10 + 0x24))();
    if (cVar2 == unaff_retaddr) {
      if (unaff_retaddr == '\0') {
        FUN_004ebdc0(unaff_EBX,&DAT_00a4b7b0,iVar8,fVar1);
      }
      else {
        FUN_004ebc40(unaff_EBX,&DAT_00a4b7b0,iVar8,fVar1);
      }
    }
    else {
      FUN_004ebb30(unaff_EBX,&DAT_00a4b7b0,(2 - (uint)(unaff_retaddr != '\0')) * iVar8,fVar1);
    }
  }
  fVar11 = (float10)(**(code **)(*piVar10 + 0x1c))();
  *param_4 = (float)fVar11;
  return iVar8;
}
