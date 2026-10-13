/* FUN_1001cf60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * __thiscall
FUN_1001cf60(void *this,undefined param_1,double param_2,double param_3,int param_4,int param_5,
            int param_6,int param_7,int param_8,double param_9,double param_10,char param_11)

{
  float fVar1;
  float fVar2;
  double dVar3;
  double dVar4;
  double dVar5;
  double dVar6;
  double dVar7;
  double dVar8;
  double dVar9;
  double dVar10;
  float fVar11;
  float fVar12;
  float fVar13;
  float fVar14;
  float fVar15;
  float fVar16;
  float fVar17;
  float fVar18;
  float fVar19;
  float fVar20;
  float fVar21;
  undefined4 in_EDX;
  undefined4 extraout_EDX;
  double *pdVar22;
  char unaff_DI;
  float10 fVar23;
  float10 fVar24;
  float10 fVar25;
  float10 fVar26;
  float10 fVar27;
  float10 fVar28;
  float10 fVar29;
  unkbyte10 Var30;
  unkbyte10 Var31;
  undefined4 in_stack_00000008;
  undefined4 in_stack_00000030;
  undefined4 local_80;
  undefined4 uStack_7c;
  undefined4 local_78;
  undefined4 uStack_74;

  *(undefined4 *)((int)this + 0x158) = 0;
  *(undefined4 *)((int)this + 0x15c) = 0;
  *(undefined4 *)((int)this + 0x160) = 0;
  *(undefined4 *)((int)this + 0x164) = 0x3f800000;
  *(undefined4 *)((int)this + 0x168) = 0;
  *(undefined4 *)((int)this + 0x16c) = 0;
  *(undefined4 *)((int)this + 0x170) = 0;
  *(undefined4 *)((int)this + 0x174) = 0x3f800000;
  *(undefined4 *)((int)this + 0x178) = 0;
  *(undefined4 *)((int)this + 0x17c) = 0;
  *(undefined4 *)((int)this + 0x180) = 0;
  *(undefined4 *)((int)this + 0x184) = 0x3f800000;
  *(undefined4 *)((int)this + 0x188) = 0;
  *(undefined4 *)((int)this + 0x18c) = 0;
  *(undefined4 *)((int)this + 400) = 0;
  *(undefined4 *)((int)this + 0x194) = 0x3f800000;
  *(float *)((int)this + 0x198) = (float)(double)CONCAT44(param_2._0_4_,in_stack_00000008);
  *(float *)((int)this + 0x19c) = (float)(double)CONCAT44(param_3._0_4_,param_2._4_4_);
  fVar23 = (float10)_param_8;
  fVar25 = (float10)_DAT_10034998;
  fVar24 = (float10)param_9;
  *(undefined *)((int)this + 0x154) = param_1;
  *(undefined ***)this = &PTR_LAB_100353a8;
  dVar3 = param_2;
  if ((((NAN(fVar23) || NAN(fVar25)) == (fVar23 == fVar25)) ||
      ((NAN(fVar24) || NAN((float10)_DAT_10034998)) == (fVar24 == (float10)_DAT_10034998))) &&
     (param_10._0_1_ != '\0')) {
    Var30 = fpatan((float10)*(double *)(param_6 + 0x15) - (float10)*(double *)(param_7 + 0x15),
                   (float10)*(float *)(param_6 + 0xc) - (float10)*(float *)(param_7 + 0xc));
    Var31 = fpatan((float10)*(double *)(param_6 + 0x25) - (float10)*(double *)(param_7 + 0x25),
                   (float10)*(float *)(param_6 + 0x10) - (float10)*(float *)(param_7 + 0x10));
    fVar25 = (float10)fsin(Var30);
    dVar3 = (double)(fVar25 * fVar23 + (float10)(double)CONCAT44(param_2._0_4_,in_stack_00000008));
    in_stack_00000008 = SUB84(dVar3,0);
    param_2._0_4_ = (undefined4)((ulonglong)dVar3 >> 0x20);
    fVar25 = (float10)fsin(Var31);
    dVar4 = (double)(fVar25 * fVar24 + (float10)(double)CONCAT44(param_3._0_4_,param_2._4_4_));
    param_2._4_4_ = SUB84(dVar4,0);
    dVar3 = (double)CONCAT44(param_2._4_4_,param_2._0_4_);
    param_3._0_4_ = (undefined4)((ulonglong)dVar4 >> 0x20);
    fVar25 = (float10)fcos(Var30);
    fVar23 = ABS(fVar25) * fVar23;
    _param_8 = (double)fVar23;
    fVar25 = (float10)fcos(Var31);
    fVar24 = ABS(fVar25) * fVar24;
    param_9 = (double)fVar24;
  }
  param_2._4_4_ = (undefined4)((ulonglong)dVar3 >> 0x20);
  param_2._0_4_ = SUB84(dVar3,0);
  fVar21 = *(float *)(param_7 + 0xc) - *(float *)(param_6 + 0xc);
  if (fVar21 < (float)_DAT_100353a0 == (NAN(fVar21) || NAN((float)_DAT_100353a0))) {
    fVar21 = ((float)(double)CONCAT44(param_2._0_4_,in_stack_00000008) - *(float *)(param_6 + 0xc))
             / fVar21;
  }
  else {
    fVar21 = 0.0;
  }
  fVar25 = (float10)*(float *)(param_7 + 0x10) - (float10)*(float *)(param_6 + 0x10);
  if (fVar25 < (float10)_DAT_100353a0 == (NAN(fVar25) || NAN((float10)_DAT_100353a0))) {
    fVar25 = ((float10)(double)CONCAT44(param_3._0_4_,param_2._4_4_) -
             (float10)*(float *)(param_6 + 0x10)) / fVar25;
  }
  else {
    fVar25 = (float10)_DAT_10034998;
  }
  fVar26 = (float10)_DAT_100349a0 - (float10)fVar21;
  dVar3 = *(double *)(param_6 + 0x15);
  dVar4 = *(double *)(param_7 + 0x15);
  fVar27 = (float10)fptan((float10)*(float *)(param_6 + 0x1d));
  fVar28 = (float10)fptan((float10)*(float *)(param_7 + 0x1d));
  dVar5 = (double)(fVar28 * (float10)fVar21 + fVar27 * fVar26);
  fVar27 = (float10)_DAT_100349a0 - fVar25;
  dVar6 = *(double *)(param_6 + 0x25);
  dVar7 = *(double *)(param_7 + 0x25);
  fVar28 = (float10)fptan((float10)*(float *)(param_7 + 0x2d));
  fVar29 = (float10)fptan((float10)*(float *)(param_6 + 0x2d));
  dVar8 = (double)(fVar29 * fVar27 + fVar28 * fVar25);
  dVar9 = (double)(fVar24 + (float10)*(double *)(param_6 + 0x25));
  dVar10 = (double)(fVar23 + (float10)*(double *)(param_6 + 0x15));
  FUN_1001dd20(this,param_3._4_4_,
               (double)CONCAT44(SUB84(dVar10,0),
                                (int)((ulonglong)(double)*(float *)(param_6 + 0xc) >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_6 + 0x1d),0),
                                (int)((ulonglong)dVar10 >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_6 + 0x10),0),
                                (int)((ulonglong)(double)*(float *)(param_6 + 0x1d) >> 0x20)),
               (double)CONCAT44(SUB84(dVar9,0),
                                (int)((ulonglong)(double)*(float *)(param_6 + 0x10) >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_6 + 0x2d),0),
                                (int)((ulonglong)dVar9 >> 0x20)),
               (double)CONCAT44(CONCAT31((int3)((uint)in_EDX >> 8),*(undefined *)(param_6 + 0x14)),
                                (int)((ulonglong)(double)*(float *)(param_6 + 0x2d) >> 0x20)),
               unaff_DI);
  fVar11 = *(float *)((int)this + 0x34);
  fVar12 = *(float *)((int)this + 0x30);
  fVar13 = *(float *)((int)this + 0x38);
  fVar14 = *(float *)((int)this + 0x3c);
  dVar9 = param_9 + *(double *)(param_7 + 0x25);
  dVar10 = _param_8 + *(double *)(param_7 + 0x15);
  FUN_1001dd20(this,param_3._4_4_,
               (double)CONCAT44(SUB84(dVar10,0),
                                (int)((ulonglong)(double)*(float *)(param_7 + 0xc) >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_7 + 0x1d),0),
                                (int)((ulonglong)dVar10 >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_7 + 0x10),0),
                                (int)((ulonglong)(double)*(float *)(param_7 + 0x1d) >> 0x20)),
               (double)CONCAT44(SUB84(dVar9,0),
                                (int)((ulonglong)(double)*(float *)(param_7 + 0x10) >> 0x20)),
               (double)CONCAT44(SUB84((double)*(float *)(param_7 + 0x2d),0),
                                (int)((ulonglong)dVar9 >> 0x20)),
               (double)CONCAT44(CONCAT31((int3)((uint)fVar11 >> 8),*(undefined *)(param_7 + 0x14)),
                                (int)((ulonglong)(double)*(float *)(param_7 + 0x2d) >> 0x20)),
               unaff_DI);
  fVar1 = *(float *)((int)this + 0x30);
  fVar2 = *(float *)((int)this + 0x34);
  fVar18 = (float)fVar26;
  fVar15 = *(float *)((int)this + 0x38);
  fVar16 = *(float *)((int)this + 0x3c);
  fVar17 = fVar1 * fVar21 + fVar12 * fVar18;
  uStack_7c = (undefined4)((ulonglong)dVar8 >> 0x20);
  local_80 = SUB84(dVar8,0);
  fVar20 = fVar2 * fVar21 + fVar11 * fVar18;
  fVar19 = fVar15 * fVar21 + fVar13 * fVar18;
  fVar18 = fVar16 * fVar21 + fVar14 * fVar18;
  dVar6 = (double)(fVar25 * (float10)dVar7 + fVar27 * (float10)dVar6) + param_9;
  uStack_74 = (undefined4)((ulonglong)dVar5 >> 0x20);
  local_78 = SUB84(dVar5,0);
  _param_8 = (double)((float10)fVar21 * (float10)dVar4 + fVar26 * (float10)dVar3) + _param_8;
  FUN_1001dd20(this,param_3._4_4_,(double)CONCAT44(SUB84(_param_8,0),param_2._0_4_),
               (double)CONCAT44(local_78,(int)((ulonglong)_param_8 >> 0x20)),
               (double)CONCAT44(param_2._4_4_,uStack_74),
               (double)CONCAT44(SUB84(dVar6,0),param_3._0_4_),
               (double)CONCAT44(local_80,(int)((ulonglong)dVar6 >> 0x20)),
               (double)CONCAT44(CONCAT31((int3)((uint)extraout_EDX >> 8),
                                         *(undefined *)((int)this + 0x154)),uStack_7c),unaff_DI);
  *(float *)((int)this + 0x2c) = (fVar1 * (float)fVar25 + fVar12 * (float)fVar27) - fVar17;
  *(float *)((int)this + 0x30) =
       ((fVar2 * (float)fVar25 + fVar11 * (float)fVar27) - fVar20) + fVar17;
  *(float *)((int)this + 0x34) =
       ((fVar15 * (float)fVar25 + fVar13 * (float)fVar27) - fVar19) + fVar20;
  *(float *)((int)this + 0x38) =
       ((fVar16 * (float)fVar25 + fVar14 * (float)fVar27) - fVar18) + fVar19;
  *(float *)((int)this + 0x3c) = fVar18;
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x40);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x54),(float *)((int)this + 0x58),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x44);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x5c),(float *)((int)this + 0x60),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 100),(float *)((int)this + 0x68),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0x6c),(float *)((int)this + 0x70),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x40);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x74),(float *)((int)this + 0x78),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x44);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x7c),(float *)((int)this + 0x80),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0x84),(float *)((int)this + 0x88),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0x8c),(float *)((int)this + 0x90),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x10);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x94),(float *)((int)this + 0x98),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x14);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0x9c),(float *)((int)this + 0xa0),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x10);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xa4),(float *)((int)this + 0xa8),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x14);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xac),(float *)((int)this + 0xb0),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x30);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xb4),(float *)((int)this + 0xb8),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x34);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xbc),(float *)((int)this + 0xc0),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x30);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xc4),(float *)((int)this + 200),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x34);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xcc),(float *)((int)this + 0xd0),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x50);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xd4),(float *)((int)this + 0xd8),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x54);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xdc),(float *)((int)this + 0xe0),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x50);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xe4),(float *)((int)this + 0xe8),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x54);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0xec),(float *)((int)this + 0xf0),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 0x60);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xf4),(float *)((int)this + 0xf8),pdVar22);
  if (param_5 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_5 + 100);
  }
  FUN_1001e450(0.0,0.0,(float *)((int)this + 0xfc),(float *)((int)this + 0x100),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 0x60);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0x104),(float *)((int)this + 0x108),pdVar22);
  if (param_4 == 0) {
    pdVar22 = (double *)0x0;
  }
  else {
    pdVar22 = *(double **)(param_4 + 100);
  }
  FUN_1001e450(1.0,1.0,(float *)((int)this + 0x10c),(float *)((int)this + 0x110),pdVar22);
  return (undefined4 *)this;
}
