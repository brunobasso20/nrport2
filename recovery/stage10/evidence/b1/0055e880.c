/* NR2003.exe @ 0055e880 FUN_0055e880 */

void FUN_0055e880(void)

{
  int iVar1;
  
  iVar1 = 0;
  do {
    FUN_0055e490(*(undefined4 *)((int)&PTR_DAT_0074e27c + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0a0 + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0b0 + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0c0 + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0d0 + iVar1));
    FUN_0055e510(*(undefined4 *)((int)&PTR_DAT_0074e72c + iVar1),
                 *(undefined4 *)((int)&DAT_006f5cc0 + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0e0 + iVar1),
                 *(undefined4 *)((int)&DAT_00c086c0 + iVar1),
                 *(undefined4 *)((int)&DAT_0074e0f0 + iVar1),
                 *(undefined4 *)((int)&DAT_00c086d0 + iVar1));
    iVar1 = iVar1 + 4;
  } while (iVar1 < 0x10);
  return;
}

