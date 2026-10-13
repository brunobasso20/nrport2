/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0050fbd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0050fbd0(void)

{
  int iVar1;
  undefined4 uVar2;
  char cVar3;
  undefined4 uVar4;
  int iVar5;
  char *pcVar6;
  uint uVar7;
  uint uVar8;
  int iVar9;
  char *pcVar10;
  char *pcVar11;
  undefined4 *puVar12;
  undefined *puVar13;

  FUN_005cfcc6(0x28,s__track_0074b9e7 + 1,PTR_s_track_tire_wear_0074b89c,
               PTR_s_relative_tire_wear__>1_0__>_more_0074b910,2,2);
  _DAT_00ba72de = DAT_0074b9d8;
  _DAT_00ba72da = &DAT_0074b9d8;
  _DAT_00ba72e2 = DAT_0074b9d8;
  FUN_005cfcc6(0x28,s_track_0074b9f0,PTR_s_track_tire_heat_0074b8b0,
               PTR_s_relative_tire_heating__>1_0__>_m_0074b940,2,2);
  _DAT_00ba72ae = DAT_0074b9dc;
  _DAT_00ba72b2 = DAT_0074b9dc;
  _DAT_00ba72aa = &DAT_0074b9dc;
  FUN_005cfcc6(0x28,s_track_0074b9f8,PTR_s_track_tire_wear_loss_0074b8cc,
               PTR_s___grip_lost_for_fully_worn_tire___0074b980,2,2);
  _DAT_00bcf722 = DAT_0074b9e0;
  _DAT_00bcf71e = &DAT_0074b9e0;
  _DAT_00bcf726 = DAT_0074b9e0;
  FUN_005cfcc6(0x28,s_track_0074ba00,PTR_s_track_tire_wear_exp_0074b8e4,
               PTR_s_controls_grip_wear_curve__<1_0___0074b9d4,2,2);
  _DAT_00bc0bea = &DAT_0074b9e4;
  _DAT_00bc0bee = _DAT_0074b9e4;
  _DAT_00bc0bf2 = _DAT_0074b9e4;
  iVar5 = 0;
  do {
    pcVar6 = s_track__0074ba08 + iVar5;
    (&DAT_00ba71d8)[iVar5] = *pcVar6;
    iVar5 = iVar5 + 1;
  } while (*pcVar6 != '\0');
  pcVar6 = (char *)FUN_0056c0f0(0xffffffff);
  uVar7 = 0xffffffff;
  do {
    pcVar11 = pcVar6;
    if (uVar7 == 0) break;
    uVar7 = uVar7 - 1;
    pcVar11 = pcVar6 + 1;
    cVar3 = *pcVar6;
    pcVar6 = pcVar11;
  } while (cVar3 != '\0');
  uVar7 = ~uVar7;
  iVar5 = -1;
  pcVar6 = &DAT_00ba71d8;
  do {
    pcVar10 = pcVar6;
    if (iVar5 == 0) break;
    iVar5 = iVar5 + -1;
    pcVar10 = pcVar6 + 1;
    cVar3 = *pcVar6;
    pcVar6 = pcVar10;
  } while (cVar3 != '\0');
  pcVar6 = pcVar11 + -uVar7;
  pcVar11 = pcVar10 + -1;
  for (uVar8 = uVar7 >> 2; puVar13 = PTR_s_relative_tire_wear__>1_0__>_more_0074b910, uVar8 != 0;
      uVar8 = uVar8 - 1) {
    *(undefined4 *)pcVar11 = *(undefined4 *)pcVar6;
    pcVar6 = pcVar6 + 4;
    pcVar11 = pcVar11 + 4;
  }
  for (uVar7 = uVar7 & 3; uVar7 != 0; uVar7 = uVar7 - 1) {
    *pcVar11 = *pcVar6;
    pcVar6 = pcVar6 + 1;
    pcVar11 = pcVar11 + 1;
  }
  DAT_00bad914 = -1.2345679e+08;
  DAT_00bad924 = -1.2345679e+08;
  DAT_00ba72e8 = -1.2345679e+08;
  DAT_00bad91c = -1.2345679e+08;
  FUN_005cfcc6(0x28,&DAT_00ba71d8,PTR_s_track_tire_wear_0074b89c,puVar13,2,2);
  _DAT_00bb3f86 = DAT_00bad914;
  _DAT_00bb3f82 = &DAT_00bad914;
  _DAT_00bb3f8a = DAT_00bad914;
  FUN_005cfcc6(0x28,&DAT_00ba71d8,PTR_s_track_tire_heat_0074b8b0,
               PTR_s_relative_tire_heating__>1_0__>_m_0074b940,2,2);
  _DAT_00ba7242 = DAT_00bad924;
  _DAT_00ba7246 = DAT_00bad924;
  _DAT_00ba723e = &DAT_00bad924;
  FUN_005cfcc6(0x28,&DAT_00ba71d8,PTR_s_track_tire_wear_loss_0074b8cc,
               PTR_s___grip_lost_for_fully_worn_tire___0074b980,2,2);
  _DAT_00ba7276 = DAT_00ba72e8;
  _DAT_00ba7272 = &DAT_00ba72e8;
  _DAT_00ba727a = DAT_00ba72e8;
  puVar13 = PTR_s_controls_grip_wear_curve__<1_0___0074b9d4;
  FUN_005cfcc6(0x28,&DAT_00ba71d8,PTR_s_track_tire_wear_exp_0074b8e4,
               PTR_s_controls_grip_wear_curve__<1_0___0074b9d4,2,2);
  _DAT_00bcf6e6 = DAT_00bad91c;
  _DAT_00bcf6ea = DAT_00bad91c;
  puVar12 = &DAT_00ba7170;
  for (iVar5 = 0x14; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar12 = 0xcceb79a3;
    puVar12 = puVar12 + 1;
  }
  iVar9 = 0;
  puVar12 = &DAT_0074fb30;
  for (iVar5 = 0x14; iVar5 != 0; iVar5 = iVar5 + -1) {
    *puVar12 = 0x3f800000;
    puVar12 = puVar12 + 1;
  }
  _DAT_00bcf6e2 = &DAT_00bad91c;
  iVar5 = 0;
  do {
    FUN_005cfcc6(0x28,s_track_0074ba10,
                 *(undefined4 *)((int)&PTR_s_track_undefined_grip_0074f7d8 + iVar5),
                 *(undefined4 *)((int)&PTR_s_relative_grip_for_undefined_mate_0074fae0 + iVar5),2,2)
    ;
    uVar2 = *(undefined4 *)((int)&DAT_0074fb30 + iVar5);
    uVar4 = *(undefined4 *)((int)&PTR_s_track_undefined_grip_0074f7d8 + iVar5);
    *(undefined4 *)((int)&DAT_00b9cbe6 + iVar9) = uVar2;
    *(undefined4 *)((int)&DAT_00b9cbea + iVar9) = uVar2;
    *(int *)((int)&DAT_00b9cbe2 + iVar9) = (int)&DAT_0074fb30 + iVar5;
    FUN_005cfcc6(0x28,&DAT_00ba71d8,uVar4,
                 *(undefined4 *)((int)&PTR_s_relative_grip_for_undefined_mate_0074fae0 + iVar5),2,2)
    ;
    uVar2 = *(undefined4 *)((int)&DAT_00ba7170 + iVar5);
    iVar1 = (int)&DAT_00ba7170 + iVar5;
    iVar5 = iVar5 + 4;
    *(undefined4 *)((int)&DAT_00bc0c1e + iVar9) = uVar2;
    *(undefined4 *)((int)&DAT_00bc0c22 + iVar9) = uVar2;
    *(int *)((int)&DAT_00bc0c1a + iVar9) = iVar1;
    iVar9 = iVar9 + 0x2e;
  } while (iVar9 < 0x398);
  FUN_005cfd26(0x28,puVar13);
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  FUN_005cfcc0();
  iVar5 = 0;
  do {
    FUN_005cfcc0();
    FUN_005cfcc0();
    iVar5 = iVar5 + 0x2e;
  } while (iVar5 < 0x398);
  if (DAT_00bad914 != _DAT_006f4610) {
    DAT_0074b9d8 = DAT_00bad914;
  }
  if (DAT_00bad924 != _DAT_006f4610) {
    DAT_0074b9dc = DAT_00bad924;
  }
  if (DAT_00ba72e8 != _DAT_006f4610) {
    DAT_0074b9e0 = DAT_00ba72e8;
  }
  if (DAT_00bad91c != _DAT_006f4610) {
    _DAT_0074b9e4 = DAT_00bad91c;
  }
  iVar5 = 0;
  do {
    if (*(int *)((int)&DAT_00ba7170 + iVar5) != -0x3314865d) {
      *(int *)((int)&DAT_0074fb30 + iVar5) = *(int *)((int)&DAT_00ba7170 + iVar5);
    }
    iVar5 = iVar5 + 4;
  } while (iVar5 < 0x50);
  iVar5 = 0;
  do {
    iVar9 = iVar5 + 4;
    *(float *)((int)&DAT_0074fb30 + iVar5) =
         *(float *)((int)&DAT_006f6570 + iVar5) * *(float *)((int)&DAT_0074fb30 + iVar5);
    iVar5 = iVar9;
  } while (iVar9 < 0x50);
  return 1;
}
