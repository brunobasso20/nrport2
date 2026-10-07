/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005746c0 */

void FUN_005746c0(int param_1)

{
  int iVar1;
  char cVar2;
  int iVar3;
  undefined4 uVar4;
  
  iVar1 = param_1 * 0xce;
  if ((&DAT_00c72732)[param_1 * 0xce] != '\0') {
    if (*(int **)((int)&DAT_00c727e6 + iVar1) != (int *)0x0) {
      (**(code **)(**(int **)((int)&DAT_00c727e6 + iVar1) + 4))();
      *(undefined4 *)((int)&DAT_00c727e6 + iVar1) = 0;
    }
    if (*(int **)(&DAT_00c727ea + iVar1) != (int *)0x0) {
      (**(code **)(**(int **)(&DAT_00c727ea + iVar1) + 4))();
      *(undefined4 *)(&DAT_00c727ea + iVar1) = 0;
    }
    cVar2 = FUN_00574760();
    if (cVar2 == '\0') {
      iVar3 = FUN_00562f70(param_1);
    }
    else {
      iVar3 = FUN_005aa360();
    }
    uVar4 = FUN_004289b0(&DAT_00c72737 + iVar1,iVar3 + 0x58e);
    *(undefined4 *)((int)&DAT_00c727e6 + iVar1) = uVar4;
    uVar4 = FUN_004289e0(&DAT_00c72737 + iVar1,iVar3 + 0x58e);
    *(undefined4 *)(&DAT_00c727ea + iVar1) = uVar4;
    (&DAT_00c72732)[iVar1] = 0;
  }
  return;
}


