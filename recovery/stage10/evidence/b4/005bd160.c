/* NR2003.exe @ 005bd160 FUN_005bd160 */

void FUN_005bd160(int param_1,int param_2)

{
  if ((&DAT_00ed7840)[param_1] != param_2) {
    FUN_005bd1a0(param_1,(&DAT_00ed7840)[param_1]);
    (&DAT_00edb538)[param_1] = *(undefined4 *)(param_2 + 0x10);
    *(int *)(param_2 + 0x10) = param_1;
    (&DAT_00ed7840)[param_1] = param_2;
  }
  return;
}

