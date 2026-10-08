/* NR2003.exe @ 0051c300 FUN_0051c300 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0051c300(undefined4 *param_1)

{
  float fVar1;
  double dVar2;
  char cVar3;
  float10 fVar4;
  double dVar5;
  
  cVar3 = FUN_00548a00(param_1[3]);
  if (cVar3 == '\0') {
    fVar1 = (float)param_1[1];
    fVar4 = (float10)FUN_00547ec0();
    dVar2 = (double)((float10)fVar1 * (float10)fVar1 * (float10)fVar1 * (float10)_DAT_006f47e0 *
                    fVar4);
    dVar5 = rndUniform(0);
    if (dVar5 < dVar2 != (NAN(dVar5) || NAN(dVar2))) {
      FUN_00548aa0(param_1[3],1);
      FUN_0055e7e0(param_1[3]);
    }
    param_1[1] = 0;
    *param_1 = 0;
  }
  return;
}

