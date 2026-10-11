/* NR2003.exe @ 005486a0 FUN_005486a0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 FUN_005486a0(int param_1,int param_2)

{
  uint uVar1;
  uint uVar2;
  
  if ((&DAT_006f56c0)[param_2 * 0x15] == '\0') {
    return (float10)(ulonglong)
                    (*(uint *)(param_1 + 8) >>
                     ((byte)*(undefined4 *)(&DAT_006f56b8 + param_2 * 0x15) & 0x1f) &
                    *(uint *)(&DAT_006f56bc + param_2 * 0x15)) /
           (float10)*(uint *)(&DAT_006f56bc + param_2 * 0x15);
  }
  uVar1 = *(uint *)(&DAT_006f56bc + param_2 * 0x15);
  uVar2 = *(uint *)(param_1 + 8) >> ((byte)*(undefined4 *)(&DAT_006f56b8 + param_2 * 0x15) & 0x1f) &
          uVar1;
  if (uVar2 == uVar1) {
    return (float10)_DAT_006ea4a0;
  }
  return (float10)(ulonglong)uVar2 / (float10)(uVar1 - 1);
}

