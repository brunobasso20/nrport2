/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00551e10 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00551e10(float param_1,undefined4 param_2)

{
  float fVar1;
  undefined4 uVar2;
  int iVar3;
  
  fVar1 = _DAT_006ea454;
  if ((_DAT_006ea454 <= param_1) && (fVar1 = param_1, _DAT_006f59d4 < param_1)) {
    fVar1 = _DAT_006f59d4;
  }
  fVar1 = fVar1 * _DAT_006f51f0;
  uVar2 = FUN_0055ab00();
  iVar3 = FUN_00562f70(uVar2);
  *(float *)(iVar3 + 0x1510) = fVar1;
  uVar2 = FUN_0055ab00();
  iVar3 = FUN_00562f70(uVar2);
  *(undefined4 *)(iVar3 + 0x1508) = param_2;
  return;
}


