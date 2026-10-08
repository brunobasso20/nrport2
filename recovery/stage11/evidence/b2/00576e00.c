/* NR2003.exe @ 00576e00 FUN_00576e00 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall
FUN_00576e00(int param_1_00,float *param_1,int *param_2,undefined4 param_3,undefined4 param_5)

{
  int iVar1;
  float *pfVar2;
  float *pfVar3;
  float *pfVar4;
  float fVar5;
  undefined4 unaff_EBP;
  bool bVar6;
  float10 fVar7;
  float *local_58;
  float fStack_54;
  float fStack_50;
  float fStack_4c;
  float fStack_48;
  float fStack_44;
  float fStack_40;
  float local_3c;
  float local_38;
  float local_34;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float fStack_18;
  float fStack_14;
  float local_c;
  float local_8;
  float local_4;
  
  pfVar2 = param_1;
  if ((param_2[1] & 0x40000000U) == 0) {
    if (param_1[1] != 0.0) {
      FUN_005f6d20(&local_c,*(int *)(param_1_00 + 4) + 0xf0,param_3);
      FUN_005f6d20(&local_30,(int)param_1[1] + 0xf0,(int)param_1[1] + 0x124);
      iVar1 = *(int *)(param_1_00 + 4);
      fVar5 = param_1[1];
      local_3c = (*(float *)(iVar1 + 0x98) - *(float *)((int)fVar5 + 0x98)) + local_c;
      local_38 = (*(float *)(iVar1 + 0x9c) - *(float *)((int)fVar5 + 0x9c)) + local_8;
      local_34 = (*(float *)(iVar1 + 0xa0) - *(float *)((int)fVar5 + 0xa0)) + local_4;
      fVar5 = param_1[1];
      local_58 = &local_24;
      param_1 = (float *)((int)fVar5 + 0xa4);
      local_24 = (local_2c * local_34 - local_28 * local_38) + *param_1;
      local_20 = (local_28 * local_3c - local_34 * local_30) + *(float *)((int)fVar5 + 0xa8);
      local_1c = (local_38 * local_30 - local_2c * local_3c) + *(float *)((int)fVar5 + 0xac);
    }
    pfVar3 = param_1;
    DAT_00cb72f8 = '\0';
    DAT_00c7e790 = 0;
    DAT_00c7e78c = 0;
    pfVar4 = (float *)(**(code **)(*param_2 + 0xc))(pfVar2[1]);
    fVar5 = *(float *)(*(int *)(param_1_00 + 4) + 0x1ac);
    if (pfVar2[1] != 0.0) {
      fVar5 = fVar5 * *(float *)((int)pfVar2[1] + 0x1ac);
    }
    if ((*(int *)(*(int *)(param_1_00 + 4) + 0x1a0) == 0) &&
       (0x10 < ((uint)param_1[1] & 0x3fffffff))) {
      param_1 = (float *)0x0;
      local_58 = (float *)0x0;
      fStack_54 = 0.0;
      fStack_50 = 0.0;
      fStack_4c = 0.0;
      fStack_48 = 0.0;
      fStack_44 = 0.0;
    }
    else {
      fVar7 = (float10)FUN_0055e1e0(&local_58,fVar5,&fStack_4c,unaff_EBP,param_5,
                                    *(undefined4 *)(param_1_00 + 0x41),*pfVar4,pfVar4[1],pfVar4[2],
                                    pfVar4[3],(uint)param_1[1] & 0x3fffffff);
      param_1 = (float *)(float)fVar7;
    }
    fVar7 = (float10)FUN_00579e50((uint)pfVar3[1] & 0x3fffffff);
    local_1c = *pfVar4;
    fStack_18 = pfVar4[1];
    fStack_14 = pfVar4[2];
    iVar1 = *(int *)(param_1_00 + 4);
    if (((float10)_DAT_006f5868 < fVar7 * (float10)(float)param_1) ||
       ((_DAT_006ea454 < (float)param_1 && (DAT_00cb72f8 != '\0')))) {
      bVar6 = DAT_00cb72f8 != '\0';
      pfVar4 = &fStack_4c;
      if (pfVar2[1] != 0.0) {
        FUN_005f6dc0(&fStack_40,(int)pfVar2[1] + 0xf0,&fStack_40);
        pfVar4 = &fStack_40;
      }
      fVar5 = pfVar2[1];
      if ((fVar5 == 0.0) || (*(int *)((int)fVar5 + 0x1a4) < 0)) {
        fVar5 = 0.0;
      }
      FUN_0054a760(param_1_00,param_1,*(uint *)(param_1_00 + 0x10) | -(uint)bVar6 & 0x2000000,
                   (uint)pfVar3[1] & 0x3fffffff,&fStack_4c,param_2,pfVar4,iVar1 + 0xa4,DAT_00c7e78c,
                   DAT_00c7e790,fVar5,&local_1c);
    }
    fVar5 = pfVar2[1];
    if (((fVar5 != 0.0) &&
        (_DAT_006ea454 <
         (float)local_58 * (float)local_58 + fStack_54 * fStack_54 + fStack_50 * fStack_50)) &&
       (*(int *)((int)fVar5 + 0x1a0) != 0)) {
      *(float *)((int)fVar5 + 0x160) = *(float *)((int)fVar5 + 0x160) - (float)local_58;
      *(float *)((int)fVar5 + 0x164) = *(float *)((int)fVar5 + 0x164) - fStack_54;
      *(float *)((int)fVar5 + 0x168) = *(float *)((int)fVar5 + 0x168) - fStack_50;
      fVar5 = pfVar2[1];
      fStack_4c = fStack_4c - *(float *)((int)fVar5 + 0x98);
      fStack_48 = fStack_48 - *(float *)((int)fVar5 + 0x9c);
      fStack_44 = fStack_44 - *(float *)((int)fVar5 + 0xa0);
      *(float *)((int)fVar5 + 0x16c) =
           *(float *)((int)fVar5 + 0x16c) - (fStack_48 * fStack_50 - fStack_44 * fStack_54);
      *(float *)((int)fVar5 + 0x170) =
           *(float *)((int)fVar5 + 0x170) - (fStack_44 * (float)local_58 - fStack_50 * fStack_4c);
      *(float *)((int)fVar5 + 0x174) =
           *(float *)((int)fVar5 + 0x174) - (fStack_54 * fStack_4c - fStack_48 * (float)local_58);
    }
  }
  return;
}

