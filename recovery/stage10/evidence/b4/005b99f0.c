/* NR2003.exe @ 005b99f0 thunk_FUN_005bce40 */

void thunk_FUN_005bce40(undefined4 param_1,int param_2,int param_3,int param_4)

{
  undefined4 uVar1;
  int iVar2;
  
  switch(param_1) {
  case 0:
  case 1:
  case 2:
  case 3:
    FUN_005bd2c0();
    return;
  case 4:
    FUN_005bd270(param_2 + -0xebbf60 >> 2,param_3 + -0xebbf60 >> 2);
    return;
  case 5:
  case 6:
  case 7:
  case 8:
  case 9:
  case 10:
  case 0xb:
    FUN_005bd290(param_1,param_2 + -0xebbf60 >> 2,param_3 + -0xebbf60 >> 2);
    break;
  case 0xc:
    uVar1 = FUN_005bcd70();
    uVar1 = FUN_005bd050(uVar1);
    FUN_005bd160(param_2 + -0xebbf60 >> 2,uVar1);
    DAT_00ee0fdc = FUN_005bd100(0xc,uVar1,DAT_00ee0fdc);
    return;
  case 0xd:
    uVar1 = FUN_005bd250(param_2 + -0xebbf60 >> 2,DAT_00ee0fdc);
    DAT_00ee0fdc = FUN_005bd100(0xd,uVar1);
    return;
  case 0xe:
    iVar2 = FUN_005bd100(0xe,0,DAT_00ee0fdc);
    *(int *)(iVar2 + 4) = param_2;
    DAT_00ee0fdc = 0;
    return;
  case 0xf:
    FUN_005bd300(param_2 + -0xebbf60 >> 2,param_3,param_4 + -0xebbf60 >> 2);
    return;
  case 0x10:
    FUN_005bcff0();
    FUN_005bd330();
    return;
  case 0x11:
    FUN_005bd3c0();
    FUN_005bd380();
    return;
  }
  return;
}

