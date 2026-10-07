/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056ed60 */

undefined4 __thiscall FUN_0056ed60(int param_1_00,int param_1)

{
  if (DAT_00bddde0 < 0) {
    switch(param_1) {
    case 0:
      goto switchD_0056ed72_caseD_0;
    case 1:
      return *(undefined4 *)(param_1_00 + 0x4c);
    case 2:
switchD_0056ed72_caseD_2:
      return *(undefined4 *)(param_1_00 + 0x58);
    case 3:
      return *(undefined4 *)(param_1_00 + 0x54);
    default:
      goto switchD_0056ed72_caseD_4;
    }
  }
  if (DAT_00bddde0 == 0) {
    if (param_1 == 0) {
switchD_0056ed72_caseD_0:
      param_1 = 1;
    }
    else if (param_1 == 2) goto switchD_0056ed72_caseD_2;
  }
switchD_0056ed72_caseD_4:
  return *(undefined4 *)(param_1_00 + 0x4c + param_1 * 4);
}


