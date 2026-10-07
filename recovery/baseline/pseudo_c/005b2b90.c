/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b2b90 */

void FUN_005b2b90(undefined4 param_1,undefined4 *param_2)

{
  undefined4 *puVar1;
  undefined4 uVar2;
  undefined4 *puVar3;
  
  puVar3 = &DAT_00e84474;
  do {
    puVar1 = (undefined4 *)*puVar3;
    uVar2 = *param_2;
    puVar3 = puVar3 + 1;
    param_2 = param_2 + 1;
    *puVar1 = uVar2;
  } while ((int)puVar3 < 0xe84498);
  FUN_005b9d10(DAT_00e84548);
  FUN_005b9d10(DAT_00e84498);
  return;
}


