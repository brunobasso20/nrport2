/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055b410 */

void FUN_0055b410(int param_1)

{
  undefined4 uVar1;
  int iVar2;
  
  uVar1 = FUN_0055ab00();
  iVar2 = FUN_00562f70(uVar1);
  if (iVar2 != param_1) {
    iVar2 = FUN_00501a20(0x10);
    if (iVar2 != 0) {
      FUN_005a2720(iVar2,param_1);
    }
  }
  return;
}


