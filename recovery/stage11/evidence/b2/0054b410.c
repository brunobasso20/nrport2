/* NR2003.exe @ 0054b410 FUN_0054b410 */

void __fastcall FUN_0054b410(int param_1)

{
  float *pfVar1;
  int iVar2;
  float10 fVar3;
  
  iVar2 = 0;
  pfVar1 = (float *)(param_1 + 0x10);
  do {
    fVar3 = (float10)FUN_005486a0(param_1,iVar2);
    *pfVar1 = (float)fVar3;
    iVar2 = iVar2 + 1;
    pfVar1 = pfVar1 + 1;
  } while (iVar2 < 0xb);
  iVar2 = 0;
  pfVar1 = (float *)(param_1 + 0x3c);
  do {
    fVar3 = (float10)FUN_00548c50(param_1,iVar2);
    *pfVar1 = (float)fVar3;
    iVar2 = iVar2 + 1;
    pfVar1 = pfVar1 + 1;
  } while (iVar2 < 4);
  fVar3 = (float10)FUN_00548910(param_1);
  *(float *)(param_1 + 0x4c) = (float)fVar3;
  fVar3 = (float10)FUN_00548960(param_1);
  *(float *)(param_1 + 0x50) = (float)fVar3;
  fVar3 = (float10)FUN_005487f0(param_1);
  *(float *)(param_1 + 0x54) = (float)fVar3;
  fVar3 = (float10)FUN_00548360(param_1);
  *(float *)(param_1 + 0x58) = (float)fVar3;
  fVar3 = (float10)FUN_005488b0(param_1);
  *(float *)(param_1 + 0x5c) = (float)fVar3;
  fVar3 = (float10)FUN_00548850(param_1);
  *(float *)(param_1 + 0x60) = (float)fVar3;
  *(undefined4 *)(param_1 + 100) = 0;
  return;
}

