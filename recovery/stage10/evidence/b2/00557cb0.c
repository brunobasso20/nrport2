/* NR2003.exe @ 00557cb0 FUN_00557cb0 */

int __fastcall FUN_00557cb0(int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  
  *(undefined4 *)(param_1 + 0xef1) = 0;
  *(undefined4 *)(param_1 + 0xef5) = 0;
  *(undefined4 *)(param_1 + 0xef9) = 0;
  puVar2 = (undefined4 *)(param_1 + 0x6f1);
  for (iVar1 = 0x200; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  puVar2 = (undefined4 *)(param_1 + 0x4f1);
  for (iVar1 = 0x40; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  puVar2 = (undefined4 *)(param_1 + 0x5f1);
  for (iVar1 = 0x40; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  if (DAT_00c064c4 == '\0') {
    FUN_004233f0();
    DAT_00c064c4 = '\x01';
  }
  FUN_00557d20();
  FUN_00424490(param_1);
  return param_1;
}

