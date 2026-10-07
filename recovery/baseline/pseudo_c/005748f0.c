/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005748f0 */

void FUN_005748f0(int param_1)

{
  int iVar1;
  char cVar2;
  int iVar3;
  
  iVar1 = param_1 * 0xce;
  cVar2 = FUN_00574760();
  if (cVar2 == '\0') {
    iVar3 = FUN_00562f70(param_1);
  }
  else {
    iVar3 = FUN_005aa360();
  }
  FUN_00428a20((int)&DAT_00c727e6 + iVar1,&DAT_00c727ea + iVar1,&DAT_00c727ee + iVar1,
               &DAT_00c727f6 + iVar1,&DAT_00c72737 + iVar1,iVar3 + 0x58e);
  return;
}


