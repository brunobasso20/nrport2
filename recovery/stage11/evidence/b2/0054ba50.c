/* NR2003.exe @ 0054ba50 FUN_0054ba50 */

void __thiscall FUN_0054ba50(int param_1_00,byte param_1,char param_2)

{
  uint uVar1;
  uint uVar2;
  
  uVar1 = 1 << (param_1 & 0x1f);
  uVar2 = *(uint *)(param_1_00 + 0xc) & (~uVar1 << 0x1d | 0x9fffffff);
  *(uint *)(param_1_00 + 0xc) = uVar2;
  if (param_2 != '\0') {
    *(uint *)(param_1_00 + 0xc) = (uVar1 & 3) << 0x1d | uVar2;
  }
  return;
}

