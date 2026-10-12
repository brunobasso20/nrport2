/* NR2003.exe @ 10005260 FUN_10005260 */

undefined4 __cdecl FUN_10005260(int *param_1)

{
  undefined4 in_EAX;
  undefined4 uVar1;
  uint uVar2;
  
  if (param_1 == (int *)0x0) {
    return CONCAT31((int3)((uint)in_EAX >> 8),1);
  }
  uVar2 = param_1[1] - 1;
  param_1[1] = uVar2;
  if ((int)uVar2 < 1) {
    uVar1 = (**(code **)(*param_1 + 4))(1);
    return CONCAT31((int3)((uint)uVar1 >> 8),1);
  }
  return uVar2 & 0xffffff00;
}

