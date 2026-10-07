/* Ghidra pseudo-C; NR2003.exe @ 005b7960 */

undefined4 FUN_005b7960(int param_1)

{
  if ((&DAT_00eab624)[param_1 * 9] != '\0') {
    return *(undefined4 *)(&DAT_00eab629 + param_1 * 9);
  }
  return 0;
}

