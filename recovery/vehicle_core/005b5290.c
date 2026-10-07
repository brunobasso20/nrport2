/* Ghidra pseudo-C; NR2003.exe @ 005b5290 */

void __thiscall FUN_005b5290(int param_1_00,undefined4 param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int iVar3;
  undefined4 *puVar4;
  
  puVar2 = (undefined4 *)FUN_005b4de0(param_1);
  if (puVar2 != (undefined4 *)0x0) {
    puVar1 = (undefined4 *)((*(uint *)(param_1_00 + 9) & 0x3ff) * 0x1f + 0xd + param_1_00);
    puVar4 = puVar1;
    for (iVar3 = 7; iVar3 != 0; iVar3 = iVar3 + -1) {
      *puVar4 = *puVar2;
      puVar2 = puVar2 + 1;
      puVar4 = puVar4 + 1;
    }
    *(undefined2 *)puVar4 = *(undefined2 *)puVar2;
    *(undefined1 *)((int)puVar4 + 2) = *(undefined1 *)((int)puVar2 + 2);
    *(undefined4 *)((int)puVar1 + 0x1b) = DAT_00eab1cc;
    *(int *)(param_1_00 + 5) = *(int *)(param_1_00 + 5) + 1;
    *(int *)(param_1_00 + 9) = *(int *)(param_1_00 + 9) + 1;
    if (0x400 < *(int *)(param_1_00 + 5)) {
      *(undefined4 *)(param_1_00 + 5) = 0x400;
      *(undefined4 *)(param_1_00 + 1) = *(undefined4 *)(param_1_00 + 9);
      *(uint *)(param_1_00 + 1) = *(uint *)(param_1_00 + 1) & 0x3ff;
    }
  }
  return;
}

