/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b4de0 */

int __thiscall FUN_005b4de0(ushort *param_1_00,undefined4 param_1)

{
  char cVar1;
  
  if (*param_1_00 < 0x40) {
    cVar1 = FUN_005b4e60((uint)*param_1_00 * 0x23 + 2 + (int)param_1_00,param_1);
    if (cVar1 != '\0') {
      *(undefined4 *)((uint)*param_1_00 * 0x23 + 0x21 + (int)param_1_00) = DAT_00eab1cc;
      *param_1_00 = *param_1_00 + 1;
      return (uint)*param_1_00 * 0x23 + -0x21 + (int)param_1_00;
    }
  }
  return 0;
}


