/* NR2003.exe @ 0045f2b0 FUN_0045f2b0 */

undefined4 FUN_0045f2b0(undefined4 param_1)

{
  undefined4 uVar1;
  
  uVar1 = 10000;
  switch(param_1) {
  case 0:
    return 0x2714;
  case 1:
    return 0x3cd1;
  case 2:
    return 0x3ccd;
  case 3:
    return 0x3cce;
  case 4:
    return 0x3ccf;
  case 5:
    uVar1 = 0x3cd0;
    break;
  case 0xffffffff:
    return 0x2711;
  }
  return uVar1;
}

