/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005747b0 */

undefined4 FUN_005747b0(int param_1)

{
  int iVar1;
  char cVar2;
  int iVar3;
  undefined4 uVar4;
  
  iVar1 = param_1 * 0xce;
  if ((&DAT_00c72733)[param_1 * 0xce] != '\0') {
    if ((&DAT_00c72734)[iVar1] == '\0') {
      if (*(int **)(&DAT_00c727f2 + iVar1) != (int *)0x0) {
        (**(code **)(**(int **)(&DAT_00c727f2 + iVar1) + 4))();
      }
      cVar2 = FUN_00574760();
      if (cVar2 == '\0') {
        iVar3 = FUN_00562f70(param_1);
      }
      else {
        iVar3 = FUN_005aa360();
      }
      uVar4 = FUN_00428800(&DAT_00c72737 + iVar1,iVar3 + 0x58e);
      *(undefined4 *)(&DAT_00c727f2 + iVar1) = uVar4;
      (&DAT_00c72734)[iVar1] = 1;
    }
    return *(undefined4 *)(&DAT_00c727f2 + iVar1);
  }
  return *(undefined4 *)(&DAT_00c727ee + iVar1);
}


