/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00449a80 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00449a80(int param_1_00,int param_1,undefined8 param_3)

{
  bool bVar1;
  char cVar2;
  int iVar3;
  float10 fVar4;
  
  cVar2 = FUN_00449650(param_1);
  if ((((cVar2 != '\0') || (param_1 == DAT_0089e3d4)) || (iVar3 = FUN_00562f70(param_1), iVar3 == 0)
      ) || (iVar3 = FUN_00562f70(param_1), *(char *)(iVar3 + 0x59a) == '\0')) {
    param_1_00 = param_1_00 + param_1 * 0x25;
    *(undefined1 *)(param_1_00 + 0x3d) = 0;
    *(undefined1 *)(param_1_00 + 0x3a) = 0;
    *(undefined4 *)(param_1_00 + 0x21) = 0;
    *(undefined4 *)(param_1_00 + 0x25) = 0;
    return;
  }
  iVar3 = param_1_00 + param_1 + param_1 * 0x24;
  if (*(char *)(param_1_00 + param_1 + 0x3d + param_1 * 0x24) == '\0') {
    *(undefined1 *)(iVar3 + 0x3d) = 1;
    fVar4 = (float10)thunk_FUN_0055a760();
    *(double *)(iVar3 + 0x31) = (double)(fVar4 + (float10)_DAT_006e9808);
    return;
  }
  fVar4 = (float10)thunk_FUN_0055a760();
  if (fVar4 <= (float10)*(double *)(iVar3 + 0x31)) {
    return;
  }
  bVar1 = _DAT_006ed098 <= *(double *)(iVar3 + 0x21);
  *(undefined1 *)(iVar3 + 0x3a) = 1;
  if (bVar1) {
    return;
  }
  *(undefined8 *)(iVar3 + 0x21) = param_3;
  *(undefined8 *)(iVar3 + 0x29) = param_3;
  return;
}


