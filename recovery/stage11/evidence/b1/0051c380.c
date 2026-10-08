/* NR2003.exe @ 0051c380 FUN_0051c380 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0051c380(float param_1)

{
  undefined4 uVar1;
  int *piVar2;
  int iVar3;
  double dVar4;
  
  uVar1 = FUN_0055ab00();
  piVar2 = (int *)FUN_00562f70(uVar1);
  iVar3 = (**(code **)(*piVar2 + 8))();
  if (-1 < *(char *)(iVar3 + 0xe)) {
    dVar4 = rndUniform(0);
    if (dVar4 < (double)param_1 * (double)_DAT_006f47e8) {
      FUN_0054b940(7,1);
    }
  }
  return;
}

