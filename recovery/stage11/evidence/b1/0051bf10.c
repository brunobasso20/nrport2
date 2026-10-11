/* NR2003.exe @ 0051bf10 FUN_0051bf10 */

void __fastcall FUN_0051bf10(int param_1)

{
  char cVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  
  iVar3 = *(int *)(*(int *)(param_1 + 0x56e) + 0x5ae);
  if ((iVar3 != 0) && ((iVar3 = *(int *)(iVar3 + 0x50), iVar3 == 2 || (iVar3 == 4)))) {
    *(undefined *)(param_1 + 0x565) = 1;
  }
  uVar5 = *(undefined4 *)(*(int *)(param_1 + 0x56e) + 0x5b2);
  piVar2 = (int *)FUN_00538b00();
  (**(code **)(*piVar2 + 0x30))(uVar5);
  iVar3 = FUN_005443c0(uVar5);
  if (*(int *)(param_1 + 0x544) < iVar3) {
    *(int *)(param_1 + 0x544) = iVar3;
    piVar2 = (int *)FUN_00538b30();
    iVar4 = (**(code **)(*piVar2 + 0x34))();
    uVar5 = *(undefined4 *)(*(int *)(param_1 + 0x56e) + 0x5b2);
    piVar2 = (int *)FUN_00538b00();
    (**(code **)(*piVar2 + 0x30))(uVar5,iVar3);
    cVar1 = FUN_005438c0(uVar5,iVar3);
    if ((((iVar4 == 0) && (cVar1 == '\0')) && (*(char *)(param_1 + 0x564) != '\0')) &&
       (*(char *)(param_1 + 0x565) == '\0')) {
      uVar5 = 1;
    }
    else {
      uVar5 = 0;
    }
    FUN_0051be20(uVar5);
    *(bool *)(param_1 + 0x564) = iVar4 == 0;
    *(undefined *)(param_1 + 0x565) = 0;
  }
  return;
}

