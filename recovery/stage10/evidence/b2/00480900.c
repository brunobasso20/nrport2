/* NR2003.exe @ 00480900 FUN_00480900 */

void __fastcall FUN_00480900(int param_1)

{
  int iVar1;
  
  *(undefined4 *)(param_1 + 0xb8) = 1;
  if (*(int **)(param_1 + 0x58) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x58) + 0x4c))();
  }
  if (*(int **)(param_1 + 0x54) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x54) + 0x4c))();
  }
  if (*(int **)(param_1 + 0x50) != (int *)0x0) {
    (**(code **)(**(int **)(param_1 + 0x50) + 0x50))();
  }
  iVar1 = FUN_00557ee0(0x65);
  if (iVar1 < 1) {
    FUN_004808c0(s_1stTransRatio_00739a08);
    FUN_004808c0(s_1stFinalDrive_00739a18);
  }
  if (iVar1 < 2) {
    FUN_004808c0(s_2ndTransRatio_00739a28);
    FUN_004808c0(s_2ndFinalDrive_00739a38);
  }
  if (iVar1 < 3) {
    FUN_004808c0(s_3rdTransRatio_00739a48);
    FUN_004808c0(s_3rdFinalDrive_00739a58);
  }
  if (iVar1 < 4) {
    FUN_004808c0(s_4thTransRatio_00739a68);
    FUN_004808c0(s_4thFinalDrive_00739a78);
  }
  if (iVar1 < 5) {
    FUN_004808c0(s_5thTransRatio_00739a88);
    FUN_004808c0(s_5thFinalDrive_00739a98);
  }
  if (iVar1 < 6) {
    FUN_004808c0(s_6thTransRatio_00739aa8);
    FUN_004808c0(s_6thFinalDrive_00739ab8);
  }
  return;
}

