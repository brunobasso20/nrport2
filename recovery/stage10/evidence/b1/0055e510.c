/* NR2003.exe @ 0055e510 FUN_0055e510 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055e510(int param_1,float param_2,float param_3,undefined4 param_4,float param_5)

{
  float *pfVar1;
  int iVar2;
  float10 fVar3;
  float local_4;
  
  local_4 = -0.35;
  iVar2 = 0x23;
  pfVar1 = (float *)(param_1 + 0xc);
  do {
    fVar3 = (float10)FUN_005677d1(&DAT_006f5b50,-(local_4 * param_2));
    iVar2 = iVar2 + -1;
    *pfVar1 = (float)(fVar3 * (float10)param_2 * (float10)param_5);
    local_4 = local_4 + _DAT_006ea4a4;
    pfVar1 = pfVar1 + 1;
  } while (iVar2 != 0);
  local_4 = local_4 + _DAT_006ea4a4;
  *(undefined4 *)(param_1 + 0x98) = 0;
  iVar2 = 0x22;
  pfVar1 = (float *)(param_1 + 0x9c);
  do {
    fVar3 = (float10)FUN_005677d1(&DAT_006f5b50,local_4 * param_2);
    iVar2 = iVar2 + -1;
    *pfVar1 = (float)(fVar3 * (float10)param_2 * (float10)param_3 * (float10)_DAT_006ee488);
    local_4 = local_4 + _DAT_006ea4a4;
    pfVar1 = pfVar1 + 1;
  } while (iVar2 != 0);
  return;
}

