/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00528570 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00528570(int param_1)

{
  FUN_005269e0(param_1);
  if (_DAT_006e97d8 <= *(float *)(param_1 + 0x1b5c)) {
    FUN_0052bec0(4);
    if (*(int *)(param_1 + 0x13b7) == 0) {
      *(undefined4 ***)(param_1 + 0x1b91) = &DAT_00bd797c;
      *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd797c;
      *(undefined4 ***)(param_1 + 0x13b3) = &DAT_00bd797c;
      (*(code *)*DAT_00bd797c)(param_1);
      *(undefined1 *)(param_1 + 0x16b9) = 1;
      return;
    }
    *(undefined1 *)(param_1 + 0x16b9) = 1;
    *(undefined4 ***)(param_1 + 0x13b7) = &DAT_00bd797c;
    *(undefined1 *)(param_1 + 0x16b9) = 1;
  }
  return;
}


