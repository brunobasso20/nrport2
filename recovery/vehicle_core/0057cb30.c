/* Ghidra pseudo-C; NR2003.exe @ 0057cb30 */

void FUN_0057cb30(undefined4 param_1)

{
  int iVar1;
  undefined4 *extraout_ECX;
  undefined4 *extraout_ECX_00;
  undefined4 *puVar2;
  undefined8 uVar3;
  
  iVar1 = FUN_0057c890(param_1);
  if (iVar1 == 0) {
    uVar3 = FUN_0057c860(extraout_ECX);
    iVar1 = (int)((ulonglong)uVar3 >> 0x20);
    puVar2 = extraout_ECX_00;
    if ((int)uVar3 == 0) goto LAB_0057cb5f;
  }
  else {
    uVar3 = CONCAT44(DAT_00d47d60,*extraout_ECX);
    puVar2 = extraout_ECX;
  }
  iVar1 = (int)((ulonglong)uVar3 >> 0x20);
  (&DAT_00d3fe50)[iVar1] = (int)uVar3;
LAB_0057cb5f:
  *puVar2 = &DAT_00d3b030 + iVar1 * 4;
  DAT_00d47d60 = DAT_00d47d60 + 1;
  return;
}

