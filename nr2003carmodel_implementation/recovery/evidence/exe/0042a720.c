/* NR2003.exe @ 0042a720 FUN_0042a720 */

undefined4 FUN_0042a720(int param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int *piVar3;
  int *piVar4;
  int iVar5;
  char *pcVar6;
  char *pcVar7;
  
  *(undefined4 *)(param_1 + 0x310) = 0;
  *(undefined4 *)(param_1 + 0x308) = 0;
  iVar5 = **(int **)(param_1 + 4);
  puVar1 = (undefined4 *)(param_1 + 0x328);
  puVar2 = (undefined4 *)(param_1 + 0x32c);
  *(undefined4 *)(param_1 + 0x30c) = 0;
  *(undefined4 *)(param_1 + 0x314) = 0;
  *(undefined4 *)(param_1 + 0x318) = 0;
  *(undefined4 *)(param_1 + 0x31c) = 0;
  *(undefined4 *)(param_1 + 800) = 0;
  *(undefined4 *)(param_1 + 0x324) = 0;
  *puVar1 = 0;
  *puVar2 = 0;
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
  piVar4 = (int *)(**(code **)(iVar5 + 0x14))();
  if (piVar4 != (int *)0x0) {
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_backfireFrame_007232c0,puVar1);
    if (iVar5 != 1) {
      *puVar1 = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_day_night_007232d0,puVar2);
    if (iVar5 != 1) {
      *puVar2 = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_wheel_speed_0_007232dc,(undefined4 *)(param_1 + 0x2fc));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2fc) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_wheel_speed_1_007232ec,(undefined4 *)(param_1 + 0x2f8));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2f8) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_wheel_speed_2_007232fc,(undefined4 *)(param_1 + 0x304));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x304) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_wheel_speed_3_0072330c,(undefined4 *)(param_1 + 0x300));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x300) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))
                      (s_mirrorFrameEnable_0072331c,(undefined4 *)(param_1 + 0x314));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x314) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))
                      (s_windshieldEnable_00723330,(undefined4 *)(param_1 + 0x31c));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x31c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))
                      (s_steeringWheelEnable_00723344,(undefined4 *)(param_1 + 0x318));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x318) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))
                      (s_roof_flap_state_00723358,(undefined4 *)(param_1 + 0x324));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x324) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_roofFlapsEnable_00723368,(undefined4 *)(param_1 + 800));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 800) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_chassis_damage_00723378,(undefined4 *)(param_1 + 0x364))
    ;
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x364) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_corners_damage_00723388,(undefined4 *)(param_1 + 0x358))
    ;
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x358) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_grill_damage_00723398,(undefined4 *)(param_1 + 0x33c));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x33c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_hood_damage_007233a8,(undefined4 *)(param_1 + 0x360));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x360) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_rend_damage_007233b4,(undefined4 *)(param_1 + 0x344));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x344) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_rf_removed_007233c0,(undefined4 *)(param_1 + 0x34c));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x34c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_lf_removed_007233cc,(undefined4 *)(param_1 + 0x348));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x348) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_rr_removed_007233d8,(undefined4 *)(param_1 + 0x354));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x354) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_lr_removed_007233e4,(undefined4 *)(param_1 + 0x350));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x350) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_grill_removed_007233f0,(undefined4 *)(param_1 + 0x338));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x338) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_hood_removed_00723400,(undefined4 *)(param_1 + 0x35c));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x35c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_rend_removed_00723410,(undefined4 *)(param_1 + 0x340));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x340) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))
                      (s_frontend_broken_00723420,(undefined4 *)(param_1 + 0x36c));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x36c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_rearend_broken_00723430,(undefined4 *)(param_1 + 0x370))
    ;
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x370) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_damaged_00723440,(undefined4 *)(param_1 + 0x368));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x368) = 0;
    }
    piVar3 = (int *)(param_1 + 0x330);
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_animate_driver_00723448,piVar3);
    if (iVar5 != 1) {
      *piVar3 = 0;
    }
    if ((undefined4 *)*piVar3 != (undefined4 *)0x0) {
      (***(code ***)(undefined4 *)*piVar3)(0x3f800000);
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_timeValue_00723458,(undefined4 *)(param_1 + 0x334));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x334) = 0;
    }
    if ((*(int **)(param_1 + 0xc) == (int *)0x0) ||
       (iVar5 = (**(code **)(**(int **)(param_1 + 0xc) + 0x24))
                          (s_panels_or_fragments_00723464,param_1 + 0x374), iVar5 != 1)) {
      *(undefined4 *)(param_1 + 0x374) = 0;
    }
    if ((*(int **)(param_1 + 0xc) == (int *)0x0) ||
       (iVar5 = (**(code **)(**(int **)(param_1 + 0xc) + 0x24))
                          (s_panel_selector_00723478,param_1 + 0x378), iVar5 != 1)) {
      *(undefined4 *)(param_1 + 0x378) = 0;
    }
    if ((*(int **)(param_1 + 0xc) == (int *)0x0) ||
       (iVar5 = (**(code **)(**(int **)(param_1 + 0xc) + 0x24))
                          (s_fragment_selector_00723488,param_1 + 0x37c), iVar5 != 1)) {
      *(undefined4 *)(param_1 + 0x37c) = 0;
    }
    if ((*(int **)(param_1 + 0xc) == (int *)0x0) ||
       (iVar5 = (**(code **)(**(int **)(param_1 + 0xc) + 0x24))
                          (s_carMakeIdx_0072349c,param_1 + 0x30c), iVar5 != 1)) {
      *(undefined4 *)(param_1 + 0x30c) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x1c))(s_lfWheel_007234a8,(undefined4 *)(param_1 + 0x2e4));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2e4) = 0;
    }
    pcVar7 = s_rfWheel_007234b0;
    iVar5 = (**(code **)(*piVar4 + 0x1c))(s_rfWheel_007234b0,(undefined4 *)(param_1 + 0x2e8));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2e8) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x1c))(s_lrWheel_007234b8,(undefined4 *)(param_1 + 0x2ec));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2ec) = 0;
    }
    pcVar6 = s_rrWheel_007234c0;
    iVar5 = (**(code **)(*piVar4 + 0x1c))(s_rrWheel_007234c0,(undefined4 *)(param_1 + 0x2f0));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2f0) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x1c))(&DAT_007234c8,(undefined4 *)(param_1 + 0x2f4));
    if (iVar5 != 1) {
      *(undefined4 *)(param_1 + 0x2f4) = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_cockpitView_007234d0,pcVar7);
    if (iVar5 != 1) {
      *(undefined4 *)pcVar7 = 0;
    }
    iVar5 = (**(code **)(*piVar4 + 0x24))(s_carMakeIdx_007234dc,pcVar6);
    if (iVar5 != 1) {
      *(undefined4 *)pcVar6 = 0;
      return 1;
    }
  }
  return 1;
}

