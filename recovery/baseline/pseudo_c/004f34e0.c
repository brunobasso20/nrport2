/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f34e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_004f34e0(int param_1_00,int *param_1)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = *param_1;
  uVar2 = _DAT_006e97d8;
  if (*(char *)(iVar1 + 0x153) != '\0') {
    uVar2 = *(undefined4 *)(param_1_00 + 0xc);
  }
  *(undefined4 *)(iVar1 + 0x3c) = uVar2;
  *(float *)(iVar1 + 0x2c) =
       (float)(&DAT_00a57330)[*(int *)(iVar1 + 0x24)] * *(float *)(iVar1 + 0x3c) *
       *(float *)(iVar1 + 0x20);
  *(undefined4 *)(iVar1 + 0x40) = 0x3f800000;
  *(undefined4 *)(iVar1 + 0x44) = 0;
  return;
}


