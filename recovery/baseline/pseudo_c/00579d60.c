/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00579d60 */

undefined4 FUN_00579d60(int param_1)

{
  if (param_1 < 0x801) {
    switch(param_1) {
    case 1:
      return 1;
    case 2:
    case 9:
switchD_00579d72_caseD_2:
      return 2;
    case 3:
      return 4;
    case 4:
      return 5;
    case 5:
      return 6;
    case 6:
      return 7;
    case 7:
      return 8;
    case 8:
      return 9;
    case 0xc:
      return 3;
    }
  }
  else {
    switch(param_1) {
    case 0x801:
    case 0x809:
      goto switchD_00579d72_caseD_2;
    case 0x802:
    case 0x80b:
      return 10;
    case 0x803:
      return 0xb;
    case 0x804:
      return 0xc;
    case 0x805:
    case 0x80a:
      return 0xd;
    case 0x806:
      return 0xe;
    case 0x807:
      return 0xf;
    case 0x808:
      return 0x10;
    }
  }
  return 0;
}


