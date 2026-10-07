/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b78c0 */

undefined4 FUN_005b78c0(int param_1)

{
  uint uVar1;
  undefined1 *puVar2;
  
  uVar1 = FUN_005b7c00();
  if (3 < uVar1) {
    uVar1 = 0;
    do {
      puVar2 = (undefined1 *)FUN_005b7bb0(uVar1);
      *(undefined1 *)(uVar1 + param_1) = *puVar2;
      uVar1 = uVar1 + 1;
    } while (uVar1 < 4);
    return 1;
  }
  return 0;
}


