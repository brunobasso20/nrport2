/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b50f0 */

void __thiscall FUN_005b50f0(uint *param_1_00,undefined4 *param_1)

{
  int iVar1;
  uint uVar2;
  undefined4 *puVar3;
  
  puVar3 = (undefined4 *)(*param_1_00 * 0x23 + 8 + (int)param_1_00);
  for (iVar1 = 8; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar3 = *param_1;
    param_1 = param_1 + 1;
    puVar3 = puVar3 + 1;
  }
  *(undefined2 *)puVar3 = *(undefined2 *)param_1;
  *(undefined1 *)((int)puVar3 + 2) = *(undefined1 *)((int)param_1 + 2);
  uVar2 = *param_1_00 + 1 & 0x3ff;
  *param_1_00 = uVar2;
  if (uVar2 == param_1_00[1]) {
    param_1_00[1] = param_1_00[1] + 1 & 0x3ff;
  }
  *(undefined4 *)(uVar2 * 0x23 + 0x27 + (int)param_1_00) = 0x80000000;
  return;
}


