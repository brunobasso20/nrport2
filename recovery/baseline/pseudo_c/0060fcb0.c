/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0060fcb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0060fcb0(float *param_1)

{
  float fVar1;
  float fVar2;
  longlong lVar3;
  longlong lVar4;
  __uint64 _Var5;
  
  lVar4 = FUN_005cfcfc();
  fVar1 = _DAT_006ea454;
  if (param_1[0xf] == -NAN) {
    param_1[0xf] = 0.0;
  }
  else {
    lVar3 = *(longlong *)(param_1 + 0x10);
    _Var5 = taskGetCPURate();
    fVar1 = (float)(lVar4 - lVar3) / (float)(longlong)_Var5;
  }
  fVar2 = (float)_DAT_006f0688;
  *(longlong *)(param_1 + 0x10) = lVar4;
  if (fVar1 <= fVar2) {
    param_1[1] = 1000.0;
  }
  else {
    param_1[1] = _DAT_006e97d8 / fVar1;
  }
  param_1[0xe] = (param_1[0xe] - param_1[(int)param_1[0xf] + 2]) + fVar1;
  param_1[(int)param_1[0xf] + 2] = fVar1;
  fVar1 = param_1[0xf];
  param_1[0xf] = (float)((int)fVar1 + 1);
  if (0xb < (int)fVar1 + 1) {
    *(undefined1 *)(param_1 + 0x12) = 1;
    param_1[0xf] = 0.0;
  }
  if ((*(char *)(param_1 + 0x12) != '\0') && (_DAT_006ef604 < param_1[0xe])) {
    *param_1 = _DAT_006ea630 / param_1[0xe];
    return;
  }
  *param_1 = 0.0;
  return;
}


