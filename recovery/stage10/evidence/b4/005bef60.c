/* NR2003.exe @ 005bef60 FUN_005bef60 */

int FUN_005bef60(void)

{
  int iVar1;
  int local_4;
  
  iVar1 = FUN_005cfce4(&local_4,0x221d);
  if ((iVar1 != 0) && (local_4 != 0)) {
    iVar1 = FUN_005befe0();
    if (iVar1 != 0) {
      *(int *)(iVar1 + 4) = *(int *)(iVar1 + 4) + 1;
    }
    return iVar1;
  }
  return 0;
}

