/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00598100 */

void FUN_00598100(undefined4 param_1)

{
  int *piVar1;
  
  switch(param_1) {
  case 1:
  case 2:
  case 3:
    if (DAT_00d95654 != (undefined4 *)0x0) {
      (**(code **)*DAT_00d95654)(0);
    }
    piVar1 = &DAT_00d954b0;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd954b8);
    piVar1 = &DAT_00d95504;
    break;
  case 4:
  case 5:
  case 6:
    if (DAT_00d95654 != (undefined4 *)0x0) {
      (**(code **)*DAT_00d95654)(0x3f800000);
    }
    piVar1 = &DAT_00d954b0;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0x3f800000);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd954b8);
    piVar1 = &DAT_00d95504;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0x3f800000);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd9550c);
    return;
  case 7:
    if (DAT_00d95654 != (undefined4 *)0x0) {
      (**(code **)*DAT_00d95654)(0x40000000);
    }
    piVar1 = &DAT_00d954b0;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0x40000000);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd954b8);
    piVar1 = &DAT_00d95504;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0x40000000);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd9550c);
    return;
  default:
    if (DAT_00d95654 != (undefined4 *)0x0) {
      (**(code **)*DAT_00d95654)(0);
    }
    piVar1 = &DAT_00d954b0;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd954b8);
    piVar1 = &DAT_00d95504;
    do {
      if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
        (*(code *)**(undefined4 **)*piVar1)(0);
      }
      piVar1 = piVar1 + 1;
    } while ((int)piVar1 < 0xd9550c);
    return;
  }
  do {
    if ((undefined4 *)*piVar1 != (undefined4 *)0x0) {
      (*(code *)**(undefined4 **)*piVar1)(0);
    }
    piVar1 = piVar1 + 1;
  } while ((int)piVar1 < 0xd9550c);
  return;
}


