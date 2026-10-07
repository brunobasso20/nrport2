/* NR2003.exe @ 0057ca60 FUN_0057ca60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057ca60(float **param_1,float param_2)

{
  float *pfVar1;
  int iVar2;
  float *extraout_ECX;
  
  if (param_1 != (float **)&PTR_DAT_0074fda8) {
    pfVar1 = *param_1;
    if ((pfVar1 != (float *)0x0) &&
       ((((pfVar1 < &DAT_00d3b030 + DAT_00d47d60 * 4 || ((float *)0xd3fe4f < pfVar1)) &&
         (iVar2 = FUN_0057c8b0(param_1), iVar2 != 0)) &&
        ((NAN(*extraout_ECX) || NAN(param_2)) != (*extraout_ECX == param_2))))) {
      return;
    }
    if ((((NAN(param_2) || NAN(_DAT_006ea454)) != (param_2 == _DAT_006ea454)) &&
        (iVar2 = FUN_0057c890(param_1), iVar2 == 0)) && (iVar2 = FUN_0057c860(param_1), iVar2 == 0))
    {
      *param_1 = (float *)PTR_DAT_0074fd80;
      return;
    }
    if ((((NAN(param_2) || NAN(_DAT_006e97d8)) != (param_2 == _DAT_006e97d8)) &&
        (iVar2 = FUN_0057c890(param_1), iVar2 == 0)) && (iVar2 = FUN_0057c860(param_1), iVar2 == 0))
    {
      *param_1 = (float *)PTR_DAT_0074fd84;
      return;
    }
    FUN_0057cb30(param_1);
  }
  **param_1 = param_2;
  return;
}

