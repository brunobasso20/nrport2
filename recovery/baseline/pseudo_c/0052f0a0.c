/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052f0a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052f0a0(int param_1)

{
  float fVar1;
  float *pfVar2;
  int iVar3;
  undefined4 uVar4;
  float10 fVar5;
  float10 fVar6;
  float local_4;
  
  *(undefined4 *)(param_1 + 0x1d4e) = 0;
  pfVar2 = (float *)(param_1 + 0x1d62);
  iVar3 = 4;
  do {
    if (pfVar2[-0x1e] == 5.60519e-45) {
      *(float *)(param_1 + 0x1d4e) =
           ((*pfVar2 - _DAT_006e97d8) + _DAT_006e97d8) * _DAT_0074ad98 +
           *(float *)(param_1 + 0x1d4e);
    }
    if (pfVar2[-0x16] != 0.0) {
      *(float *)(param_1 + 0x1d4e) =
           ((pfVar2[4] - _DAT_006e97d8) + _DAT_006e97d8) * _DAT_0074ad80 +
           *(float *)(param_1 + 0x1d4e);
    }
    pfVar2 = pfVar2 + 1;
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  *(undefined4 *)(param_1 + 0x1d52) = *(undefined4 *)(param_1 + 0x1d4e);
  iVar3 = *(int *)(param_1 + 0x5ae);
  if (iVar3 == 0) {
    uVar4 = 1;
    local_4 = 0.0;
  }
  else {
    local_4 = *(float *)(iVar3 + 0x44);
    uVar4 = *(undefined4 *)(iVar3 + 0x4c);
  }
  fVar5 = (float10)FUN_00579ef0(uVar4);
  fVar6 = (float10)FUN_00579ee0(uVar4);
  fVar5 = ((fVar6 + (float10)(float)(fVar5 * (float10)local_4 * (float10)local_4)) /
          (float10)*(float *)(param_1 + 0x1af6)) * (float10)*(float *)(param_1 + 0x1ad2) +
          (float10)*(float *)(param_1 + 0x1d4e) + (float10)_DAT_006f5210;
  *(float *)(param_1 + 0x1d4e) = (float)fVar5;
  fVar1 = *(float *)(param_1 + 0x1972) * _DAT_006e981c;
  if ((float10)fVar1 < fVar5) {
    *(float *)(param_1 + 0x1d4e) = fVar1;
  }
  return;
}


