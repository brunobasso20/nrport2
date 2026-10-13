/* NR2003.exe @ 00575920 recovered_00575920 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void __thiscall
recovered_00575920(int param_1,int param_2,int *param_3,float *param_4,float *param_5,float *param_6
                  )

{
  float fVar1;
  float fVar2;
  float *pfVar3;
  int iVar4;
  int iVar5;
  float *pfVar6;
  float10 fVar7;
  int unaff_retaddr;
  float fStack_b4;
  float fStack_b0;
  float *pfStack_ac;
  undefined auStack_a8 [4];
  float fStack_a4;
  float fStack_a0;
  float fStack_9c;
  float fStack_98;
  float fStack_94;
  float fStack_90;
  float fStack_8c;
  float fStack_88;
  float fStack_84;
  float fStack_80;
  float fStack_7c;
  float fStack_78;
  float fStack_74;
  float fStack_70;
  float fStack_6c;
  float fStack_68;
  float fStack_64;
  float fStack_60;
  float fStack_5c;
  float *pfStack_58;
  float fStack_54;
  float fStack_50;
  float fStack_4c;
  float fStack_48;
  float fStack_3c;
  float fStack_38;
  float fStack_34;
  float fStack_30;
  float fStack_2c;
  float fStack_28;
  float fStack_24;
  float fStack_1c;
  float fStack_18;
  float fStack_14;
  float fStack_10;
  float fStack_c;
  float fStack_8;

  if ((param_3[1] & 0x40000000U) == 0) {
    FUN_005f6d20(&fStack_50,DAT_00d358f4,param_4);
    pfStack_ac = &fStack_50;
    fStack_50 = *(float *)(DAT_00d358f4 + 0x24) + fStack_50;
    fStack_4c = *(float *)(DAT_00d358f4 + 0x28) + fStack_4c;
    fStack_64 = fStack_50 - *param_6;
    fStack_60 = fStack_4c - param_6[1];
    fStack_5c = (*(float *)(DAT_00d358f4 + 0x2c) + fStack_48) - param_6[2];
    iVar5 = *(int *)(param_1 + 4);
    fStack_a0 = param_4[2] * *(float *)(iVar5 + 0x128) - param_4[1] * *(float *)(iVar5 + 300);
    fStack_9c = *param_4 * *(float *)(iVar5 + 300) - *(float *)(iVar5 + 0x124) * param_4[2];
    fStack_98 = *(float *)(iVar5 + 0x124) * param_4[1] - *param_4 * *(float *)(iVar5 + 0x128);
    FUN_005f6d20(&fStack_a0,iVar5 + 0xf0,&fStack_a0);
    iVar5 = *(int *)(param_1 + 4);
    pfStack_ac = (float *)(iVar5 + 0xa4);
    fStack_a0 = fStack_a0 + *pfStack_ac;
    fStack_9c = fStack_9c + *(float *)(iVar5 + 0xa8);
    fStack_98 = fStack_98 + *(float *)(iVar5 + 0xac);
    FUN_005f6d20(&fStack_38,*(int *)(param_1 + 4) + 0xf0,param_4);
    if (*(int *)(param_2 + 4) == 0) {
      fStack_94 = fStack_64;
      fStack_90 = fStack_60;
      fStack_8c = fStack_5c;
    }
    else {
      FUN_005f6d20(&fStack_94,*(int *)(param_2 + 4) + 0xf0,&fStack_64);
      FUN_005f6d20(&fStack_1c,*(int *)(param_2 + 4) + 0xf0,*(int *)(param_2 + 4) + 0x124);
      iVar5 = *(int *)(param_1 + 4);
      iVar4 = *(int *)(param_2 + 4);
      fStack_70 = (*(float *)(iVar5 + 0x98) - *(float *)(iVar4 + 0x98)) + fStack_38;
      fStack_6c = (*(float *)(iVar5 + 0x9c) - *(float *)(iVar4 + 0x9c)) + fStack_34;
      fStack_68 = (*(float *)(iVar5 + 0xa0) - *(float *)(iVar4 + 0xa0)) + fStack_30;
      iVar5 = *(int *)(param_2 + 4);
      pfStack_ac = (float *)(iVar5 + 0xa4);
      fStack_2c = (fStack_18 * fStack_68 - fStack_14 * fStack_6c) + *pfStack_ac;
      fStack_28 = (fStack_14 * fStack_70 - fStack_68 * fStack_1c) + *(float *)(iVar5 + 0xa8);
      fStack_24 = (fStack_6c * fStack_1c - fStack_18 * fStack_70) + *(float *)(iVar5 + 0xac);
      fStack_a0 = fStack_a0 - fStack_2c;
      fStack_9c = fStack_9c - fStack_28;
      fStack_98 = fStack_98 - fStack_24;
    }
    pfVar3 = (float *)(**(code **)(*param_3 + 0xc))(*(undefined4 *)(param_2 + 4));
    fStack_24 = fStack_a4 * *pfVar3 + fStack_9c * pfVar3[2] + fStack_a0 * pfVar3[1];
    fStack_a4 = fStack_a4 - fStack_24 * *pfVar3;
    fStack_a0 = fStack_a0 - fStack_24 * pfVar3[1];
    fStack_9c = fStack_9c - fStack_24 * pfVar3[2];
    fStack_5c = SQRT(fStack_a0 * fStack_a0 + fStack_9c * fStack_9c + fStack_a4 * fStack_a4);
    if (fStack_5c <= _DAT_006f49d4) {
      fStack_80 = 0.0;
      fStack_7c = 0.0;
      fStack_78 = 0.0;
      fStack_5c = 0.0;
    }
    else {
      fStack_78 = _DAT_006e97d8 / fStack_5c;
      fStack_80 = fStack_a4 * fStack_78;
      fStack_7c = fStack_a0 * fStack_78;
      fStack_78 = fStack_9c * fStack_78;
    }
    fStack_9c = fStack_98 * *pfVar3 + fStack_94 * pfVar3[1] + fStack_90 * pfVar3[2];
    fStack_a4 = fStack_9c * *pfVar3;
    fStack_a0 = fStack_9c * pfVar3[1];
    fStack_9c = fStack_9c * pfVar3[2];
    fStack_98 = fStack_98 - fStack_a4;
    fStack_94 = fStack_94 - fStack_a0;
    fStack_90 = fStack_90 - fStack_9c;
    pfStack_58 = (float *)SQRT(fStack_94 * fStack_94 + fStack_90 * fStack_90 + fStack_98 * fStack_98
                              );
    if ((float)pfStack_58 <= _DAT_006f49d4) {
      fStack_98 = 0.0;
      fStack_94 = 0.0;
      fStack_90 = 0.0;
      pfStack_58 = (float *)0x0;
    }
    else {
      fVar1 = _DAT_006e97d8 / (float)pfStack_58;
      fStack_98 = fVar1 * fStack_98;
      fStack_94 = fStack_94 * fVar1;
      fStack_90 = fStack_90 * fVar1;
    }
    fStack_b0 = *(float *)(*(int *)(param_1 + 4) + 0x1ac);
    if (*(int *)(unaff_retaddr + 4) != 0) {
      fStack_b0 = fStack_b0 * *(float *)(*(int *)(unaff_retaddr + 4) + 0x1ac);
    }
    fVar7 = (float10)FUN_00579ec0(*(undefined4 *)(param_1 + 0x10),
                                  *(uint *)(param_2 + 4) & 0x3fffffff);
    fStack_b4 = (float)fVar7;
    fVar1 = _DAT_006e97d8;
    if (((*(int *)(param_1 + 0x10) == 0x11) &&
        ((&DAT_006f6080)[*(uint *)(param_2 + 4) & 0x3fffffff] != '\0')) &&
       (fVar2 = (*(float *)(param_1 + 0x2c) - param_4[2]) / *(float *)(param_1 + 0x30),
       _DAT_006ed020 < fVar2)) {
      if (fVar2 <= _DAT_006f60f4) {
        fVar2 = (_DAT_006f60f4 - fVar2) * _DAT_006f60f0;
        fVar1 = (_DAT_006e97d8 - fVar2) * SQRT(fStack_5c);
        fVar2 = fVar2 * _DAT_006ed020 + _DAT_006ea4cc;
      }
      else {
        fVar1 = SQRT(fStack_5c);
        fVar2 = _DAT_006ea4cc;
      }
      fVar1 = fVar1 * _DAT_006ea44c + _DAT_006e97d8;
      fStack_b4 = (fVar2 / fVar1) * fStack_b4;
    }
    fVar7 = (float10)FUN_00579f10(&fStack_8c,auStack_a8,&pfStack_ac,*(int *)(param_1 + 0x10),
                                  *(uint *)(param_2 + 4) & 0x3fffffff,fStack_b4,pfVar3,&fStack_80,
                                  &fStack_98,fStack_24,fStack_5c,fVar1 * (float)param_4,pfStack_58,
                                  fStack_b0);
    fVar1 = (float)fVar7;
    if ((float)pfStack_ac < (float)pfStack_58) {
      fVar2 = (float)pfStack_ac / (float)pfStack_58;
      fStack_68 = fStack_68 * fVar2;
      fStack_64 = fStack_64 * fVar2;
      fStack_60 = fStack_60 * fVar2;
      *param_5 = fStack_54 - fStack_68;
      param_5[1] = fStack_50 - fStack_64;
      param_5[2] = fStack_4c - fStack_60;
    }
    fVar7 = (float10)FUN_00579e50(*(uint *)(param_2 + 4) & 0x3fffffff);
    fStack_10 = (float)((float10)fStack_8c * fVar7);
    fStack_c = (float)((float10)fStack_88 * fVar7);
    fStack_8 = (float)((float10)fStack_84 * fVar7);
    fVar7 = (float10)FUN_00547ec0();
    if ((((float10)_DAT_006ea454 < fVar7) &&
        ((float)param_4 < _DAT_006ee5e4 != (NAN((float)param_4) || NAN(_DAT_006ee5e4)))) &&
       (_DAT_006f60ec < SQRT(fStack_c * fStack_c + fStack_8 * fStack_8 + fStack_10 * fStack_10))) {
      if ((_DAT_006ea454 < *(float *)(param_1 + 0x38)) &&
         (fVar7 = (float10)FUN_00575890(pfVar3,&fStack_10,param_4,0),
         (NAN(fVar7) || NAN((float10)*(float *)(param_1 + 0x3c))) ==
         (fVar7 == (float10)*(float *)(param_1 + 0x3c)))) {
        fVar7 = (fVar7 + (float10)*(float *)(param_1 + 0x3c)) * (float10)_DAT_006ea44c;
        *(float *)(param_1 + 0x3c) = (float)fVar7;
        fVar7 = (float10)_DAT_006e97d8 -
                fVar7 * (float10)*(float *)(param_1 + 0x20) * (float10)*(float *)(param_1 + 0x38);
        *(float *)(param_1 + 0x24) = (float)(fVar7 * (float10)*(float *)(param_1 + 0x14));
        *(float *)(param_1 + 0x28) = (float)(fVar7 * (float10)*(float *)(param_1 + 0x18));
        *(float *)(param_1 + 0x2c) = (float)(fVar7 * (float10)*(float *)(param_1 + 0x1c));
        iVar5 = *(int *)(*(int *)(param_1 + 4) + 0x1a4);
        iVar4 = FUN_0055ab00();
        if (iVar5 == iVar4) {
          FUN_00577cb0();
        }
        else {
          FUN_00577cb0();
        }
      }
      iVar5 = *(int *)(unaff_retaddr + 4);
      if ((iVar5 != 0) && (-1 < *(int *)(iVar5 + 0x1a4))) {
        iVar5 = *(int *)(iVar5 + 0x1a4);
        iVar4 = FUN_0055ab00();
        if (iVar5 == iVar4) {
          fStack_b4 = (float)DAT_00c7e75c;
        }
        else {
          fStack_b4 = (float)(&DAT_00883500)[iVar5];
        }
        if (((fStack_b4 != 0.0) && (iVar5 = FUN_0054a710(iVar5,&fStack_54), iVar5 != -1)) &&
           (iVar5 = FUN_00547dd0(iVar5), iVar5 != -1)) {
          iVar5 = *(int *)((int)fStack_b4 + 0x28 + iVar5 * 4);
          fVar7 = (float10)FUN_00575890(pfVar3,&fStack_10,param_4,1);
          if ((NAN(fVar7) || NAN((float10)*(float *)(iVar5 + 0x3c))) ==
              (fVar7 == (float10)*(float *)(iVar5 + 0x3c))) {
            fVar7 = (fVar7 + (float10)*(float *)(iVar5 + 0x3c)) * (float10)_DAT_006ea44c;
            *(float *)(iVar5 + 0x3c) = (float)fVar7;
            fVar7 = (float10)_DAT_006e97d8 -
                    (float10)*(float *)(iVar5 + 0x38) * (float10)*(float *)(iVar5 + 0x20) * fVar7;
            *(float *)(iVar5 + 0x24) = (float)(fVar7 * (float10)*(float *)(iVar5 + 0x14));
            *(float *)(iVar5 + 0x28) = (float)(fVar7 * (float10)*(float *)(iVar5 + 0x18));
            *(float *)(iVar5 + 0x2c) = (float)(fVar7 * (float10)*(float *)(iVar5 + 0x1c));
            FUN_00577cb0();
          }
        }
      }
    }
    fVar7 = (float10)FUN_00579e50(*(uint *)(param_2 + 4) & 0x3fffffff);
    iVar5 = *(int *)(param_1 + 4);
    fStack_14 = (float)(iVar5 + 0xa4);
    if (((_DAT_006ea454 < fVar1) &&
        (((float)_DAT_006e9830 < ABS(fStack_24) || ((float)_DAT_006e9830 < ABS(fStack_5c))))) ||
       ((float10)_DAT_006f5214 < fVar7 * (float10)fVar1)) {
      pfVar6 = &fStack_54;
      if (*(int *)(unaff_retaddr + 4) != 0) {
        pfStack_58 = &fStack_10;
        fStack_10 = *(float *)(iVar5 + 0x98) + fStack_3c;
        fStack_c = *(float *)(iVar5 + 0x9c) + fStack_38;
        fStack_8 = *(float *)(iVar5 + 0xa0) + fStack_34;
        pfVar6 = &fStack_10;
      }
      iVar5 = *(int *)(unaff_retaddr + 4);
      if ((iVar5 == 0) || (*(int *)(iVar5 + 0x1a4) < 0)) {
        iVar5 = 0;
      }
      FUN_0054a760(param_1,fVar1,*(undefined4 *)(param_1 + 0x10),*(uint *)(param_2 + 4) & 0x3fffffff
                   ,pfVar6,param_4,&fStack_54,fStack_14,fStack_24,fStack_5c,iVar5,pfVar3);
    }
    iVar5 = *(int *)(param_1 + 4);
    if ((*(int *)(iVar5 + 0x1a0) != 0) || ((*(uint *)(param_2 + 4) & 0x3fffffff) < 0x11)) {
      *(float *)(iVar5 + 0x160) = *(float *)(iVar5 + 0x160) + fStack_8c;
      *(float *)(iVar5 + 0x164) = *(float *)(iVar5 + 0x164) + fStack_88;
      *(float *)(iVar5 + 0x168) = *(float *)(iVar5 + 0x168) + fStack_84;
      iVar5 = *(int *)(param_1 + 4);
      *(float *)(iVar5 + 0x16c) =
           *(float *)(iVar5 + 0x16c) + (fStack_38 * fStack_84 - fStack_34 * fStack_88);
      *(float *)(iVar5 + 0x170) =
           *(float *)(iVar5 + 0x170) + (fStack_34 * fStack_8c - fStack_84 * fStack_3c);
      *(float *)(iVar5 + 0x174) =
           *(float *)(iVar5 + 0x174) + (fStack_88 * fStack_3c - fStack_38 * fStack_8c);
    }
    iVar5 = *(int *)(unaff_retaddr + 4);
    if ((iVar5 != 0) && (*(int *)(iVar5 + 0x1a0) != 0)) {
      *(float *)(iVar5 + 0x160) = *(float *)(iVar5 + 0x160) - fStack_8c;
      *(float *)(iVar5 + 0x164) = *(float *)(iVar5 + 0x164) - fStack_88;
      *(float *)(iVar5 + 0x168) = *(float *)(iVar5 + 0x168) - fStack_84;
      iVar5 = *(int *)(unaff_retaddr + 4);
      *(float *)(iVar5 + 0x16c) =
           *(float *)(iVar5 + 0x16c) - (fStack_84 * fStack_70 - fStack_88 * fStack_6c);
      *(float *)(iVar5 + 0x170) =
           *(float *)(iVar5 + 0x170) - (fStack_6c * fStack_8c - fStack_84 * fStack_74);
      *(float *)(iVar5 + 0x174) =
           *(float *)(iVar5 + 0x174) - (fStack_88 * fStack_74 - fStack_70 * fStack_8c);
    }
  }
  return;
}
