/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0053e010 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0053e010(int param_1)

{
  undefined4 *puVar1;
  int iVar2;
  float10 fVar3;
  
  iVar2 = FUN_00538b30();
  puVar1 = (undefined4 *)(iVar2 + 0x113 + *(int *)(param_1 + 0x24) * 0xc);
  if ((*(int *)(iVar2 + 0x117 + *(int *)(param_1 + 0x24) * 0xc) != 0) || (puVar1[2] != -0x40100000))
  {
    fVar3 = (float10)(**(code **)*puVar1)();
    if (fVar3 <= (float10)*(double *)(puVar1 + 1)) {
      fVar3 = (float10)(**(code **)*puVar1)();
      if ((float10)_DAT_006e9808 < (float10)*(double *)(puVar1 + 1) - fVar3) {
        *(ushort *)(param_1 + 0x2c) = *(ushort *)(param_1 + 0x2c) & 0xfffb | 0x10;
        return;
      }
    }
  }
  iVar2 = FUN_00538b30();
  puVar1 = (undefined4 *)(iVar2 + 0x113 + *(int *)(param_1 + 0x24) * 0xc);
  if ((*(int *)(iVar2 + 0x117 + *(int *)(param_1 + 0x24) * 0xc) == 0) && (puVar1[2] == -0x40100000))
  {
LAB_0053e0d8:
    *(byte *)(param_1 + 0x2c) = *(byte *)(param_1 + 0x2c) & 0xeb;
    return;
  }
  fVar3 = (float10)(**(code **)*puVar1)();
  if (fVar3 <= (float10)*(double *)(puVar1 + 1)) {
    fVar3 = (float10)(**(code **)*puVar1)();
    if ((float10)*(double *)(puVar1 + 1) - fVar3 == (float10)_DAT_006ea4b8) goto LAB_0053e0d8;
  }
  *(ushort *)(param_1 + 0x2c) = *(ushort *)(param_1 + 0x2c) & 0xffef | 4;
  return;
}


