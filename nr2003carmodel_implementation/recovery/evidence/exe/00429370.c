/* NR2003.exe @ 00429370 FUN_00429370 */

undefined4 FUN_00429370(int param_1,undefined4 param_2)

{
  int **ppiVar1;
  int **ppiVar2;
  int *piVar3;
  code **ppcVar4;
  int iVar5;
  undefined4 uVar6;
  double dVar7;
  int *piVar8;
  int *piVar9;
  undefined local_108 [120];
  undefined4 uStack_90;
  
  iVar5 = FUN_004296b0(param_1,param_2);
  if (iVar5 != 0) {
    iVar5 = FUN_00428680(param_2,local_108,0x105);
    if (iVar5 == 1) {
      ppiVar1 = (int **)(param_1 + 4);
      iVar5 = FUN_004287a0(ppiVar1,local_108);
      if (iVar5 != 0) {
        iVar5 = FUN_00429800(param_1,param_2);
        if (iVar5 == 0) {
          *(undefined4 *)(param_1 + 0x5c) = 0;
          uVar6 = 0;
        }
        else {
          (**(code **)(**(int **)(param_1 + 0x14) + 0x24))(s_caution_light_00722d70,param_1 + 0x5c);
          uVar6 = *(undefined4 *)(param_1 + 0x14);
        }
        piVar3 = *ppiVar1;
        (**(code **)(*piVar3 + 0x18))(uVar6);
        iVar5 = *piVar3;
        *(undefined4 *)(param_1 + 0x60) = 0;
        (**(code **)(iVar5 + 0x10))(*(undefined4 *)(param_1 + 0x10));
        (**(code **)(*piVar3 + 0x24))(s_wheel_speed_0_00722d80,param_1 + 700);
        (**(code **)(**ppiVar1 + 0x24))(s_wheel_speed_1_00722d90,param_1 + 0x2b8);
        (**(code **)(**ppiVar1 + 0x24))(s_wheel_speed_2_00722da0,param_1 + 0x2c4);
        (**(code **)(**ppiVar1 + 0x24))(s_wheel_speed_3_00722db0,param_1 + 0x2c0);
        (**(code **)(**ppiVar1 + 0x1c))(s_lfwheel_00722dc0,(int **)(param_1 + 0xf0));
        ppiVar2 = (int **)(param_1 + 0xf8);
        (**(code **)(**ppiVar1 + 0x1c))(s_rfwheel_00722dc8,ppiVar2);
        (**(code **)(**ppiVar1 + 0x1c))(s_lrwheel_00722dd0,param_1 + 0x100);
        (**(code **)(**ppiVar1 + 0x1c))(s_rrwheel_00722dd8,param_1 + 0x108);
        piVar3 = *(int **)(param_1 + 0xf0);
        uVar6 = (**(code **)(*piVar3 + 0x18))();
        *(undefined4 *)(param_1 + 0x2a8) = uVar6;
        uVar6 = (**(code **)(**ppiVar2 + 0x18))();
        piVar9 = *(int **)(param_1 + 0x100);
        *(undefined4 *)(param_1 + 0x2ac) = uVar6;
        uVar6 = (**(code **)(*piVar9 + 0x18))();
        piVar8 = *(int **)(param_1 + 0x108);
        *(undefined4 *)(param_1 + 0x2b0) = uVar6;
        uVar6 = (**(code **)(*piVar8 + 0x18))();
        *(undefined4 *)(param_1 + 0x2b4) = uVar6;
        uVar6 = (**(code **)(*piVar3 + 0x18))();
        *(undefined4 *)(param_1 + 0x2c8) = uVar6;
        uVar6 = (**(code **)(**ppiVar2 + 0x18))();
        *(undefined4 *)(param_1 + 0x2cc) = uVar6;
        uVar6 = (**(code **)(*piVar9 + 0x18))();
        *(undefined4 *)(param_1 + 0x2d0) = uVar6;
        uVar6 = (**(code **)(*piVar8 + 0x18))();
        *(undefined4 *)(param_1 + 0x2d4) = uVar6;
        *(undefined4 *)(param_1 + 0xf4) = 0;
        *(undefined4 *)(param_1 + 0xfc) = 0;
        *(undefined4 *)(param_1 + 0x104) = 0;
        *(undefined4 *)(param_1 + 0x10c) = 0;
        (**(code **)(*piVar3 + 0x14))(param_1 + 0x22c);
        (**(code **)(**ppiVar2 + 0x14))(param_1 + 0x238);
        (**(code **)(**(int **)(param_1 + 0x100) + 0x14))(param_1 + 0x244);
        (**(code **)(**(int **)(param_1 + 0x108) + 0x14))(param_1 + 0x250);
        (**(code **)(**(int **)(param_1 + 0xf0) + 0x10))
                  (param_1 + 0x25c,param_1 + 0x260,param_1 + 0x264);
        (**(code **)(**ppiVar2 + 0x10))(param_1 + 0x268,param_1 + 0x26c,param_1 + 0x270);
        (**(code **)(**(int **)(param_1 + 0x100) + 0x10))
                  (param_1 + 0x274,param_1 + 0x278,param_1 + 0x27c);
        (**(code **)(**(int **)(param_1 + 0x108) + 0x10))
                  (param_1 + 0x280,param_1 + 0x284,param_1 + 0x288);
        ppiVar2 = (int **)(param_1 + 0x140);
        iVar5 = (**(code **)(**ppiVar1 + 0x1c))(&DAT_00722de0,ppiVar2);
        if (iVar5 != 1) {
          *ppiVar2 = (int *)0x0;
        }
        if (*ppiVar2 != (int *)0x0) {
          (**(code **)(**ppiVar2 + 0x14))(param_1 + 0x1c0);
        }
        piVar3 = (int *)(param_1 + 100);
        iVar5 = (**(code **)(**ppiVar1 + 0x24))(s_RandomPaintjob_00722de8,piVar3);
        if (iVar5 != 1) {
          *piVar3 = 0;
        }
        if ((undefined4 *)*piVar3 != (undefined4 *)0x0) {
          ppcVar4 = *(code ***)(undefined4 *)*piVar3;
          dVar7 = rndUniform(0);
          (**ppcVar4)((float)dVar7);
          if (DAT_00c72160 != (int *)0x0) {
            (**(code **)(*DAT_00c72160 + 0x24))(*ppiVar1);
          }
        }
        FUN_004298d0(param_1,uStack_90);
        return 1;
      }
    }
  }
  return 0;
}

