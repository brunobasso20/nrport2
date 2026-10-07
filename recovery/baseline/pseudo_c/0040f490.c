/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040f490 */

void __fastcall FUN_0040f490(int param_1)

{
  if ((*(char *)(param_1 + 0xf7) != '\0') && (*(char *)(param_1 + 0xb42) != '\0')) {
    FUN_00520030(4,0);
    FUN_00520030(4,0);
    *(char *)(param_1 + 0xb43) = *(char *)(param_1 + 0xb43) + '\x01';
  }
  return;
}


