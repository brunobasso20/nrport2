/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5010 */

void __fastcall FUN_005b5010(ushort *param_1)

{
  undefined4 *puVar1;
  uint uVar2;
  uint uVar3;
  ushort *puVar4;
  
  FUN_00501870(0xe);
  uVar3 = (uint)*param_1 * 0x23;
  puVar1 = (undefined4 *)FUN_00501a20(uVar3 + 4);
  if (puVar1 != (undefined4 *)0x0) {
    *puVar1 = DAT_00eab1cc;
    puVar4 = param_1 + 1;
    for (uVar2 = uVar3 >> 2; puVar1 = puVar1 + 1, uVar2 != 0; uVar2 = uVar2 - 1) {
      *puVar1 = *(undefined4 *)puVar4;
      puVar4 = puVar4 + 2;
    }
    for (uVar3 = uVar3 & 3; uVar3 != 0; uVar3 = uVar3 - 1) {
      *(char *)puVar1 = (char)*puVar4;
      puVar4 = (ushort *)((int)puVar4 + 1);
      puVar1 = (undefined4 *)((int)puVar1 + 1);
    }
  }
  *param_1 = 0;
  FUN_00501a40();
  return;
}


