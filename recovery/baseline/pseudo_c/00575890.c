/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00575890 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall
FUN_00575890(int param_1,undefined4 param_2,float *param_3,undefined4 param_4,char param_5)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float10 fVar4;
  float local_c;
  float local_8;
  float local_4;
  
  FUN_005f6d20(&local_c,*(int *)(param_1 + 4) + 0xf0,param_1 + 0x14);
  fVar1 = param_3[2];
  fVar2 = param_3[1];
  fVar3 = *param_3;
  fVar4 = (float10)FUN_00547ec0();
  fVar4 = -(fVar4 * (float10)*(float *)(param_1 + 0x20) *
           (float10)(local_c * fVar3 + local_8 * fVar2 + local_4 * fVar1));
  if (param_5 != '\0') {
    fVar4 = -fVar4;
  }
  if ((fVar4 < (float10)_DAT_006f60ec) ||
     (fVar4 = (float10)_DAT_006e97d8 - (float10)_DAT_006f60e4 / (fVar4 + (float10)_DAT_006f60e8),
     fVar4 < (float10)*(float *)(param_1 + 0x3c))) {
    fVar4 = (float10)*(float *)(param_1 + 0x3c);
  }
  return fVar4;
}


