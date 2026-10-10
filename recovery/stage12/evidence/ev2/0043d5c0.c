/* NR2003.exe @ 0043d5c0 FUN_0043d5c0 */

void __fastcall FUN_0043d5c0(int param_1)

{
  int iVar1;
  int *piVar2;
  undefined4 uVar3;
  undefined local_18 [8];
  undefined auStack_10 [16];
  
  uVar3 = FUN_0043f100();
  iVar1 = *(int *)(param_1 + 0x35);
  if (iVar1 != 0) {
    FUN_006c4f81(local_18,&DAT_0072726c,uVar3);
    FUN_005f99e0(&DAT_00f72794,0x2915,auStack_10,0x10,local_18);
    piVar2 = **(int ***)(iVar1 + 0x1ae);
    if (piVar2 != (int *)0x0) {
      (**(code **)(*piVar2 + 0x6c))(auStack_10);
    }
  }
  (**(code **)(**(int **)(param_1 + 0x39) + 0x2c))(uVar3);
  return;
}

