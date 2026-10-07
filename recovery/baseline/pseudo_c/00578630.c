/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578630 */

void __fastcall FUN_00578630(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int *piVar4;
  
  if (*(int *)(param_1 + 0x6c18) != 0) {
    *(undefined4 *)(param_1 + 0x6c18) = 0;
  }
  if (*(int *)(param_1 + 4) != 0) {
    *(undefined4 *)(param_1 + 4) = 0;
  }
  iVar2 = *(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44);
  iVar1 = param_1 + *(int *)(param_1 + 0x6c14) * 0x2c44;
  for (piVar4 = (int *)(iVar1 + 0x1390); piVar4 != (int *)(iVar1 + 0x1390 + iVar2 * 4);
      piVar4 = piVar4 + 1) {
    iVar3 = *piVar4;
    if (iVar3 != 0) {
      FUN_00577ee0();
      FUN_00578550(iVar3);
    }
  }
  if (*(int *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) != 0) {
    *(undefined4 *)(param_1 + 0x138c + *(int *)(param_1 + 0x6c14) * 0x2c44) = 0;
  }
  iVar1 = *(int *)(param_1 + 0x9930);
  while (iVar1 != 0) {
    iVar2 = *(int *)(iVar1 + 0x50);
    **(int **)(iVar1 + 0x54) = iVar2;
    if (*(int *)(iVar1 + 0x50) != 0) {
      *(undefined4 *)(*(int *)(iVar1 + 0x50) + 0x54) = *(undefined4 *)(iVar1 + 0x54);
    }
    *(undefined4 *)(iVar1 + 0x50) = 0;
    *(undefined4 *)(iVar1 + 0x54) = 0;
    iVar1 = iVar2;
  }
  return;
}


