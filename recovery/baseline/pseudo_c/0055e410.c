/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055e410 */

void FUN_0055e410(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00c084ac;
  do {
    FUN_005b7fe0(*piVar1 + 0x39d,&DAT_00c08238);
    piVar1 = piVar1 + 1;
  } while ((int)piVar1 < 0xc084bc);
  FUN_0057cc10(&LAB_0055e3e0);
  return;
}


