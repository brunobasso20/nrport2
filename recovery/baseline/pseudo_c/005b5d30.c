/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b5d30 */

undefined4 FUN_005b5d30(undefined4 param_1,undefined1 param_2,uint param_3)

{
  int iVar1;
  undefined4 uVar2;
  
  switch(param_2) {
  case 0:
  case 1:
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
  case 7:
  case 8:
  case 9:
  case 10:
  case 0xb:
  case 0xc:
  case 0xd:
  case 0xe:
  case 0xd0:
    FUN_005c3ad0(param_1);
    return 0;
  default:
    FUN_005c3ad0(param_1);
    return 0;
  case 0x40:
  case 0x43:
  case 0x80:
  case 0x87:
  case 0xc1:
  case 0xc4:
  case 199:
  case 0xd1:
    FUN_005c3ab0(param_1,&DAT_00c077d8);
    return 1;
  case 0x41:
  case 0x81:
  case 0x83:
  case 0x89:
  case 0xc2:
  case 0xc5:
    FUN_005c3ab0(param_1,&DAT_00c077d8);
    return 1;
  case 0x42:
  case 0x45:
  case 0x86:
  case 0xc0:
  case 0xc3:
  case 0xc6:
  case 0xc9:
  case 0xca:
  case 0xcb:
    goto switchD_005b5d50_caseD_42;
  case 0x44:
    iVar1 = FUN_00538b20();
    FUN_005c3ab0(param_1,iVar1 + 0x24);
    return 1;
  case 0x82:
    if (0x804 < param_3) goto LAB_005b5dc8;
switchD_005b5d50_caseD_42:
    FUN_005c3ab0(param_1,&DAT_00c077d8);
    return 1;
  case 0x84:
    if (param_3 < 0xdb) {
      FUN_005c3ab0(param_1,&DAT_00c070f8);
      return 1;
    }
LAB_005b5dc8:
    FUN_005c3ad0(param_1);
    return 1;
  case 0x85:
    if (param_3 < 0x1b) {
      FUN_00538b20();
      uVar2 = FUN_00540310();
      FUN_005c3ab0(param_1,uVar2);
      return 1;
    }
    FUN_005c3ad0(param_1);
    return 1;
  case 0x88:
    if (param_3 < 0x4b1) {
      FUN_00538b20();
      uVar2 = FUN_005404a0();
      FUN_005c3ab0(param_1,uVar2);
      param_3 = param_3 / 0xc;
      FUN_00538b20(param_3);
      FUN_00540530(param_3);
      return 1;
    }
    FUN_005c3ad0(param_1);
    return 1;
  case 200:
  case 0xd3:
    FUN_005c3ab0(param_1,0);
    return 1;
  }
}


