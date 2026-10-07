/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00551800 */

void FUN_00551800(void)

{
  bool bVar1;
  int *piVar2;
  int iVar3;
  
  bVar1 = inBackground();
  if ((bVar1) && (DAT_00bf6e04 != '\0')) {
    piVar2 = (int *)FUN_00538b20();
    (**(code **)(*piVar2 + 0x30))();
  }
  DAT_00bf6e04 = 0;
  iVar3 = FUN_0055ab00();
  FUN_0059fa90();
  (&DAT_00c08a18)[iVar3 * 0xcb] = iVar3;
  iVar3 = FUN_0055ab00();
  FUN_0059fa90();
  (&DAT_00b33090)[iVar3 * 0xcb] = iVar3;
  return;
}


