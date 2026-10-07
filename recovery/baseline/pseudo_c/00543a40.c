/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00543a40 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

float10 __thiscall FUN_00543a40(int param_1_00,int param_1,int param_2)

{
  char cVar1;
  uint uVar2;
  uint uVar3;
  
  if ((0 < param_2) && (param_2 < *(int *)(param_1_00 + 4))) {
    cVar1 = FUN_005438c0(param_1,param_2);
    if (cVar1 == '\0') {
      param_2 = (param_1 << ((byte)*(undefined4 *)(param_1_00 + 8) & 0x1f)) + param_2;
      uVar2 = *(uint *)(*(int *)(param_1_00 + 0xc) + -4 + param_2 * 4) & 0xfffffff;
      uVar3 = *(uint *)(*(int *)(param_1_00 + 0xc) + param_2 * 4) & 0xfffffff;
      if ((uVar2 != 0) && (uVar3 != 0)) {
        return (float10)(uVar3 - uVar2) * (float10)_DAT_006ed098;
      }
    }
  }
  return (float10)_DAT_006ea4b8;
}


