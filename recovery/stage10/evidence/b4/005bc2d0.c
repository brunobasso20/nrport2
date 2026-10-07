/* NR2003.exe @ 005bc2d0 FUN_005bc2d0 */

/* WARNING: Type propagation algorithm not settling */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_005bc2d0(int param_1,int param_2,int param_3)

{
  int *piVar1;
  int iVar2;
  float fVar3;
  uint uVar4;
  int iVar5;
  uint uVar6;
  int iVar7;
  uint uVar8;
  uint unaff_ESI;
  double *pdVar9;
  undefined4 unaff_EDI;
  double *pdVar10;
  float10 fVar11;
  float10 fVar12;
  float10 fVar13;
  int unaff_retaddr;
  float in_stack_0000ada8;
  float in_stack_0000adac;
  float in_stack_0000adbc;
  int in_stack_0000adc0;
  float in_stack_0000adcc;
  float in_stack_0000add4;
  int in_stack_0000adf4;
  int in_stack_0000adf8;
  int in_stack_0000adfc;
  int in_stack_0000ae00;
  float in_stack_0000ae04;
  int in_stack_0000ae30;
  undefined4 uVar14;
  undefined4 uVar15;
  char *pcVar16;
  float fStack_78;
  float fStack_74;
  int iStack_64;
  float fStack_60;
  uint uStack_5c;
  float fStack_58;
  int *piStack_54;
  uint uStack_50;
  uint uStack_4c;
  int *local_48;
  int iStack_44;
  int iStack_40;
  int iStack_3c;
  int iStack_38;
  int iStack_34;
  int iStack_30;
  int iStack_2c;
  float afStack_28 [8];
  int iStack_8;
  int iStack_4;
  
  piVar1 = (int *)FUN_005d8700();
  if (piVar1 != (int *)0x0) {
    pcVar16 = s_groove_mip_00752eec;
    local_48 = piVar1;
    (**(code **)(*piVar1 + 0x1c))(s_groove_mip_00752eec);
    uVar15 = 1;
    uVar14 = 1;
    iVar2 = (**(code **)(*piVar1 + 0x18))(1,1);
    if ((iVar2 != 0) && (fVar3 = (float)FUN_005e4de0(), afStack_28[0] = fVar3, fVar3 != 0.0)) {
      iVar2 = FUN_005cfce4(&fStack_58,DAT_00b8faa0 << 3);
      pdVar9 = (double *)(-(uint)(iVar2 != 0) & (uint)fStack_58);
      iVar2 = FUN_005cfce4(&fStack_60,DAT_00b8faa0 * 8);
      uVar8 = -(uint)(iVar2 != 0) & (uint)fStack_60;
      iVar2 = FUN_005cfce4(&stack0xffffff7c,DAT_00b8faa0 * 8);
      uVar6 = -(uint)(iVar2 != 0) & unaff_ESI;
      uStack_50 = uVar6;
      iVar2 = FUN_005cfce4(&uStack_4c,DAT_00b8faa0 << 3);
      uStack_5c = -(uint)(iVar2 != 0) & uStack_4c;
      iVar2 = FUN_005cfce4(&local_48,DAT_00b8faa0 * 8);
      uVar4 = -(uint)(iVar2 != 0) & (uint)local_48;
      if (pdVar9 != (double *)0x0) {
        if ((((uVar8 != 0) && (uVar6 != 0)) && (uStack_5c != 0)) && (uVar4 != 0)) {
          iVar2 = 0;
          iStack_64 = 0;
          fStack_74 = 0.0;
          fStack_78 = 0.0;
          if (3 < DAT_00b8faa0) {
            fStack_58 = 0.0;
            iVar7 = DAT_00b8faa0 + -1;
            do {
              fStack_78 = fStack_78 + *(float *)(param_1 + iVar7 * 4);
              *(undefined4 *)((int)afStack_28 + (int)fStack_58 + 4) =
                   *(undefined4 *)(param_1 + iVar7 * 4);
              iVar2 = iVar7 + 1;
              iVar5 = iStack_8 + 0x14;
              *(undefined4 *)((int)afStack_28 + (int)fStack_58 + 0x10) =
                   *(undefined4 *)(iStack_8 + 0x14 + iVar7 * 0x1c);
              fStack_74 = *(float *)(iVar5 + iVar7 * 0x1c) + fStack_74;
              if (DAT_00b8faa0 <= iVar2) {
                iVar2 = 0;
              }
              fStack_58 = (float)((int)fStack_58 + 4);
              iVar7 = iVar2;
            } while ((int)fStack_58 < 0xc);
          }
          if (0 < DAT_00b8faa0) {
            iStack_40 = iStack_8 - iStack_4;
            iStack_3c = unaff_retaddr - iStack_4;
            iStack_44 = param_1 - param_2;
            iStack_38 = uStack_5c - (int)pdVar9;
            iStack_34 = uVar8 - (int)pdVar9;
            iStack_30 = uStack_50 - (int)pdVar9;
            iStack_2c = uVar4 - (int)pdVar9;
            pdVar10 = pdVar9;
            do {
              iVar7 = iStack_8;
              if (DAT_00b8faa0 < 4) {
                fStack_58 = *(float *)(iStack_44 + param_2);
                fStack_60 = *(float *)(iStack_40 + iStack_4 + 0x14);
              }
              else {
                fStack_58 = fStack_78 * _DAT_006f49d0;
                fStack_60 = fStack_74 * _DAT_006f49d0;
                fVar3 = *(float *)(param_1 + iVar2 * 4);
                iVar5 = iStack_64 + 1;
                fStack_78 = (fVar3 - afStack_28[iStack_64 + 1]) + fStack_78;
                afStack_28[iVar5] = fVar3;
                fVar3 = *(float *)(iVar7 + 0x14 + iVar2 * 0x1c);
                fStack_74 = (fVar3 - afStack_28[iStack_64 + 4]) + fStack_74;
                afStack_28[iStack_64 + 4] = fVar3;
                iStack_64 = iVar5;
                if (2 < iVar5) {
                  iStack_64 = 0;
                }
                iVar2 = iVar2 + 1;
                if (DAT_00b8faa0 <= iVar2) {
                  iVar2 = 0;
                }
              }
              fVar11 = (float10)FUN_006c6f60(uVar14,uVar15,pcVar16,unaff_EDI);
              fVar11 = ((float10)in_stack_0000ada8 * (float10)in_stack_0000adac +
                       fVar11 * (float10)_DAT_006f75e8 + (float10)_DAT_006ea44c) *
                       (float10)_DAT_006ea44c;
              if (fVar11 < (float10)_DAT_006ea454 == (NAN(fVar11) || NAN((float10)_DAT_006ea454))) {
                if ((float10)_DAT_006e97d8 < fVar11) {
                  fVar11 = (float10)_DAT_006e97d8;
                }
              }
              else {
                fVar11 = (float10)_DAT_006ea454;
              }
              fVar12 = (float10)_DAT_006ea454;
              if (_DAT_006ea67c < in_stack_0000add4) {
                fVar12 = ((float10)in_stack_0000ada8 * (float10)_DAT_006f75e0 +
                         (float10)_DAT_006ec6d8) *
                         ((float10)in_stack_0000add4 - (float10)_DAT_006ea67c) *
                         (float10)_DAT_006f75e4;
                fVar13 = (float10)1.442695040888963 * fVar12 * fVar12 * (float10)_DAT_006f75d8;
                fVar12 = ROUND(fVar13);
                fVar13 = (float10)f2xm1(fVar13 - fVar12);
                fVar12 = (float10)fscale((float10)1 + fVar13,fVar12);
                fVar12 = ((float10)_DAT_006e97d8 - fVar12) * (float10)_DAT_006f4658;
                if (fVar12 < (float10)_DAT_006ea454 == (NAN(fVar12) || NAN((float10)_DAT_006ea454)))
                {
                  if ((float10)_DAT_006f4658 < fVar12) {
                    fVar12 = (float10)_DAT_006f4658;
                  }
                }
                else {
                  fVar12 = (float10)_DAT_006ea454;
                }
              }
              *(double *)((int)pdVar10 + in_stack_0000adf4) = (double)fVar12;
              *pdVar10 = (double)in_stack_0000adcc;
              *(double *)((int)pdVar10 + in_stack_0000adf8) = (double)in_stack_0000adbc;
              *(double *)((int)pdVar10 + in_stack_0000adfc) = (double)in_stack_0000adac;
              *(double *)((int)pdVar10 + in_stack_0000ae00) = (double)fVar11;
              in_stack_0000adc0 = in_stack_0000adc0 + 1;
              pdVar10 = pdVar10 + 1;
              param_1 = in_stack_0000ae30;
              fVar3 = in_stack_0000ae04;
            } while (in_stack_0000adc0 < DAT_00b8faa0);
          }
          *(double **)((int)fVar3 + 0x1c) = pdVar9;
          *(uint *)((int)fVar3 + 0x20) = uVar8;
          *(uint *)((int)fVar3 + 0x24) = uStack_50;
          *(uint *)((int)fVar3 + 0x28) = uStack_5c;
          *(uint *)((int)fVar3 + 0x2c) = uVar4;
          *(double *)((int)fVar3 + 0x14) = (double)_DAT_006f75d0;
          iVar2 = DAT_00b8faa0;
          *(int **)((int)fVar3 + 0x10) = piStack_54;
          *(int *)((int)fVar3 + 0xc) = iVar2;
          if (*(int *)(param_3 + 0x24) != 0) {
            FUN_005cff12(*(int *)(param_3 + 0x24));
          }
          *(float *)(param_3 + 0x24) = fVar3;
          return 1;
        }
        FUN_005cfccc(pdVar9);
      }
      if (uVar8 != 0) {
        FUN_005cfccc(uVar8);
      }
      if (uVar6 != 0) {
        FUN_005cfccc(uVar6);
      }
      if (uStack_5c != 0) {
        FUN_005cfccc(uStack_5c);
      }
      if (uVar4 != 0) {
        FUN_005cfccc(uVar4);
      }
      FUN_005cff12(piStack_54);
      piVar1 = piStack_54;
    }
    FUN_005cff12(piVar1);
  }
  return 0;
}

