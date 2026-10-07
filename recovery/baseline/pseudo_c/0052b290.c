/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052b290 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0052b290(int param_1,float param_2,undefined4 param_3)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  int iVar5;
  
  iVar5 = (int)param_2;
  if (DAT_00bdbd00 != 5) {
    FUN_0052acd0(param_1,param_2,param_3,*(float *)((int)param_2 + 0x19ce) * _DAT_006f4164,
                 0xbbad7442,0x41f00000,0x3e124925,0x3eaaaaab,0x3dcccccd,0x3e800000,0x3f800000,0);
    return;
  }
  fVar2 = (float)*(int *)(param_1 + 0x16b3) * _DAT_006f4614;
  fVar3 = *(float *)((int)param_2 + 0x19ce) * _DAT_006efad8;
  pfVar1 = (float *)((int)param_2 + 0x1876);
  param_2 = fVar2 * _DAT_006ea49c - _DAT_006f51c4;
  if (fVar3 < _DAT_006f51c0) {
    fVar4 = _DAT_006f51bc;
    if (_DAT_006e9814 <= fVar3) {
      fVar4 = (_DAT_006f51c0 - fVar3) * _DAT_006f51b8;
    }
    param_2 = param_2 + fVar4;
  }
  if (_DAT_006f51c0 < param_2) {
    param_2 = -0.0018905;
  }
  FUN_0052acd0(param_1,iVar5,param_3,(*pfVar1 - fVar3) * fVar2 + fVar3,param_2,
               _DAT_006f1624 * fVar2 + _DAT_006ee370,0x3dcccccd,0x3e800000,0x3e124925,0x3eaaaaab,
               0x3f800000,0);
  return;
}


