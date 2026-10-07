/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00567dc0 */

undefined4 FUN_00567dc0(void)

{
  bool bVar1;
  undefined4 local_4;
  
  bVar1 = inBackground();
  if (bVar1) {
    bgRequestFGAction(FUN_00568580,&local_4,(void *)0x0);
    return local_4;
  }
  FUN_00568580(&local_4);
  return local_4;
}


