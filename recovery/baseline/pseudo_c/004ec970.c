/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004ec970 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __thiscall FUN_004ec970(int param_1,undefined4 *param_2,uint param_3,char param_4)

{
  char cVar1;
  uint uVar2;
  int iVar3;
  float *pfVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  undefined4 *unaff_EBX;
  int *piVar8;
  undefined4 *puVar9;
  int iVar10;
  float10 fVar11;
  char unaff_retaddr;
  float fVar12;
  
  if ((*(int *)(param_1 + 0x7b4) == 0) ||
     (uVar7 = **(uint **)(param_1 + 0x7b0),
     *(int *)(param_1 + 0x610 + *(int *)(uVar7 + 0xb9) * 4) == 0)) {
    return 0;
  }
  iVar10 = *(int *)(param_1 + 0x7bc);
  if (0 < iVar10) {
    piVar8 = *(int **)(param_1 + 0x7b8);
    do {
      (**(code **)(**(int **)(param_1 + 0x610 + *(int *)(*piVar8 + 0xb9) * 4) + 0x10))(param_3);
      piVar8 = piVar8 + 1;
      iVar10 = iVar10 + -1;
    } while (iVar10 != 0);
  }
  if (*(char *)(uVar7 + 0xb8) != '\0') {
    piVar8 = *(int **)(param_1 + 0x610 + *(int *)(uVar7 + 0xb9) * 4);
    iVar10 = *piVar8;
    cVar1 = (**(code **)(iVar10 + 0x24))();
    uVar2 = (**(code **)(iVar10 + 0xc))(&DAT_009a3790,param_3,cVar1 == '\0');
    cVar1 = (**(code **)(*piVar8 + 0x24))();
    iVar3 = (cVar1 != '\0') + 1;
    iVar10 = *(int *)(param_1 + 0x794);
    fVar12 = _DAT_006ea454;
    if (0 < iVar10) {
      pfVar4 = (float *)(param_1 + 0x694);
      do {
        fVar12 = fVar12 + *pfVar4;
        pfVar4 = pfVar4 + 2;
        iVar10 = iVar10 + -1;
      } while (iVar10 != 0);
      if (_DAT_006e97d8 < fVar12) {
        fVar12 = 1.0;
      }
    }
    cVar1 = (**(code **)(*piVar8 + 0x24))();
    if (cVar1 == unaff_retaddr) {
      iVar3 = iVar3 * uVar2;
      if (unaff_retaddr == '\0') {
        FUN_004ebae0(unaff_EBX,&DAT_009a3790,iVar3,fVar12);
      }
      else {
        FUN_004eba10(unaff_EBX,&DAT_009a3790,iVar3,fVar12);
      }
    }
    else if ((float)_DAT_006f39a8 < fVar12) {
      uVar5 = iVar3 * uVar2;
      puVar9 = (undefined4 *)&DAT_009a3790;
      for (uVar6 = (uVar5 & 0x7fffffff) >> 1; uVar6 != 0; uVar6 = uVar6 - 1) {
        *unaff_EBX = *puVar9;
        puVar9 = puVar9 + 1;
        unaff_EBX = unaff_EBX + 1;
      }
      for (uVar5 = uVar5 * 2 & 3; uVar5 != 0; uVar5 = uVar5 - 1) {
        *(undefined1 *)unaff_EBX = *(undefined1 *)puVar9;
        puVar9 = (undefined4 *)((int)puVar9 + 1);
        unaff_EBX = (undefined4 *)((int)unaff_EBX + 1);
      }
    }
    else {
      FUN_004eb960(unaff_EBX,&DAT_009a3790,(2 - (uint)(unaff_retaddr != '\0')) * uVar2,fVar12);
    }
    if (((uVar2 < uVar7) && (*(int *)(param_1 + 0x14) != 0)) && (*(char *)(param_1 + 0x7c0) != '\0')
       ) {
      fVar11 = (float10)FUN_004eebf0();
      FUN_004f02d0(3,(double)fVar11);
    }
    return uVar2;
  }
  uVar7 = (2 - (uint)(param_4 != '\0')) * param_3;
  for (uVar2 = (uVar7 & 0x7fffffff) >> 1; uVar2 != 0; uVar2 = uVar2 - 1) {
    *param_2 = 0;
    param_2 = param_2 + 1;
  }
  for (uVar7 = uVar7 * 2 & 3; uVar7 != 0; uVar7 = uVar7 - 1) {
    *(undefined1 *)param_2 = 0;
    param_2 = (undefined4 *)((int)param_2 + 1);
  }
  return param_3;
}


