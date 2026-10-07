/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00549c00 */

void FUN_00549c00(undefined4 param_1)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = FUN_00562f70(param_1);
  if ((iVar1 != 0) && (*(int *)(iVar1 + 0x148b) == 0)) {
    taskGetRate();
    uVar2 = FUN_006c5018();
    *(undefined4 *)(iVar1 + 0x148b) = uVar2;
  }
  return;
}


