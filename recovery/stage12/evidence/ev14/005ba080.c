/* NR2003.exe @ 005ba080 FUN_005ba080 */

undefined4 __fastcall FUN_005ba080(int param_1)

{
  if (DAT_00ebbd84 != '\0') {
    if ((DAT_00ebbd04 + -1 == *(int *)(param_1 + (2 - DAT_00ebbd78) * 4)) &&
       (DAT_00ebbd04 == *(int *)(param_1 + 4 + DAT_00ebbd78 * 4))) {
      return 1;
    }
  }
  return 0;
}

