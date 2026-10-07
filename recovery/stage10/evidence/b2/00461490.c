/* NR2003.exe @ 00461490 FUN_00461490 */

void __fastcall FUN_00461490(int *param_1)

{
  int iVar1;
  int *piVar2;
  bool bVar3;
  char cVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined uVar7;
  undefined4 uVar8;
  
  uVar5 = DAT_008b3091;
  uVar8 = DAT_008b308d;
  cVar4 = DAT_008b3088;
  if (*(char *)((int)param_1 + 0x327) == '\0') {
    if ((DAT_008b3088 != '\0') && (*(char *)(param_1 + 0xca) == '\0')) {
      (**(code **)(*param_1 + 0x1c))();
      FUN_00462dd0();
    }
    *(char *)(param_1 + 0xca) = cVar4;
  }
  else if (*(char *)((int)param_1 + 0x329) == '\0') {
    *(undefined4 *)((int)param_1 + 9) = DAT_008b3089;
    uVar6 = DAT_008b3095;
    *(undefined4 *)((int)param_1 + 0xd) = uVar8;
    uVar8 = DAT_008b3099;
    *(undefined4 *)((int)param_1 + 0x11) = uVar5;
    uVar5 = DAT_008b309d;
    *(undefined4 *)((int)param_1 + 0x15) = uVar6;
    uVar6 = DAT_008b30a1;
    *(undefined4 *)((int)param_1 + 0x19) = uVar8;
    uVar8 = DAT_008b30a5;
    *(undefined4 *)((int)param_1 + 0x1d) = uVar5;
    uVar5 = DAT_008b30a9;
    *(undefined4 *)((int)param_1 + 0x21) = uVar6;
    uVar7 = DAT_008b30ad;
    *(undefined4 *)((int)param_1 + 0x25) = uVar8;
    cVar4 = DAT_008b3088;
    *(undefined4 *)((int)param_1 + 0x29) = uVar5;
    *(undefined *)((int)param_1 + 0x2d) = uVar7;
    *(char *)(param_1 + 0xca) = cVar4;
    *(undefined *)((int)param_1 + 0x327) = 0;
  }
  else {
    *(undefined *)((int)param_1 + 0x329) = 0;
  }
  if ((((DAT_008b30af == 7) || (DAT_008b30af == 4)) || (DAT_008b30af == 2)) &&
     (DAT_008b33a6 == '\0')) {
    bVar3 = true;
  }
  else {
    bVar3 = false;
  }
  iVar1 = *(int *)((int)param_1 + 0x32a);
  if (iVar1 != 0) {
    uVar8 = FUN_00557ee0(0x3b);
    FUN_006c5990(&DAT_008b4ef8,u__d___00734c50,uVar8);
    piVar2 = **(int ***)(iVar1 + 0x1ae);
    if (piVar2 != (int *)0x0) {
      (**(code **)(*piVar2 + 0x68))(&DAT_008b4ef8);
    }
  }
  iVar1 = *(int *)((int)param_1 + 0x32e);
  if (iVar1 != 0) {
    FUN_006c5990(&DAT_008b4ef8,u__d___00734c5c,DAT_008b30a9);
    piVar2 = **(int ***)(iVar1 + 0x1ae);
    if (piVar2 != (int *)0x0) {
      (**(code **)(*piVar2 + 0x68))(&DAT_008b4ef8);
    }
    if (!bVar3) {
      FUN_00613d80();
      return;
    }
    FUN_00613d40();
    return;
  }
  return;
}

