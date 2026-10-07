/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0057ca60 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057ca60(undefined **param_1,float param_2)

{
  undefined *puVar1;
  int iVar2;
  float *extraout_ECX;
  
  if (param_1 != &PTR_DAT_0074fda8) {
    puVar1 = *param_1;
    if ((puVar1 != (undefined *)0x0) &&
       ((((puVar1 < &DAT_00d3b030 + DAT_00d47d60 * 4 || ((undefined *)0xd3fe4f < puVar1)) &&
         (iVar2 = FUN_0057c8b0(param_1), iVar2 != 0)) && (*extraout_ECX == param_2)))) {
      return;
    }
    if (((param_2 == _DAT_006ea454) && (iVar2 = FUN_0057c890(param_1), iVar2 == 0)) &&
       (iVar2 = FUN_0057c860(param_1), iVar2 == 0)) {
      *param_1 = PTR_DAT_0074fd80;
      return;
    }
    if (((param_2 == _DAT_006e97d8) && (iVar2 = FUN_0057c890(param_1), iVar2 == 0)) &&
       (iVar2 = FUN_0057c860(param_1), iVar2 == 0)) {
      *param_1 = PTR_DAT_0074fd84;
      return;
    }
    FUN_0057cb30(param_1);
  }
  *(float *)*param_1 = param_2;
  return;
}


