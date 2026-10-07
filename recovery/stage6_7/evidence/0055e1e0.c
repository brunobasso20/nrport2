/* NR2003.exe @ 0055e1e0 FUN_0055e1e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_0055e1e0(uint *param_1,undefined4 param_2,float *param_3,undefined4 *param_4,
                    float *param_5,int param_6,undefined4 param_7,undefined4 param_8,
                    undefined4 param_9,undefined4 param_10,undefined4 param_11)

{
  int iVar1;
  undefined4 *puVar2;
  
  puVar2 = DAT_00c08628;
  DAT_00c08620 = param_5[3];
  DAT_00c0828c = param_5[4];
  _DAT_00c08444 = param_2;
  iVar1 = param_6 * 0xa39;
  *(undefined4 *)((int)&DAT_00bf3ce0 + iVar1) = param_11;
  *puVar2 = param_7;
  *DAT_00c0862c = param_8;
  *DAT_00c08630 = param_9;
  *DAT_00c08568 = param_10;
  *DAT_00c08304 = *param_4;
  *DAT_00c08308 = param_4[1];
  *DAT_00c0830c = param_4[2];
  *DAT_00c08538 = *param_5;
  *DAT_00c0853c = param_5[1];
  *DAT_00c08540 = param_5[2];
  FUN_005b9d10((&DAT_00e84b90)[param_6]);
  *param_1 = *DAT_00c085cc;
  param_1[1] = *DAT_00c085d0;
  param_1[2] = *DAT_00c085d4;
  param_5[3] = DAT_00c08620;
  param_5[4] = DAT_00c0828c;
  *param_3 = *DAT_00c08554;
  param_3[1] = *DAT_00c08558;
  param_3[2] = *DAT_00c0855c;
  if (DAT_00c08284 == 2) {
    *param_5 = *param_3;
    param_5[1] = param_3[1];
    param_5[2] = param_3[2];
  }
  else if (DAT_00c08284 == 1) {
    *param_5 = *param_3 - _DAT_00c08624 * *DAT_00c08594;
    param_5[1] = param_3[1] - _DAT_00c08624 * *DAT_00c08598;
    param_5[2] = param_3[2] - _DAT_00c08624 * *DAT_00c0859c;
  }
  *(undefined4 *)(&DAT_00bf4418 + iVar1) = *DAT_00c082a0;
  *(undefined4 *)(&DAT_00bf441c + iVar1) = *DAT_00c082a4;
  *(undefined4 *)(&DAT_00bf4420 + iVar1) = *DAT_00c082a8;
  *(float *)(&DAT_00bf440c + iVar1) = *param_3;
  *(float *)(&DAT_00bf4410 + iVar1) = param_3[1];
  *(float *)(&DAT_00bf4414 + iVar1) = param_3[2];
  return (float10)(float)(*param_1 & 0x7fffffff) * (float10)_DAT_006ea50c +
         (float10)(float)(param_1[1] & 0x7fffffff);
}

