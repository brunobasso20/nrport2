/* NR2003.exe @ 00550f10 FUN_00550f10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00550f10(float param_1)

{
  float **ppfVar1;
  undefined4 uVar2;
  int iVar3;
  float fVar4;
  short sVar5;
  int iVar6;
  float *pfVar7;
  undefined4 *puVar8;
  uint uVar9;
  undefined4 uVar10;
  float local_4;
  
  sVar5 = FUN_0055a690();
  if (sVar5 == 7) {
    iVar6 = FUN_0055a730();
    iVar3 = (int)param_1;
    fVar4 = DAT_00e0b834;
    if (iVar6 < 4) {
      pfVar7 = (float *)FUN_00557d60(param_1);
      local_4 = *pfVar7;
      param_1 = fVar4 + _DAT_006ee580 + _DAT_006ee350;
      iVar3 = iVar3 * 0xa39;
      FUN_0051c3f0(&param_1);
      FUN_0051c3f0(&param_1);
      FUN_0051c3f0(&param_1);
      FUN_0051c3f0(&param_1);
      FUN_0051c3f0(&param_1);
      FUN_0051c3f0(&param_1);
      *(float *)((int)&DAT_00bf3a20 + iVar3) = local_4;
      local_4 = 0.0;
      FUN_0051c3f0(&local_4);
      *(undefined4 *)(iVar3 + 0xbf3aec) = 0x3f800000;
      *(undefined4 *)(iVar3 + 0xbf3af0) = 0x3f800000;
      *(undefined *)(iVar3 + 0xbf4458) = 0;
      *(undefined4 *)(iVar3 + 0xbf3cec) = 0;
      *(undefined4 *)((int)&DAT_00bf3d00 + iVar3) = 0;
      *(undefined4 *)(iVar3 + 0xbf3cfc) = 0;
      *(undefined4 *)(iVar3 + 0xbf3cf8) = 0;
      *(undefined4 *)(iVar3 + 0xbf3d04) = 0;
      *(undefined4 *)(iVar3 + 0xbf3d08) = 0;
      *(undefined4 *)(iVar3 + 0xbf3d0c) = 0;
      *(undefined4 *)(iVar3 + 0xbf3d10) = 0;
      *(undefined4 *)(iVar3 + 0xbf3ce8) = 0;
      *(undefined4 *)(&DAT_00bf3ccc + iVar3) = 0;
      *(undefined4 *)(&DAT_00bf3cd0 + iVar3) = 0;
      *(undefined4 *)((int)&DAT_00bf3cd4 + iVar3) = 0;
      *(undefined4 *)(&DAT_00bf3cd8 + iVar3) = 0;
      *(undefined4 *)((int)&DAT_00bf3cf0 + iVar3) = 0;
      *(undefined4 *)((int)&DAT_00bf3cf4 + iVar3) = 0;
      *(undefined4 *)((int)&DAT_00bf3cdc + iVar3) = 0;
      *(undefined4 *)((int)&DAT_00bf3ce0 + iVar3) = 0;
      FUN_0054d610();
      return;
    }
  }
  iVar3 = (int)param_1;
  local_4 = DAT_00e0b834;
  puVar8 = (undefined4 *)FUN_00557d60(param_1);
  uVar2 = *puVar8;
  param_1 = local_4 + _DAT_006ea68c + _DAT_006ee350;
  iVar3 = iVar3 * 0xa39;
  ppfVar1 = (float **)(&DAT_00bf3b80 + iVar3);
  FUN_005f5890(iVar3 + 0xbf3b8c);
  FUN_00425e80(&local_4,*(undefined4 *)(iVar3 + 0xbf3b84),&DAT_00f72118,4);
  if (local_4 != **ppfVar1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar9 = FUN_005cfcfc();
  if ((uVar9 & 0x3f) == 0) {
    FUN_004f68c0(*(undefined4 *)(iVar3 + 0xbf3b88),4);
  }
  FUN_00425e80(*ppfVar1,&param_1,*(undefined4 *)(iVar3 + 0xbf3b88),4);
  FUN_00425e80(*(undefined4 *)(iVar3 + 0xbf3b84),&DAT_00f72118,*ppfVar1,4);
  uVar9 = FUN_005cfcfc();
  if ((uVar9 & 0x3ff) == 0) {
    uVar10 = FUN_0051c5d0(*(undefined4 *)(iVar3 + 0xbf3b88));
    *(undefined4 *)(iVar3 + 0xbf3b88) = uVar10;
  }
  uVar9 = FUN_005cfcfc();
  if ((uVar9 & 0x1ff) == 0) {
    pfVar7 = (float *)FUN_0051c5d0(*ppfVar1);
    *ppfVar1 = pfVar7;
  }
  uVar9 = FUN_005cfcfc();
  if ((uVar9 & 0x7ff) == 0) {
    uVar10 = FUN_0051c5d0(*(undefined4 *)(iVar3 + 0xbf3b84));
    *(undefined4 *)(iVar3 + 0xbf3b84) = uVar10;
  }
  FUN_005f58a0(iVar3 + 0xbf3b8c);
  FUN_0051c3f0(&param_1);
  FUN_0051c3f0(&param_1);
  FUN_0051c3f0(&param_1);
  FUN_0051c3f0(&param_1);
  FUN_0051c3f0(&param_1);
  *(undefined4 *)((int)&DAT_00bf3a20 + iVar3) = uVar2;
  local_4 = 0.0;
  FUN_0051c3f0(&local_4);
  *(undefined4 *)(iVar3 + 0xbf3aec) = 0x3f800000;
  *(undefined4 *)(iVar3 + 0xbf3af0) = 0x3f800000;
  *(undefined *)(iVar3 + 0xbf4458) = 0;
  *(undefined4 *)(iVar3 + 0xbf3cec) = 0;
  *(undefined4 *)((int)&DAT_00bf3d00 + iVar3) = 0;
  *(undefined4 *)(iVar3 + 0xbf3cfc) = 0;
  *(undefined4 *)(iVar3 + 0xbf3cf8) = 0;
  *(undefined4 *)(iVar3 + 0xbf3d04) = 0;
  *(undefined4 *)(iVar3 + 0xbf3d08) = 0;
  *(undefined4 *)(iVar3 + 0xbf3d0c) = 0;
  *(undefined4 *)(iVar3 + 0xbf3d10) = 0;
  *(undefined4 *)(iVar3 + 0xbf3ce8) = 0;
  *(undefined4 *)(&DAT_00bf3ccc + iVar3) = 0;
  *(undefined4 *)(&DAT_00bf3cd0 + iVar3) = 0;
  *(undefined4 *)((int)&DAT_00bf3cd4 + iVar3) = 0;
  *(undefined4 *)(&DAT_00bf3cd8 + iVar3) = 0;
  *(undefined4 *)((int)&DAT_00bf3cf0 + iVar3) = 0;
  *(undefined4 *)((int)&DAT_00bf3cf4 + iVar3) = 0;
  *(undefined4 *)((int)&DAT_00bf3cdc + iVar3) = 0;
  *(undefined4 *)((int)&DAT_00bf3ce0 + iVar3) = 0;
  FUN_0054d610();
  return;
}

