/* NR2003.exe @ 00425690 FUN_00425690 */

void FUN_00425690(void)

{
  int iVar1;
  undefined4 uVar2;
  int *piVar3;
  float *pfVar4;
  float *pfVar5;
  undefined4 *puVar6;
  int iVar7;
  
  iVar7 = 0;
  do {
    switch(iVar7) {
    case 0:
      uVar2 = 0x33;
      break;
    case 1:
      uVar2 = 0x34;
      break;
    case 2:
      uVar2 = 0x35;
      break;
    case 3:
      uVar2 = 0x36;
      break;
    case 4:
      uVar2 = 0x37;
      break;
    case 5:
      uVar2 = 0x38;
      break;
    case 6:
      uVar2 = 0x45;
      break;
    case 7:
      uVar2 = 0x46;
      break;
    case 8:
      uVar2 = 0x39;
      break;
    default:
      goto switchD_004256ac_caseD_9;
    }
    piVar3 = (int *)FUN_00557d70(uVar2);
    iVar1 = *piVar3;
    pfVar4 = (float *)FUN_00557d60(iVar7 + 0x66);
    *pfVar4 = (float)*(int *)(&DAT_006ed884 + iVar1 * 8) /
              (float)*(int *)(&DAT_006ed880 + iVar1 * 8);
    piVar3 = (int *)FUN_00557d70(iVar7 + 0x6f);
    *piVar3 = *(int *)(&DAT_006ed880 + iVar1 * 8);
    puVar6 = (undefined4 *)FUN_00557d70(iVar7 + 0x78);
    *puVar6 = *(undefined4 *)(&DAT_006ed884 + iVar1 * 8);
switchD_004256ac_caseD_9:
    iVar7 = iVar7 + 1;
    if (8 < iVar7) {
      pfVar4 = (float *)FUN_00557d60(0x66);
      pfVar5 = (float *)FUN_00557d60(0x66);
      *pfVar4 = -*pfVar5;
      puVar6 = (undefined4 *)FUN_00557d60(0x67);
      *puVar6 = 0;
      return;
    }
  } while( true );
}

