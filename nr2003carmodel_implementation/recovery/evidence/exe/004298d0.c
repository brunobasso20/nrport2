/* NR2003.exe @ 004298d0 FUN_004298d0 */

undefined4 FUN_004298d0(int param_1)

{
  int *piVar1;
  int iVar2;
  
  *(undefined4 *)(param_1 + 0x308) = 0;
  *(undefined4 *)(param_1 + 0x30c) = 0;
  *(undefined4 *)(param_1 + 0x310) = 0;
  iVar2 = **(int **)(param_1 + 4);
  *(undefined4 *)(param_1 + 0x314) = 0;
  *(undefined4 *)(param_1 + 0x318) = 0;
  *(undefined4 *)(param_1 + 0x31c) = 0;
  *(undefined4 *)(param_1 + 800) = 0;
  *(undefined4 *)(param_1 + 0x324) = 0;
  *(undefined4 *)(param_1 + 0x328) = 0;
  *(undefined4 *)(param_1 + 0x32c) = 0;
  *(undefined4 *)(param_1 + 0x330) = 0;
  *(undefined4 *)(param_1 + 0x334) = 0;
  *(undefined4 *)(param_1 + 0x338) = 0;
  *(undefined4 *)(param_1 + 0x33c) = 0;
  *(undefined4 *)(param_1 + 0x340) = 0;
  *(undefined4 *)(param_1 + 0x348) = 0;
  *(undefined4 *)(param_1 + 0x34c) = 0;
  *(undefined4 *)(param_1 + 0x350) = 0;
  *(undefined4 *)(param_1 + 0x354) = 0;
  *(undefined4 *)(param_1 + 0x358) = 0;
  *(undefined4 *)(param_1 + 0x35c) = 0;
  *(undefined4 *)(param_1 + 0x360) = 0;
  *(undefined4 *)(param_1 + 0x364) = 0;
  *(undefined4 *)(param_1 + 0x368) = 0;
  *(undefined4 *)(param_1 + 0x36c) = 0;
  *(undefined4 *)(param_1 + 0x370) = 0;
  *(undefined4 *)(param_1 + 0x374) = 0;
  *(undefined4 *)(param_1 + 0x378) = 0;
  *(undefined4 *)(param_1 + 0x37c) = 0;
  piVar1 = (int *)(**(code **)(iVar2 + 0x14))();
  if (piVar1 != (int *)0x0) {
    (**(code **)(*piVar1 + 0x24))(s_wheel_speed_0_00722e30,param_1 + 0x2fc);
    (**(code **)(*piVar1 + 0x24))(s_wheel_speed_1_00722e40,param_1 + 0x2f8);
    (**(code **)(*piVar1 + 0x24))(s_wheel_speed_2_00722e50,param_1 + 0x304);
    (**(code **)(*piVar1 + 0x24))(s_wheel_speed_3_00722e60,param_1 + 0x300);
    iVar2 = (**(code **)(*piVar1 + 0x1c))(s_lfWheel_00722e70,(undefined4 *)(param_1 + 0x2e4));
    if (iVar2 != 1) {
      *(undefined4 *)(param_1 + 0x2e4) = 0;
    }
    iVar2 = (**(code **)(*piVar1 + 0x1c))(s_rfWheel_00722e78,(undefined4 *)(param_1 + 0x2e8));
    if (iVar2 != 1) {
      *(undefined4 *)(param_1 + 0x2e8) = 0;
    }
    iVar2 = (**(code **)(*piVar1 + 0x1c))(s_lrWheel_00722e80,(undefined4 *)(param_1 + 0x2ec));
    if (iVar2 != 1) {
      *(undefined4 *)(param_1 + 0x2ec) = 0;
    }
    iVar2 = (**(code **)(*piVar1 + 0x1c))(s_rrWheel_00722e88,(undefined4 *)(param_1 + 0x2f0));
    if (iVar2 != 1) {
      *(undefined4 *)(param_1 + 0x2f0) = 0;
    }
    iVar2 = (**(code **)(*piVar1 + 0x1c))(&DAT_00722e90,(undefined4 *)(param_1 + 0x2f4));
    if (iVar2 != 1) {
      *(undefined4 *)(param_1 + 0x2f4) = 0;
      return 1;
    }
  }
  return 1;
}

