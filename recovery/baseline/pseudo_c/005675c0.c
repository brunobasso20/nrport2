/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005675c0 */

void FUN_005675c0(int param_1)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  
  uVar2 = FUN_00567610(*(uint *)(param_1 + 4) & 0x7f);
  iVar3 = FUN_004f5970(*(uint *)(param_1 + 4) & 0x7f);
  if (*(char *)(iVar3 + 0x59b) != '\0') {
    cVar1 = FUN_00547f20(uVar2,param_1);
    if (cVar1 == '\0') {
      FUN_0052e270(uVar2,param_1);
    }
  }
  return;
}


