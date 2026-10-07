/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005019e0 */

void FUN_005019e0(uint param_1,undefined4 *param_2)

{
  undefined4 *puVar1;
  uint uVar2;
  
  if (((DAT_00b8e58a != 0) && (0 < (int)param_1)) &&
     (puVar1 = (undefined4 *)FUN_00501b80(param_1), puVar1 != (undefined4 *)0x0)) {
    for (uVar2 = param_1 >> 2; uVar2 != 0; uVar2 = uVar2 - 1) {
      *puVar1 = *param_2;
      param_2 = param_2 + 1;
      puVar1 = puVar1 + 1;
    }
    for (param_1 = param_1 & 3; param_1 != 0; param_1 = param_1 - 1) {
      *(undefined1 *)puVar1 = *(undefined1 *)param_2;
      param_2 = (undefined4 *)((int)param_2 + 1);
      puVar1 = (undefined4 *)((int)puVar1 + 1);
    }
  }
  return;
}


