/* FUN_1001dd20 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_1001dd20(void *this,int param_1,double param_2,double param_3,double param_4,double param_5,
            double param_6,double param_7,char param_8)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  float fVar7;
  float fVar8;
  int iVar9;
  float fVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float fVar18;
  float fVar19;
  float *unaff_EDI;
  float10 fVar20;
  float10 fVar21;
  float10 fVar22;
  float10 fVar23;
  float10 fVar24;
  float10 fVar25;
  float10 fVar26;
  float10 extraout_ST0;
  float10 extraout_ST0_00;
  undefined4 in_stack_00000008;
  float10 *__return_storage_ptr__;
  float local_74;
  undefined8 local_68;
  undefined8 local_60;
  float local_50;
  float local_4c;
  float local_40;
  float local_3c;
  float local_38;
  float local_34;
  undefined8 local_30;
  float local_20;
  float local_1c;

  fVar20 = (float10)fcos((float10)*(double *)(param_1 + 0x20));
  local_20 = (float)fVar20;
  fVar21 = (float10)fsin((float10)*(double *)(param_1 + 0x20));
  local_1c = (float)fVar21;
  fVar22 = (float10)fcos((float10)*(double *)(param_1 + 0x38));
  local_38 = (float)fVar22;
  fVar23 = (float10)fsin((float10)*(double *)(param_1 + 0x38));
  local_34 = (float)fVar23;
  fVar3 = (float)*(double *)(param_1 + 0x10);
  fVar4 = (float)*(double *)(param_1 + 0x18);
  local_30 = CONCAT44(fVar4,fVar3);
  fVar5 = (float)*(double *)(param_1 + 0x28);
  fVar6 = (float)*(double *)(param_1 + 0x30);
  local_60 = CONCAT44(fVar6,fVar5);
  fVar24 = (float10)(double)CONCAT44(param_2._0_4_,in_stack_00000008);
  fVar1 = (float)((float10)fVar3 + (float10)(float)-fVar21 * fVar24);
  fVar10 = fVar4 + (float)((float10)(float)fVar20 * fVar24);
  fVar25 = (float10)(double)CONCAT44(param_5._0_4_,param_4._4_4_);
  local_40 = (float)((float10)fVar3 + (float10)(float)-fVar21 * fVar25);
  local_3c = (float)((float10)(float)fVar20 * fVar25) + fVar4;
  iVar9 = *(int *)(param_1 + 0xc);
  *(undefined4 *)((int)this + 0x4c) = 0;
  *(undefined4 *)((int)this + 0x48) = 0;
  *(undefined4 *)((int)this + 0x44) = 0;
  *(undefined4 *)((int)this + 0x40) = 0;
  *(undefined4 *)((int)this + 0x50) = 0x3f800000;
  local_50 = (float)((float10)fVar5 + (float10)(float)-fVar23 * fVar24);
  local_4c = fVar6 + (float)(fVar22 * fVar24);
  fVar11 = fVar5 + (float)((float10)(float)-fVar23 * fVar25);
  fVar2 = (float)(fVar22 * fVar25 + (float10)fVar6);
  if ((iVar9 == 0) || (param_7._4_1_ != '\0')) {
    *(float *)((int)this + 0x14) = fVar1;
    *(undefined4 *)((int)this + 0xc) = 0;
    *(float *)((int)this + 0x10) = fVar11 - fVar1;
    *(undefined4 *)((int)this + 8) = 0;
    *(undefined4 *)((int)this + 4) = 0;
    *(undefined4 *)((int)this + 0x20) = 0;
    *(undefined4 *)((int)this + 0x1c) = 0;
    *(undefined4 *)((int)this + 0x18) = 0;
    *(float *)((int)this + 0x24) = fVar2 - fVar10;
    *(float *)((int)this + 0x28) = fVar10;
    local_74 = (float)(double)CONCAT44(param_3._0_4_,param_2._4_4_);
    *(float *)((int)this + 0x158) = fVar1;
    *(float *)((int)this + 0x15c) = fVar10;
    *(float *)((int)this + 0x160) = local_74;
    *(undefined4 *)((int)this + 0x164) = 0x3f800000;
    *(float *)((int)this + 0x168) = fVar1;
    *(float *)((int)this + 0x16c) = fVar10;
    *(float *)((int)this + 0x170) = local_74;
    *(undefined4 *)((int)this + 0x174) = 0x3f800000;
    *(float *)((int)this + 0x178) = fVar11;
    *(float *)((int)this + 0x17c) = fVar2;
    *(float *)((int)this + 0x180) = (float)(double)CONCAT44(param_6._0_4_,param_5._4_4_);
    *(undefined4 *)((int)this + 0x184) = 0x3f800000;
    *(float *)((int)this + 0x188) = fVar11;
    *(float *)((int)this + 0x18c) = fVar2;
    *(float *)((int)this + 400) = (float)(double)CONCAT44(param_6._0_4_,param_5._4_4_);
    *(undefined4 *)((int)this + 0x194) = 0x3f800000;
    local_68 = CONCAT44(fVar4 - fVar6,fVar3 - fVar5);
    __return_storage_ptr__ = (float10 *)&local_68;
    FUN_10028a70(__return_storage_ptr__,unaff_EDI);
    fVar21 = extraout_ST0 * (float10)(double)CONCAT44(param_4._0_4_,param_3._4_4_);
    local_68 = CONCAT44(fVar4 - fVar6,fVar3 - fVar5);
    FUN_10028a70((float10 *)&local_68,(float *)__return_storage_ptr__);
    fVar20 = extraout_ST0_00;
  }
  else {
    fVar20 = ABS((float10)*(double *)(param_1 + 0x38) - (float10)*(double *)(param_1 + 0x20));
    if ((float10)_DAT_100349c0 < fVar20) {
      fVar20 = (float10)_DAT_100353b8 - fVar20;
    }
    fVar23 = (float10)fsin((float10)_DAT_10034380 * fVar20);
    fVar23 = ABS(fVar23);
    fVar22 = (float10)fcos((float10)(double)((float10)_DAT_10034380 * fVar20));
    fVar12 = SQRT((local_50 - fVar1) * (local_50 - fVar1) +
                  (local_4c - fVar10) * (local_4c - fVar10));
    fVar13 = SQRT((fVar11 - local_40) * (fVar11 - local_40) +
                  (fVar2 - local_3c) * (fVar2 - local_3c));
    fVar21 = (float10)_DAT_100349a0;
    fVar24 = fVar23 * fVar23 * (float10)_DAT_10034ba0;
    fVar25 = (fVar21 - ABS(fVar22)) * (float10)fVar12;
    fVar25 = (fVar25 + fVar25) / fVar24;
    fVar26 = (float10)local_20 * fVar25 + (float10)fVar1;
    fVar6 = (float)((float10)local_1c * fVar25) + fVar10;
    fVar4 = (float)((float10)local_50 - (float10)local_38 * fVar25) * _DAT_100353b4;
    fVar3 = (float)((((float10)_DAT_100353b4 * fVar26 - (float10)fVar1) - (float10)fVar4) +
                   (float10)local_50);
    fVar4 = (float)(((float10)(fVar1 * _DAT_100353b4) - fVar26 * (float10)_DAT_100353b0) +
                   (float10)fVar4);
    fVar5 = (float)((float10)_DAT_100353b4 * fVar26 - (float10)(fVar1 * _DAT_100353b4));
    fVar14 = (local_4c - (float)((float10)local_34 * fVar25)) * _DAT_100353b4;
    local_4c = ((fVar6 * _DAT_100353b4 - fVar10) - fVar14) + local_4c;
    fVar14 = (fVar10 * _DAT_100353b4 - fVar6 * _DAT_100353b0) + fVar14;
    fVar15 = fVar6 * _DAT_100353b4 - fVar10 * _DAT_100353b4;
    local_74 = (float)(double)CONCAT44(param_3._0_4_,param_2._4_4_);
    *(float *)((int)this + 0x158) = fVar1;
    *(float *)((int)this + 0x15c) = fVar10;
    *(float *)((int)this + 0x160) = local_74;
    *(undefined4 *)((int)this + 0x164) = 0x3f800000;
    fVar21 = (fVar21 - ABS(fVar22)) * (float10)fVar13;
    *(float *)((int)this + 0x168) = (float)fVar26;
    *(float *)((int)this + 0x16c) = fVar6;
    fVar24 = (fVar21 + fVar21) / fVar24;
    *(float *)((int)this + 0x170) =
         (float)(fVar25 * (float10)(double)CONCAT44(param_4._0_4_,param_3._4_4_) +
                (float10)(double)CONCAT44(param_3._0_4_,param_2._4_4_));
    *(undefined4 *)((int)this + 0x174) = 0x3f800000;
    fVar6 = (float)((float10)local_40 + (float10)local_20 * fVar24);
    fVar25 = (float10)local_1c * fVar24 + (float10)local_3c;
    fVar7 = (float)((float10)fVar11 - (float10)local_38 * fVar24);
    fVar8 = (float)((float10)fVar2 - (float10)local_34 * fVar24);
    fVar16 = fVar6 * _DAT_100353b4;
    fVar17 = fVar7 * _DAT_100353b4;
    fVar18 = local_40 * _DAT_100353b4;
    fVar6 = fVar6 * _DAT_100353b0;
    fVar26 = fVar25 * (float10)_DAT_100353b4;
    fVar19 = fVar8 * _DAT_100353b4;
    fVar21 = (float10)_DAT_100353b4;
    fVar22 = (float10)_DAT_100353b0;
    *(float *)((int)this + 0x14) = fVar1;
    *(float *)((int)this + 0x28) = fVar10;
    *(float *)((int)this + 4) = (((fVar16 - local_40) - fVar17) + fVar11) - fVar3;
    *(float *)((int)this + 8) = ((fVar18 - fVar6) + fVar17 + fVar3) - fVar4;
    *(float *)((int)this + 0xc) = ((fVar16 - fVar18) + fVar4) - fVar5;
    *(float *)((int)this + 0x10) = (local_40 + fVar5) - fVar1;
    *(float *)((int)this + 0x18) =
         (float)(((fVar26 - (float10)local_3c) - (float10)fVar19) + (float10)fVar2) - local_4c;
    *(float *)((int)this + 0x1c) =
         ((float)(((float10)local_3c * fVar21 - fVar25 * fVar22) + (float10)fVar19) + local_4c) -
         fVar14;
    *(float *)((int)this + 0x20) = ((float)(fVar26 - (float10)local_3c * fVar21) + fVar14) - fVar15;
    *(float *)((int)this + 0x24) = (local_3c + fVar15) - fVar10;
    *(float *)((int)this + 0x178) = fVar7;
    *(float *)((int)this + 0x17c) = fVar8;
    *(float *)((int)this + 0x180) =
         (float)((float10)(double)CONCAT44(param_6._0_4_,param_5._4_4_) -
                fVar24 * (float10)(double)CONCAT44(param_7._0_4_,param_6._4_4_));
    *(undefined4 *)((int)this + 0x184) = 0x3f800000;
    *(float *)((int)this + 0x188) = fVar11;
    *(float *)((int)this + 0x18c) = fVar2;
    *(float *)((int)this + 400) = (float)(double)CONCAT44(param_6._0_4_,param_5._4_4_);
    *(undefined4 *)((int)this + 0x194) = 0x3f800000;
    fVar22 = (float10)_DAT_100349a0 / (fVar23 + fVar23);
    fVar21 = (float10)fVar12 * fVar22 * fVar20 *
             (float10)(double)CONCAT44(param_4._0_4_,param_3._4_4_);
    fVar20 = fVar22 * (float10)fVar13 * fVar20;
  }
  fVar1 = (float)fVar21;
  fVar20 = fVar20 * (float10)(double)CONCAT44(param_7._0_4_,param_6._4_4_);
  fVar21 = (float10)(double)CONCAT44(param_3._0_4_,param_2._4_4_) -
           (float10)(double)CONCAT44(param_6._0_4_,param_5._4_4_);
  *(undefined4 *)((int)this + 0x2c) = 0;
  *(float *)((int)this + 0x3c) = local_74;
  *(float *)((int)this + 0x30) = (float)((float10)fVar1 + fVar20 + fVar21 + fVar21);
  *(float *)((int)this + 0x34) =
       (float)(((float10)(double)CONCAT44(param_6._0_4_,param_5._4_4_) -
               (float10)(double)CONCAT44(param_3._0_4_,param_2._4_4_)) * (float10)_DAT_10034ba0 -
              ((float10)fVar1 + (float10)fVar1 + fVar20));
  *(float *)((int)this + 0x38) = fVar1;
  return;
}
