/* NR2003.exe @ 100118e0 FUN_100118e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int __thiscall FUN_100118e0(void *this,float param_1)

{
  float fVar1;
  float *pfVar2;
  int iVar3;
  int iVar4;
  float10 fVar5;
  
  iVar4 = 0;
  if (1 < *(int *)((int)this + 0x38)) {
    pfVar2 = *(float **)((int)this + 0x3c);
    iVar3 = 1;
    do {
      pfVar2 = pfVar2 + 1;
      if (param_1 <= *pfVar2) break;
      iVar4 = iVar4 + 1;
      iVar3 = iVar3 + 1;
    } while (iVar3 < *(int *)((int)this + 0x38));
  }
  fVar5 = (float10)(**(code **)(*DAT_10042dc4 + 0x28))();
  *(float *)(*(int *)((int)this + 0x3c) + *(int *)((int)this + 0x38) * 4) = (float)fVar5;
  iVar3 = *(int *)((int)this + 0x3c);
  fVar1 = *(float *)(iVar3 + 4 + iVar4 * 4) - *(float *)(iVar3 + iVar4 * 4);
  if (fVar1 <= _DAT_10034cb8) {
    *(undefined4 *)(&DAT_100429dc + DAT_10042a1c * 4) = 0x3f800000;
  }
  else {
    fVar1 = (param_1 - *(float *)(iVar3 + iVar4 * 4)) / fVar1;
    if (fVar1 < _DAT_100348d0 == (NAN(fVar1) || NAN(_DAT_100348d0))) {
      if (_DAT_100341f0 < fVar1) {
        fVar1 = _DAT_100341f0;
      }
      *(float *)(&DAT_100429dc + DAT_10042a1c * 4) = fVar1;
    }
    else {
      *(float *)(&DAT_100429dc + DAT_10042a1c * 4) = _DAT_100348d0;
    }
  }
  DAT_10042a1c = DAT_10042a1c + 1;
  iVar3 = (**(code **)(*DAT_10042244 + 0x154))();
  if (iVar3 < *(int *)((int)this + 0x38)) {
    iVar3 = (**(code **)(*DAT_10042244 + 0x154))();
    if (iVar4 < iVar3) {
      iVar4 = (**(code **)(*DAT_10042244 + 0x154))();
      return iVar4;
    }
  }
  return iVar4;
}

