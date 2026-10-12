/* NR2003.exe @ 1001d750 FUN_1001d750 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * __thiscall
FUN_1001d750(void *this,undefined param_1,int param_2,int param_3,int param_4,int param_5,
            int param_6)

{
  float fVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  double *pdVar4;
  char unaff_DI;
  float10 fVar5;
  float10 fVar6;
  double local_18;
  double local_10;
  
  pdVar4 = (double *)0x0;
  uVar2 = *(undefined4 *)(param_2 + 0x10);
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
  fVar1 = *(float *)(param_6 + 0xc);
  *(undefined4 *)((int)this + 0x184) = 0x3f800000;
  *(undefined4 *)((int)this + 0x188) = 0;
  *(undefined4 *)((int)this + 0x18c) = 0;
  *(undefined4 *)((int)this + 400) = 0;
  *(undefined4 *)((int)this + 0x194) = 0x3f800000;
  uVar3 = *(undefined4 *)(param_2 + 0xc);
  *(undefined4 *)((int)this + 0x19c) = uVar2;
  *(undefined4 *)((int)this + 0x198) = uVar3;
  fVar1 = fVar1 - *(float *)(param_5 + 0xc);
  *(undefined *)((int)this + 0x154) = param_1;
  *(undefined ***)this = &PTR_LAB_100353a8;
  if (fVar1 < (float)_DAT_100353a0 == (NAN(fVar1) || NAN((float)_DAT_100353a0))) {
    local_18 = (double)((*(float *)(param_2 + 0xc) - *(float *)(param_5 + 0xc)) / fVar1);
  }
  else {
    local_18 = 0.0;
  }
  fVar1 = *(float *)(param_6 + 0x10) - *(float *)(param_5 + 0x10);
  if (fVar1 < (float)_DAT_100353a0 == (NAN(fVar1) || NAN((float)_DAT_100353a0))) {
    local_10 = (double)((*(float *)(param_2 + 0x10) - *(float *)(param_5 + 0x10)) / fVar1);
  }
  else {
    local_10 = 0.0;
  }
  fVar5 = (float10)fptan((float10)*(float *)(param_2 + 0x2d));
  fVar6 = (float10)fptan((float10)*(float *)(param_2 + 0x1d));
  FUN_1001dd20(this,param_3,
               (double)CONCAT44(*(undefined4 *)(param_2 + 0x15),
                                (int)((ulonglong)(double)*(float *)(param_2 + 0xc) >> 0x20)),
               (double)CONCAT44(SUB84((double)fVar6,0),*(undefined4 *)(param_2 + 0x19)),
               (double)CONCAT44(SUB84((double)*(float *)(param_2 + 0x10),0),
                                (int)((ulonglong)(double)fVar6 >> 0x20)),
               (double)CONCAT44(*(undefined4 *)(param_2 + 0x25),
                                (int)((ulonglong)(double)*(float *)(param_2 + 0x10) >> 0x20)),
               (double)CONCAT44(SUB84((double)fVar5,0),*(undefined4 *)(param_2 + 0x29)),
               (double)CONCAT44(CONCAT31((int3)((uint)param_5 >> 8),*(undefined *)(param_2 + 0x14)),
                                (int)((ulonglong)(double)fVar5 >> 0x20)),unaff_DI);
  if (param_4 != 0) {
    pdVar4 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x54),(float *)((int)this + 0x58),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x5c),(float *)((int)this + 0x60),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 100),(float *)((int)this + 0x68),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x6c),(float *)((int)this + 0x70),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x74),(float *)((int)this + 0x78),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x7c),(float *)((int)this + 0x80),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x40);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x84),(float *)((int)this + 0x88),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x44);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x8c),(float *)((int)this + 0x90),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x10);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x94),(float *)((int)this + 0x98),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x14);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x9c),(float *)((int)this + 0xa0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x10);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xa4),(float *)((int)this + 0xa8),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x14);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xac),(float *)((int)this + 0xb0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x30);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xb4),(float *)((int)this + 0xb8),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x34);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xbc),(float *)((int)this + 0xc0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x30);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xc4),(float *)((int)this + 200),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x34);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xcc),(float *)((int)this + 0xd0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x50);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xd4),(float *)((int)this + 0xd8),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x54);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xdc),(float *)((int)this + 0xe0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x50);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xe4),(float *)((int)this + 0xe8),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x54);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xec),(float *)((int)this + 0xf0),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x60);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xf4),(float *)((int)this + 0xf8),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 100);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0xfc),(float *)((int)this + 0x100),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 0x60);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x104),(float *)((int)this + 0x108),pdVar4);
  if (param_4 == 0) {
    pdVar4 = (double *)0x0;
  }
  else {
    pdVar4 = *(double **)(param_4 + 100);
  }
  FUN_1001e450(local_18,local_10,(float *)((int)this + 0x10c),(float *)((int)this + 0x110),pdVar4);
  return (undefined4 *)this;
}

