/* Ghidra pseudo-C; NR2003.exe @ 005b5150 */

void __thiscall FUN_005b5150(uint *param_1_00,int param_1)

{
  int iVar1;
  uint uVar2;
  int *piVar3;
  
  uVar2 = *param_1_00 - 1 & 0x3ff;
  piVar3 = (int *)((int)param_1_00 + uVar2 * 0x23 + 0x27);
  iVar1 = *piVar3;
  while (param_1 <= iVar1) {
    *piVar3 = -0x80000000;
    uVar2 = uVar2 - 1 & 0x3ff;
    piVar3 = (int *)((int)param_1_00 + uVar2 * 0x23 + 0x27);
    iVar1 = *(int *)((int)param_1_00 + uVar2 * 0x23 + 0x27);
  }
  *param_1_00 = uVar2 + 1 & 0x3ff;
  return;
}

