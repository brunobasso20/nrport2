/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00429370 */

undefined4 FUN_00429370(int param_1,undefined4 param_2)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int *piVar3;
  int iVar4;
  undefined4 uVar5;
  double dVar6;
  int *piVar7;
  int *piVar8;
  undefined1 local_108 [120];
  undefined4 uStack_90;
  
  iVar4 = FUN_004296b0(param_1,param_2);
  if (iVar4 != 0) {
    iVar4 = FUN_00428680(param_2,local_108,0x105);
    if (iVar4 == 1) {
      puVar1 = (undefined4 *)(param_1 + 4);
      iVar4 = FUN_004287a0(puVar1,local_108);
      if (iVar4 != 0) {
        iVar4 = FUN_00429800(param_1,param_2);
        if (iVar4 == 0) {
          *(undefined4 *)(param_1 + 0x5c) = 0;
          uVar5 = 0;
        }
        else {
          (**(code **)(**(int **)(param_1 + 0x14) + 0x24))(s_caution_light_00722d70,param_1 + 0x5c);
          uVar5 = *(undefined4 *)(param_1 + 0x14);
        }
        piVar3 = (int *)*puVar1;
        (**(code **)(*piVar3 + 0x18))(uVar5);
        iVar4 = *piVar3;
        *(undefined4 *)(param_1 + 0x60) = 0;
        (**(code **)(iVar4 + 0x10))(*(undefined4 *)(param_1 + 0x10));
        (**(code **)(*piVar3 + 0x24))(s_wheel_speed_0_00722d80,param_1 + 700);
        (**(code **)(*(int *)*puVar1 + 0x24))(s_wheel_speed_1_00722d90,param_1 + 0x2b8);
        (**(code **)(*(int *)*puVar1 + 0x24))(s_wheel_speed_2_00722da0,param_1 + 0x2c4);
        (**(code **)(*(int *)*puVar1 + 0x24))(s_wheel_speed_3_00722db0,param_1 + 0x2c0);
        (**(code **)(*(int *)*puVar1 + 0x1c))(s_lfwheel_00722dc0,(undefined4 *)(param_1 + 0xf0));
        puVar2 = (undefined4 *)(param_1 + 0xf8);
        (**(code **)(*(int *)*puVar1 + 0x1c))(s_rfwheel_00722dc8,puVar2);
        (**(code **)(*(int *)*puVar1 + 0x1c))(s_lrwheel_00722dd0,param_1 + 0x100);
        (**(code **)(*(int *)*puVar1 + 0x1c))(s_rrwheel_00722dd8,param_1 + 0x108);
        piVar3 = *(int **)(param_1 + 0xf0);
        uVar5 = (**(code **)(*piVar3 + 0x18))();
        *(undefined4 *)(param_1 + 0x2a8) = uVar5;
        uVar5 = (**(code **)(*(int *)*puVar2 + 0x18))();
        piVar8 = *(int **)(param_1 + 0x100);
        *(undefined4 *)(param_1 + 0x2ac) = uVar5;
        uVar5 = (**(code **)(*piVar8 + 0x18))();
        piVar7 = *(int **)(param_1 + 0x108);
        *(undefined4 *)(param_1 + 0x2b0) = uVar5;
        uVar5 = (**(code **)(*piVar7 + 0x18))();
        *(undefined4 *)(param_1 + 0x2b4) = uVar5;
        uVar5 = (**(code **)(*piVar3 + 0x18))();
        *(undefined4 *)(param_1 + 0x2c8) = uVar5;
        uVar5 = (**(code **)(*(int *)*puVar2 + 0x18))();
        *(undefined4 *)(param_1 + 0x2cc) = uVar5;
        uVar5 = (**(code **)(*piVar8 + 0x18))();
        *(undefined4 *)(param_1 + 0x2d0) = uVar5;
        uVar5 = (**(code **)(*piVar7 + 0x18))();
        *(undefined4 *)(param_1 + 0x2d4) = uVar5;
        *(undefined4 *)(param_1 + 0xf4) = 0;
        *(undefined4 *)(param_1 + 0xfc) = 0;
        *(undefined4 *)(param_1 + 0x104) = 0;
        *(undefined4 *)(param_1 + 0x10c) = 0;
        (**(code **)(*piVar3 + 0x14))(param_1 + 0x22c);
        (**(code **)(*(int *)*puVar2 + 0x14))(param_1 + 0x238);
        (**(code **)(**(int **)(param_1 + 0x100) + 0x14))(param_1 + 0x244);
        (**(code **)(**(int **)(param_1 + 0x108) + 0x14))(param_1 + 0x250);
        (**(code **)(**(int **)(param_1 + 0xf0) + 0x10))
                  (param_1 + 0x25c,param_1 + 0x260,param_1 + 0x264);
        (**(code **)(*(int *)*puVar2 + 0x10))(param_1 + 0x268,param_1 + 0x26c,param_1 + 0x270);
        (**(code **)(**(int **)(param_1 + 0x100) + 0x10))
                  (param_1 + 0x274,param_1 + 0x278,param_1 + 0x27c);
        (**(code **)(**(int **)(param_1 + 0x108) + 0x10))
                  (param_1 + 0x280,param_1 + 0x284,param_1 + 0x288);
        piVar3 = (int *)(param_1 + 0x140);
        iVar4 = (**(code **)(*(int *)*puVar1 + 0x1c))(&DAT_00722de0,piVar3);
        if (iVar4 != 1) {
          *piVar3 = 0;
        }
        if ((int *)*piVar3 != (int *)0x0) {
          (**(code **)(*(int *)*piVar3 + 0x14))(param_1 + 0x1c0);
        }
        piVar3 = (int *)(param_1 + 100);
        iVar4 = (**(code **)(*(int *)*puVar1 + 0x24))(s_RandomPaintjob_00722de8,piVar3);
        if (iVar4 != 1) {
          *piVar3 = 0;
        }
        if ((undefined4 *)*piVar3 != (undefined4 *)0x0) {
          puVar2 = *(undefined4 **)*piVar3;
          dVar6 = rndUniform(0);
          (*(code *)*puVar2)((float)dVar6);
          if (DAT_00c72160 != (int *)0x0) {
            (**(code **)(*DAT_00c72160 + 0x24))(*puVar1);
          }
        }
        FUN_004298d0(param_1,uStack_90);
        return 1;
      }
    }
  }
  return 0;
}


