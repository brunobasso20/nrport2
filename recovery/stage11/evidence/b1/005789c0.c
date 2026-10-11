/* NR2003.exe @ 005789c0 FUN_005789c0 */

void __thiscall FUN_005789c0(int param_1_00,undefined4 param_1,undefined4 param_2)

{
  uint uVar1;
  int iVar2;
  
  *(undefined4 *)(param_1_00 + 0x9954) = param_1;
  uVar1 = *(uint *)(param_1_00 + 0x6c14) ^ 1;
  *(int *)(param_1_00 + 0x9934) = *(int *)(param_1_00 + 0x9934) + 1;
  *(uint *)(param_1_00 + 0x6c14) = uVar1;
  *(undefined4 *)(param_1_00 + 0x9958) = param_2;
  if (*(int *)(param_1_00 + 0x138c + uVar1 * 0x2c44) != 0) {
    *(undefined4 *)(param_1_00 + 0x138c + uVar1 * 0x2c44) = 0;
  }
  if (-1 < *(int *)(param_1_00 + 0x9938)) {
    iVar2 = (**(code **)(param_1_00 + 0x9954))(*(int *)(param_1_00 + 0x9938));
    if (*(int *)(iVar2 + 4) != 0) {
      FUN_005790c0(*(undefined4 *)(param_1_00 + 0x9934));
    }
  }
  FUN_00578700(*(undefined4 *)(param_1_00 + 0x9934));
  return;
}

