/* NR2003.exe @ 005bd210 FUN_005bd210 */

void FUN_005bd210(int param_1,int param_2)

{
  int iVar1;
  undefined4 *puVar2;
  
  puVar2 = (undefined4 *)(param_2 + 0x10);
  iVar1 = *(int *)(param_2 + 0x10);
  if (iVar1 != 0) {
    while (iVar1 != param_1) {
      puVar2 = &DAT_00edb538 + iVar1;
      iVar1 = (&DAT_00edb538)[iVar1];
      if (iVar1 == 0) {
        return;
      }
    }
    *puVar2 = (&DAT_00edb538)[param_1];
  }
  return;
}

