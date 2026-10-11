/* NR2003.exe @ 0043d830 FUN_0043d830 */

void __fastcall FUN_0043d830(int param_1)

{
  int iVar1;
  int *piVar2;
  undefined4 uVar3;
  undefined local_18 [8];
  undefined auStack_10 [16];
  
  uVar3 = FUN_0043f090();
  uVar3 = FUN_0043d9b0(uVar3);
  iVar1 = *(int *)(param_1 + 0x65);
  if (iVar1 != 0) {
    FUN_006c4f81(local_18,&DAT_00727278,uVar3);
    FUN_005f99e0(&DAT_00f72794,0x2915,auStack_10,0x10,local_18);
    piVar2 = **(int ***)(iVar1 + 0x1ae);
    if (piVar2 != (int *)0x0) {
      (**(code **)(*piVar2 + 0x6c))(auStack_10);
    }
  }
  (**(code **)(**(int **)(param_1 + 0x69) + 0x2c))(uVar3);
  return;
}

