/* NR2003.exe @ 00551990 FUN_00551990 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00551990(uint param_1)

{
  int iVar1;
  float fVar2;
  char cVar3;
  float *pfVar4;
  undefined4 uVar5;
  int iVar6;
  undefined4 unaff_ESI;
  undefined4 *puVar7;
  undefined4 unaff_EDI;
  int iVar8;
  float10 fVar9;
  
  iVar6 = param_1;
  iVar8 = 0;
  pfVar4 = (float *)(param_1 + 0x1568);
  do {
    fVar9 = (float10)FUN_00551890(iVar8);
    pfVar4[-4] = (float)fVar9;
    fVar9 = (float10)FUN_00551920(iVar8);
    *pfVar4 = (float)fVar9;
    fVar9 = (float10)FUN_00551950(iVar8);
    pfVar4[4] = (float)fVar9;
    iVar8 = iVar8 + 1;
    pfVar4 = pfVar4 + 1;
  } while (iVar8 < 4);
  *(float *)(iVar6 + 0x1554) = (_DAT_00bf6d7c + _DAT_00bf6d94) * _DAT_006ea44c;
  pfVar4 = (float *)FUN_00562f50();
  *(float *)(iVar6 + 0x153c) = _DAT_00bf6ddc + *pfVar4;
  *(float *)(iVar6 + 0x1540) = _DAT_00bf6de4 * _DAT_006ea44c + pfVar4[1];
  *(float *)(iVar6 + 0x1544) = _DAT_00bf6dec + pfVar4[2];
  *(undefined4 *)(iVar6 + 0x154c) = DAT_00bf6ea8;
  *(undefined4 *)(iVar6 + 0x1550) = DAT_00bf6384;
  uVar5 = DAT_00bf6398;
  *(undefined4 *)(iVar6 + 0x1508) = *(undefined4 *)(iVar6 + 0x490);
  *(undefined4 *)(iVar6 + 0x151c) = *(undefined4 *)(iVar6 + 0x4dc);
  *(undefined4 *)(iVar6 + 0x1548) = uVar5;
  FUN_005f5890(iVar6 + 0x4bc);
  FUN_00425e80(&param_1,*(undefined4 *)(iVar6 + 0x4b0),*(undefined4 *)(iVar6 + 0x4b8),4);
  FUN_005f58a0(iVar6 + 0x4bc);
  *(uint *)(iVar6 + 0x1520) = param_1;
  FUN_005f5890(iVar6 + 0x4ec);
  param_1 = **(uint **)(iVar6 + 0x4e8) ^ **(uint **)(iVar6 + 0x4e0);
  FUN_005f58a0(iVar6 + 0x4ec);
  *(undefined4 *)(iVar6 + 0x1528) = *(undefined4 *)(iVar6 + 0x50c);
  *(uint *)(iVar6 + 0x1524) = param_1;
  *(undefined4 *)(iVar6 + 0x152c) = *(undefined4 *)(iVar6 + 0x510);
  *(uint *)(iVar6 + 0x14fc) =
       (*(uint *)(iVar6 + 0x14fc) ^ DAT_0074c97c) & 7 ^ *(uint *)(iVar6 + 0x14fc);
  *(undefined4 *)(iVar6 + 0x1500) = DAT_00bf6e60;
  *(undefined4 *)(iVar6 + 0x1504) = DAT_00bf6e64;
  *(undefined *)(iVar6 + 0x14fb) = 1;
  *(undefined4 *)(iVar6 + 0x15ac) = DAT_007636e4;
  uVar5 = FUN_004284f0(iVar6 + 0x58e);
  FUN_00565840(iVar6 + 0x1588,iVar6 + 0x158c,DAT_0074c97c,DAT_0074c978,uVar5);
  switch(DAT_00bf6ea0) {
  case 0:
    *(undefined4 *)(iVar6 + 0x1590) = 0;
    goto switchD_00551b55_caseD_8;
  case 1:
    FUN_00565b70(iVar6);
    param_1 = DAT_00bf6df4 - DAT_00bf6e98;
    fVar2 = (float)param_1 / (float)DAT_00bf6df4;
    break;
  case 2:
  case 3:
    FUN_00565b70(iVar6);
    *(undefined4 *)(iVar6 + 0x1590) = 0x3f800000;
    goto switchD_00551b55_caseD_8;
  case 4:
    FUN_00565b70(iVar6);
    fVar2 = (float)DAT_00bf6e98 / (float)DAT_00bf6df4;
    break;
  case 5:
    FUN_00565c30(iVar6);
    param_1 = DAT_00bf6e10 - DAT_00bf6e0c;
    fVar2 = (float)param_1 / (float)DAT_00bf6e10;
    break;
  case 6:
    FUN_00565c30(iVar6);
    *(undefined4 *)(iVar6 + 0x1590) = 0x3f800000;
    goto switchD_00551b55_caseD_8;
  case 7:
    FUN_00565c30(iVar6);
    fVar2 = (float)DAT_00bf6e0c / (float)DAT_00bf6e10;
    break;
  default:
    goto switchD_00551b55_caseD_8;
  }
  *(float *)(iVar6 + 0x1590) = fVar2;
switchD_00551b55_caseD_8:
  iVar8 = FUN_00555120();
  *(uint *)(iVar6 + 0x14fc) =
       (iVar8 << 3 ^ *(uint *)(iVar6 + 0x14fc)) & 0x18 ^ *(uint *)(iVar6 + 0x14fc);
  cVar3 = FUN_00551880();
  if (cVar3 == '\0') {
    return;
  }
  uVar5 = FUN_0055ab00(unaff_EDI,unaff_ESI);
  iVar6 = FUN_00562f70(uVar5);
  iVar8 = 0;
  puVar7 = &DAT_00bf3d00;
  DAT_00bf3a00 = *(undefined4 *)(iVar6 + 0x5aa);
  do {
    iVar1 = puVar7[-8];
    FUN_0054d610();
    FUN_00556e30(iVar6,iVar8,*(undefined4 *)(&DAT_006f6520 + iVar1 * 4),
                 (float)puVar7[-3] * *(float *)(&DAT_006f64b8 + iVar1 * 4),puVar7[-4],*puVar7);
    puVar7 = (undefined4 *)((int)puVar7 + 0xa39);
    iVar8 = iVar8 + 1;
  } while ((int)puVar7 < 0xbf65e4);
  return;
}

