/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00523ac0 */

void __thiscall FUN_00523ac0(undefined4 *param_1_00,undefined4 *param_1)

{
  int iVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  
  if (param_1 != (undefined4 *)0x0) {
    puVar2 = param_1_00;
    puVar3 = param_1;
    for (iVar1 = 0x16; iVar1 != 0; iVar1 = iVar1 + -1) {
      *puVar3 = *puVar2;
      puVar2 = puVar2 + 1;
      puVar3 = puVar3 + 1;
    }
    param_1[0x16] = param_1_00[0x18];
    param_1[0x17] = *(undefined4 *)((int)param_1_00 + 0x79);
    param_1[0x18] = *(undefined4 *)((int)param_1_00 + 0x7d);
    param_1[0x19] = *(undefined4 *)((int)param_1_00 + 0x6d);
  }
  return;
}


