/* NR2003.exe @ 0050d6d0 FUN_0050d6d0 */

void FUN_0050d6d0(void)

{
  int iVar1;
  
  iVar1 = FUN_0055a610();
  if (*(int *)(iVar1 + 0xc) == 0) {
    iVar1 = -1;
  }
  else {
    iVar1 = *(int *)(*(int *)(iVar1 + 0xc) + 0x5b2);
  }
  if (-1 < iVar1) {
    iVar1 = FUN_004f5970(iVar1);
    if ((iVar1 != 0) && (*(int *)(iVar1 + 0x5ae) != 0)) {
      FUN_0050d3b0(iVar1,*(undefined4 *)(*(int *)(iVar1 + 0x5ae) + 0x3c));
    }
  }
  return;
}

