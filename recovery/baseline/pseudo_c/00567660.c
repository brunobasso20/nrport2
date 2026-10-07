/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567660 */

void FUN_00567660(int param_1)

{
  uint *puVar1;
  char cVar2;
  int iVar3;
  uint uVar4;
  int iVar5;
  undefined4 *puVar6;
  undefined4 *puVar7;
  
  iVar3 = FUN_004f5970(param_1);
  puVar6 = (undefined4 *)(&DAT_00c53500 + param_1 * 0x68);
  puVar7 = (undefined4 *)(iVar3 + 0x1327);
  for (iVar5 = 0x1a; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar7 = *puVar6;
    puVar6 = puVar6 + 1;
    puVar7 = puVar7 + 1;
  }
  iVar5 = getIntCount();
  *(int *)(iVar3 + 0x1323) = iVar5;
  *(undefined4 *)(iVar3 + 0x131b) = 0;
  *(undefined4 *)(iVar3 + 0x131f) = 0;
  cVar2 = FUN_005c2cf0(*(undefined4 *)(iVar3 + 0x138f));
  if (cVar2 != '\0') {
    uVar4 = FUN_005c2e10(*(undefined4 *)(iVar3 + 0x138f));
    puVar1 = (uint *)(iVar3 + 0x131b + (uVar4 >> 5) * 4);
    *puVar1 = *puVar1 | 1 << ((byte)uVar4 & 0x1f);
  }
  return;
}


