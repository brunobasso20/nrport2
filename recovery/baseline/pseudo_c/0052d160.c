/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052d160 */

void FUN_0052d160(int param_1)

{
  if (*(int *)(param_1 + 0x5ae) != 0) {
    switch(*(undefined4 *)(*(int *)(param_1 + 0x5ae) + 0x50)) {
    case 1:
      *(undefined4 *)(param_1 + 0x16ba) = 0;
      FUN_0052bea0(1);
      FUN_0052bea0(3);
      return;
    case 2:
      *(undefined4 *)(param_1 + 0x16ba) = 0;
      FUN_0052bea0(3);
      FUN_0052bea0(5);
      FUN_0052bea0(2);
      return;
    case 3:
    case 5:
      *(undefined4 *)(param_1 + 0x16ba) = 0;
      FUN_0052bea0(1);
      FUN_0052bea0(3);
      FUN_0052bea0(5);
      FUN_0052bea0(2);
      return;
    case 4:
      *(undefined4 *)(param_1 + 0x16ba) = 0;
    }
  }
  return;
}


