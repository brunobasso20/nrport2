/* Ghidra pseudo-C; NR2003.exe @ 005b7900 */

void FUN_005b7900(int param_1)

{
  ushort uVar1;
  uint uVar2;
  undefined4 *puVar3;
  
  uVar1 = *(ushort *)(&DAT_00eab627 + param_1 * 9);
  (&DAT_00eab624)[param_1 * 9] = 0;
  if (uVar1 != 0) {
    puVar3 = *(undefined4 **)(&DAT_00eab629 + param_1 * 9);
    for (uVar2 = (uint)(uVar1 >> 2); uVar2 != 0; uVar2 = uVar2 - 1) {
      *puVar3 = 0;
      puVar3 = puVar3 + 1;
    }
    for (uVar2 = uVar1 & 3; uVar2 != 0; uVar2 = uVar2 - 1) {
      *(undefined1 *)puVar3 = 0;
      puVar3 = (undefined4 *)((int)puVar3 + 1);
    }
  }
  return;
}

