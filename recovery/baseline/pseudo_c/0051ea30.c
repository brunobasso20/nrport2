/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051ea30 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051ea30(float param_1)

{
  float fVar1;
  float fVar2;
  int iVar3;
  float10 fVar4;
  float10 fVar5;
  float local_c;
  float local_8;
  
  iVar3 = (int)param_1;
  fVar1 = *(float *)((int)param_1 + 0x1ad2) * _DAT_006ea44c;
  local_8 = *(float *)((int)param_1 + 0x18b6) * _DAT_006f49b4 * *(float *)((int)param_1 + 0x195a);
  local_c = *(float *)((int)param_1 + 0x1ad2);
  param_1 = fVar1 - local_8;
  local_8 = local_8 + fVar1;
  if (param_1 < _DAT_006ea454) {
    param_1 = 0.0;
  }
  if (local_8 < _DAT_006ea454) {
    local_8 = 0.0;
  }
  if (local_c < _DAT_006f412c) {
    local_c = 1e-09;
  }
  fVar1 = local_c * _DAT_006f49b0;
  fVar4 = (float10)FUN_0050a1f0(fVar1);
  fVar5 = (float10)FUN_0050a1b0(fVar1);
  fVar1 = (float)((fVar5 + (float10)(float)fVar4) * (float10)_DAT_006ea44c);
  fVar4 = (float10)FUN_0050a1b0(local_8 * _DAT_006f49ac);
  fVar5 = (float10)FUN_0050a1f0(param_1 * _DAT_006f49ac);
  fVar2 = (float)(((fVar5 * (float10)param_1 + (float10)(float)(fVar4 * (float10)local_8)) /
                  (float10)local_c) / (float10)fVar1);
  fVar5 = (float10)1.4426950408889634 * (float10)*(float *)(iVar3 + 0x1862) * (float10)_DAT_006f49a8
  ;
  fVar4 = ROUND(fVar5);
  fVar5 = (float10)f2xm1(fVar5 - fVar4);
  fVar4 = (float10)fscale((float10)1 + fVar5,fVar4);
  *(float *)(iVar3 + 0x1ae2) =
       (float)(fVar4 * (float10)*(float *)(iVar3 + 0x196e) * (float10)fVar1 * (float10)_DAT_006f49b0
              );
  fVar4 = (float10)FUN_005100c0(*(undefined4 *)(*(int *)(iVar3 + 0x1a76) + 0x4c));
  fVar5 = (float10)FUN_0051f8d0(iVar3);
  fVar1 = (float)fVar5;
  if (fVar1 < _DAT_006e97d8) {
    fVar5 = (float10)FUN_006c5c40();
  }
  fVar4 = (float10)*(float *)(iVar3 + 0x17f2) * (float10)*(float *)(iVar3 + 0x1ae2) *
          (float10)_DAT_0074bc0c * fVar5 * (float10)(float)fVar4 * (float10)fVar2;
  *(float *)(iVar3 + 0x1ae2) = (float)fVar4;
  *(float *)(iVar3 + 0x1972) = (float)(fVar4 * (float10)*(float *)(iVar3 + 0x1ad2));
  fVar2 = *(float *)(iVar3 + 0x17fa) * *(float *)(iVar3 + 0x17f6) * _DAT_0074bc0c * fVar1 * fVar2;
  *(float *)(iVar3 + 0x187a) = fVar2;
  fVar1 = *(float *)(iVar3 + 0x17f2) / *(float *)(iVar3 + 0x17f6);
  if (_DAT_006e97d8 < fVar1) {
    *(float *)(iVar3 + 0x187a) = fVar2 * fVar1;
  }
  if (_DAT_006ea454 < *(float *)(iVar3 + 0x1b40)) {
    *(float *)(iVar3 + 0x1972) =
         ((_DAT_006e97d8 - _DAT_0074ac30) * (_DAT_006e97d8 - *(float *)(iVar3 + 0x1b40)) +
         _DAT_0074ac30) * *(float *)(iVar3 + 0x1972);
  }
  if (0 < *(int *)(iVar3 + 0x1b22)) {
    *(float *)(iVar3 + 0x1972) = *(float *)(iVar3 + 0x1972) * _DAT_006efb28;
  }
  if (*(float *)(iVar3 + 0x1972) < _DAT_006ea454) {
    *(undefined4 *)(iVar3 + 0x1972) = 0;
  }
  return;
}


