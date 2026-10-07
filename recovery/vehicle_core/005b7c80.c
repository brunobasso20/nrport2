/* Ghidra pseudo-C; NR2003.exe @ 005b7c80 */

void FUN_005b7c80(undefined4 *param_1,undefined4 *param_2,int param_3,undefined4 *param_4,
                 undefined4 *param_5,int param_6,undefined1 *param_7)

{
  undefined1 *puVar1;
  undefined1 *puVar2;
  uint uVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  
  while( true ) {
    if ((int)param_7 < 1) {
      return;
    }
    puVar1 = (undefined1 *)((int)param_2 + (param_3 - (int)param_1));
    puVar2 = (undefined1 *)((int)param_5 + (param_6 - (int)param_4));
    if ((int)puVar2 <= (int)puVar1) {
      puVar1 = puVar2;
    }
    if ((int)param_7 < (int)puVar1) {
      puVar1 = param_7;
    }
    puVar4 = param_4;
    puVar5 = param_1;
    for (uVar3 = (uint)puVar1 >> 2; uVar3 != 0; uVar3 = uVar3 - 1) {
      *puVar5 = *puVar4;
      puVar4 = puVar4 + 1;
      puVar5 = puVar5 + 1;
    }
    for (uVar3 = (uint)puVar1 & 3; uVar3 != 0; uVar3 = uVar3 - 1) {
      *(undefined1 *)puVar5 = *(undefined1 *)puVar4;
      puVar4 = (undefined4 *)((int)puVar4 + 1);
      puVar5 = (undefined4 *)((int)puVar5 + 1);
    }
    param_7 = param_7 + -(int)puVar1;
    if (param_7 == (undefined1 *)0x0) break;
    param_1 = (undefined4 *)((int)param_1 + (int)puVar1);
    param_4 = (undefined4 *)((int)param_4 + (int)puVar1);
    if (param_1 == (undefined4 *)((int)param_2 + param_3)) {
      param_1 = param_2;
    }
    if (param_4 == (undefined4 *)((int)param_5 + param_6)) {
      param_4 = param_5;
    }
  }
  return;
}

