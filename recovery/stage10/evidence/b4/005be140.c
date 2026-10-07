/* NR2003.exe @ 005be140 FUN_005be140 */

uint FUN_005be140(undefined4 param_1)

{
  undefined4 uVar1;
  uint uVar2;
  undefined8 uVar3;
  
  uVar1 = FUN_005bdc60(param_1);
  uVar3 = FUN_005bd0c0(uVar1);
  uVar2 = (uint)((ulonglong)uVar3 >> 0x20);
  if ((int)uVar3 != 0) {
    return 0;
  }
  return ((int)uVar2 < 0x5dc) - 1 & uVar2;
}

