/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f9230 */

void __fastcall FUN_005f9230(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  
  iVar1 = param_1 + 0x60;
  (*DAT_0103b4d4)(iVar1);
  iVar2 = *(int *)(param_1 + 0x5c);
  if (*(char *)(param_1 + 0x81) != '\0') {
    *(int *)(param_1 + 0x78) = *(int *)(param_1 + 0x78) + -1;
    iVar3 = (iVar2 + 1) % 3;
    if (*(char *)(param_1 + 0x80) != '\0') {
      (*(code *)PTR_LOOP_0105831c)(param_1 + 8 + iVar2 * 0x18);
      *(int *)(param_1 + 0x50 + iVar2 * 4) = *(int *)(param_1 + 0x50 + iVar2 * 4) + -1;
    }
    *(int *)(param_1 + 0x50 + iVar3 * 4) = *(int *)(param_1 + 0x50 + iVar3 * 4) + 1;
    *(int *)(param_1 + 0x5c) = iVar3;
    (*DAT_0103b4dc)(iVar1);
    *(undefined1 *)(param_1 + 0x80) = 1;
    (*(code *)PTR_LOOP_01058320)(param_1 + 8 + iVar3 * 0x18);
    return;
  }
  (*DAT_0103b4d0)(iVar1);
  return;
}


