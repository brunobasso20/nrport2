/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005729e0 */

void FUN_005729e0(void)

{
  int *piVar1;
  
  piVar1 = &DAT_00c71010;
  do {
    if ((int *)*piVar1 != (int *)0x0) {
      (**(code **)(*(int *)*piVar1 + 4))();
      *piVar1 = 0;
    }
    piVar1 = piVar1 + 0x41;
  } while ((int)piVar1 < 0xc72050);
  return;
}


