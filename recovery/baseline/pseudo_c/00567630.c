/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567630 */

void FUN_00567630(int param_1)

{
  int iVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  
  iVar1 = FUN_004f5970(param_1);
  puVar3 = (undefined4 *)(iVar1 + 0x1327);
  puVar4 = (undefined4 *)(&DAT_00c53500 + param_1 * 0x68);
  for (iVar2 = 0x1a; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar4 = *puVar3;
    puVar3 = puVar3 + 1;
    puVar4 = puVar4 + 1;
  }
  return;
}


