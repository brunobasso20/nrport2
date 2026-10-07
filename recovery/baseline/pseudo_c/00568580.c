/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00568580 */

void FUN_00568580(undefined4 *param_1)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  
  iVar2 = FUN_00568610();
  if (iVar2 != 0) {
    puVar3 = &DAT_00c5b070;
    puVar4 = &DAT_00c57450;
    for (iVar2 = 0x438; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar4 = *puVar3;
      puVar3 = puVar3 + 1;
      puVar4 = puVar4 + 1;
    }
    iVar2 = FUN_00568770();
    uVar1 = DAT_00c57440;
    if (iVar2 != 0) {
      puVar3 = &DAT_00c548a0;
      puVar4 = &DAT_00c585a0;
      for (iVar2 = 0xab3; DAT_00c5c1c0 = DAT_00c57448, iVar2 != 0; iVar2 = iVar2 + -1) {
        *puVar4 = *puVar3;
        puVar3 = puVar3 + 1;
        puVar4 = puVar4 + 1;
      }
      puVar3 = &DAT_00c573f8;
      puVar4 = &DAT_00c57378;
      for (iVar2 = 0x12; iVar2 != 0; iVar2 = iVar2 + -1) {
        *puVar4 = *puVar3;
        puVar3 = puVar3 + 1;
        puVar4 = puVar4 + 1;
      }
      DAT_00c5c1b8 = uVar1;
      DAT_00c5c1bc = DAT_00c57444;
      DAT_00c5c1c4 = DAT_00c5744c;
      *param_1 = 1;
      return;
    }
  }
  *param_1 = 0;
  return;
}


