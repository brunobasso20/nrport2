/* NR2003.exe @ 100043a0 FUN_100043a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_100043a0(void *this,float param_1,float param_2,float param_3,float param_4,float param_5,
            float param_6)

{
  float fVar1;
  float10 fVar2;
  float10 fVar3;
  float10 fVar4;
  
  fVar2 = (float10)_DAT_10034380;
  *(float *)this = param_3;
  *(float *)((int)this + 4) = param_4;
  fVar2 = (float10)fptan((float10)param_1 * fVar2);
  fVar2 = fVar2 * (float10)param_3;
  fVar3 = fVar2 / (float10)param_2;
  fVar4 = (fVar2 - -fVar2) * (float10)param_5 * (float10)_DAT_10034378;
  fVar1 = (float)((fVar3 - -fVar3) * (float10)param_6 * (float10)_DAT_10034378);
  *(float *)((int)this + 8) = (float)(-fVar2 - fVar4);
  *(float *)((int)this + 0xc) = (float)(fVar2 - fVar4);
  *(float *)((int)this + 0x10) = (float)(-fVar3 - (float10)fVar1);
  *(float *)((int)this + 0x14) = (float)(fVar3 - (float10)fVar1);
  return;
}

