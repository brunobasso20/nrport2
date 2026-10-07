/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00578e80 */

void __thiscall FUN_00578e80(int param_1_00,undefined4 param_1,int param_2,int param_3)

{
  int iVar1;
  int iVar2;
  int *piVar3;
  
  *(undefined4 *)(param_1_00 + 0x9938) = param_1;
  piVar3 = (int *)(param_1_00 + 0x9940);
  *(int *)(param_1_00 + 0x993c) = param_2;
  *(undefined1 *)(param_2 + 0x5a) = 1;
  iVar2 = 0;
  do {
    iVar1 = *(int *)(param_3 + iVar2 * 4);
    iVar2 = iVar2 + 1;
    *piVar3 = iVar1;
    piVar3 = piVar3 + 1;
    *(undefined1 *)(iVar1 + 0x5a) = 1;
  } while (iVar2 < 5);
  return;
}


