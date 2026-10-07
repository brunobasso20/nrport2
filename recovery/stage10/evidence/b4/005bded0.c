/* NR2003.exe @ 005bded0 FUN_005bded0 */

void FUN_005bded0(undefined4 param_1,int param_2,int param_3,int param_4)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  
  switch(param_1) {
  case 0:
  case 1:
  case 2:
  case 3:
    break;
  default:
    return;
  case 5:
  case 6:
  case 7:
  case 8:
  case 9:
  case 10:
  case 0xb:
    FUN_005be360(param_1,param_2,param_4);
    return;
  case 0xf:
    FUN_005be520(param_2,param_3,param_4);
    return;
  }
  if (param_2 == param_3) {
    FUN_005be570(param_2,param_4);
    FUN_005be280(param_1);
    return;
  }
  iVar1 = FUN_005bd200(param_2);
  if (iVar1 == 0) {
    iVar1 = FUN_005bd200(param_3);
    if (iVar1 != 0) {
      uVar3 = FUN_005bd670(param_3,param_4);
      uVar2 = FUN_005be140(param_3);
      FUN_005be130(uVar2);
      FUN_005be570(param_2,param_4);
      uVar4 = FUN_005bdc60(param_3);
      FUN_005be170(param_1,uVar4);
      FUN_005bd5e0(uVar2);
      FUN_005bd5e0(uVar3);
      return;
    }
    iVar1 = FUN_005bdc20(param_2);
    if (iVar1 != 0) {
      uVar3 = FUN_005bd670(param_2,param_4);
      uVar2 = FUN_005be140(param_2);
      FUN_005be130(uVar2);
      FUN_005be570(param_3,param_4);
      uVar4 = FUN_005bdc60(param_2);
      FUN_005be250(param_1,uVar4);
      FUN_005bd5e0(uVar2);
      FUN_005bd5e0(uVar3);
      return;
    }
    iVar1 = FUN_005bdc20(param_3);
    if (iVar1 == 0) {
      if (2 < param_4) {
        FUN_005be570(param_2,param_4);
        FUN_005be570(param_3,param_4 + -1);
        FUN_005be2f0(param_1);
        return;
      }
      uVar3 = FUN_005bcda0();
      FUN_005bd160(uVar3,param_3);
      FUN_005bd650(param_3,param_4);
      FUN_005be570(param_2,param_4);
      uVar2 = FUN_005bdc60(param_3);
      FUN_005be170(param_1,uVar2);
      FUN_005bd210(uVar3,param_3);
      (&DAT_00ed7840)[DAT_00ec3fb8] = 0;
      DAT_00ec3fb8 = DAT_00ec3fb8 + 1;
      return;
    }
    uVar2 = FUN_005bd670(param_3,param_4);
    uVar3 = FUN_005be140(param_3);
    FUN_005be130(uVar3);
    FUN_005be570(param_2,param_4);
    uVar4 = FUN_005bdc60(param_3);
    FUN_005be170(param_1,uVar4);
    param_4 = uVar2;
  }
  else {
    uVar2 = FUN_005bd670(param_2,param_4);
    uVar3 = FUN_005be140(param_2);
    FUN_005be130(uVar3);
    FUN_005be570(param_3,param_4);
    uVar4 = FUN_005bdc60(param_2);
    FUN_005be250(param_1,uVar4);
    param_4 = uVar2;
  }
  FUN_005bd5e0(uVar3);
  FUN_005bd5e0(param_4);
  return;
}

