/* NR2003.exe @ 005ae660 FUN_005ae660 */

void FUN_005ae660(void)

{
  int iVar1;
  
  iVar1 = DAT_00e7d0bc;
  if (DAT_00e7d0c0 != DAT_00e7d0c4) {
    do {
      FUN_005ae6d0();
      iVar1 = DAT_00e7d0bc;
    } while (DAT_00e7d0c0 != DAT_00e7d0c4);
  }
  for (; iVar1 != 0; iVar1 = *(int *)(iVar1 + 100)) {
    (**(code **)(**(int **)(iVar1 + 0x5c) + 0x14))(iVar1 + 4);
    if (*(undefined4 **)(iVar1 + 0x60) == (undefined4 *)0x0) {
      *(undefined4 *)(iVar1 + 0x18) = 0;
      *(undefined4 *)(iVar1 + 0x14) = 0;
      *(undefined4 *)(iVar1 + 0x10) = 0;
    }
    else {
      (**(code **)**(undefined4 **)(iVar1 + 0x60))(iVar1 + 0x10);
    }
    FUN_004ed230();
  }
  return;
}

