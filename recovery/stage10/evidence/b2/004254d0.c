/* NR2003.exe @ 004254d0 recovered_004254d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void recovered_004254d0(float param_1)

{
  float fVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  int iVar5;
  float *pfVar6;
  undefined4 uVar7;
  int *piVar8;
  int iVar9;
  int iStack_8;
  int iStack_4;
  
  iVar2 = FUN_00432cf0((int)param_1 + 0xef1);
  _DAT_00721fc2 = (int)ROUND(*(float *)(iVar2 + 0x24) * _DAT_006ed7ac + _DAT_006ea4cc);
  puVar3 = (undefined4 *)FUN_00557d60(0x31);
  *puVar3 = *(undefined4 *)(iVar2 + 0x24);
  iVar2 = FUN_0051a000();
  puVar3 = (undefined4 *)FUN_00557d70(0x65);
  iVar9 = 0;
  *puVar3 = *(undefined4 *)(iVar2 + 0x444);
  iVar2 = 0x448;
  do {
    puVar4 = (undefined4 *)FUN_00557d60(iVar9 + 0x66);
    iVar5 = FUN_0051a000();
    puVar3 = (undefined4 *)(iVar5 + iVar2);
    iVar2 = iVar2 + 4;
    iVar9 = iVar9 + 1;
    *puVar4 = *puVar3;
  } while (iVar2 < 0x46c);
  puVar3 = (undefined4 *)FUN_00557d60(0x6e);
  iVar2 = FUN_0051a000();
  *puVar3 = *(undefined4 *)(iVar2 + 0x468);
  iStack_8 = 0;
  do {
    if (iStack_8 != 1) {
      iVar2 = *(int *)(&DAT_006ed834 + iStack_8 * 4);
      iVar9 = *(int *)(&DAT_006ed858 + iStack_8 * 4);
      param_1 = -1.0;
      iStack_4 = iVar2;
      if (iVar2 <= iVar9) {
        do {
          pfVar6 = (float *)FUN_00557d60(iStack_8 + 0x66);
          fVar1 = ABS(ABS(*pfVar6) -
                      ABS((float)*(int *)(PTR_DAT_006edd28 + iVar2 * 8 + 4) /
                          (float)*(int *)(PTR_DAT_006edd28 + iVar2 * 8)));
          if ((fVar1 < param_1 != (NAN(fVar1) || NAN(param_1))) ||
             (param_1 < _DAT_006ea454 != (NAN(param_1) || NAN(_DAT_006ea454)))) {
            param_1 = fVar1;
            iStack_4 = iVar2;
          }
          iVar2 = iVar2 + 1;
        } while (iVar2 <= iVar9);
      }
      switch(iStack_8) {
      case 0:
        uVar7 = 0x33;
        break;
      case 1:
        uVar7 = 0x34;
        break;
      case 2:
        uVar7 = 0x35;
        break;
      case 3:
        uVar7 = 0x36;
        break;
      case 4:
        uVar7 = 0x37;
        break;
      case 5:
        uVar7 = 0x38;
        break;
      case 6:
        uVar7 = 0x45;
        break;
      case 7:
        uVar7 = 0x46;
        break;
      case 8:
        uVar7 = 0x39;
        break;
      default:
        goto switchD_004255fe_caseD_9;
      }
      piVar8 = (int *)FUN_00557d70(uVar7);
      *piVar8 = iStack_4;
    }
switchD_004255fe_caseD_9:
    iStack_8 = iStack_8 + 1;
    if (8 < iStack_8) {
      return;
    }
  } while( true );
}

