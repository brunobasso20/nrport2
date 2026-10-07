/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005730e0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: ram */

undefined4 FUN_005730e0(undefined4 param_1,undefined *param_2)

{
  int iVar1;
  float10 fVar2;
  undefined4 uVar3;
  char *pcVar4;
  char *pcStack_28;
  undefined *puStack_24;
  char *pcStack_20;
  int *piStack_1c;
  int **ppiStack_18;
  int *piStack_14;
  
  piStack_14 = (int *)param_1;
  DAT_0074f3d8 = param_2[0x30] == '\0';
  ppiStack_18 = (int **)0x5730ff;
  iVar1 = FUN_00572760();
  if (iVar1 != 0) {
    piStack_14 = (int *)param_2;
    ppiStack_18 = (int **)0x573110;
    iVar1 = FUN_005bc1d0();
    if (iVar1 != 0) {
      piStack_14 = (int *)param_2;
      ppiStack_18 = (int **)0x573121;
      iVar1 = FUN_00573500();
      if (iVar1 != 0) {
        piStack_14 = (int *)0x573133;
        iVar1 = FUN_0055a5a0();
        piStack_14 = (int *)0;
        if (iVar1 == 1) {
          piStack_14 = (int *)DAT_0074f354;
        }
        ppiStack_18 = (int **)0x573144;
        FUN_005d5030();
        ppiStack_18 = &DAT_00c72160;
        piStack_1c = (int *)param_2;
        pcStack_20 = (char *)0x57314f;
        iVar1 = FUN_005d3900();
        if (iVar1 != 0) {
          piStack_14 = DAT_00c72160;
          ppiStack_18 = (int **)0x573166;
          FUN_005ae0a0();
          ppiStack_18 = (int **)DAT_00c72160;
          piStack_1c = (int *)0x573172;
          FUN_00573a60();
          piStack_1c = DAT_00c72160;
          pcStack_20 = (char *)0x57317d;
          FUN_00599100();
          piStack_14 = (int *)&DAT_00c7216c;
          ppiStack_18 = (int **)s_Weekend_0074f528;
          piStack_1c = (int *)0x573195;
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))();
          if (iVar1 == 0) {
            _DAT_00c7216c = 0;
          }
          piStack_1c = (int *)&DAT_00c72174;
          pcStack_20 = s_caution_light_0074f530;
          puStack_24 = (undefined *)0x5731b4;
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))();
          if (iVar1 == 0) {
            _DAT_00c72174 = 0;
          }
          puStack_24 = &DAT_00c7217c;
          pcStack_28 = s_Weather_0074f540;
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))();
          if (iVar1 == 0) {
            _DAT_00c7217c = 0;
          }
          pcVar4 = s_Population_0074f548;
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))(s_Population_0074f548,&DAT_00c72180);
          if (iVar1 == 0) {
            _DAT_00c72180 = 0;
          }
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))(s_AnimObjs_0074f554,&DAT_00c72184);
          if (iVar1 == 0) {
            _DAT_00c72184 = 0;
          }
          iVar1 = (**(code **)(*DAT_00c72160 + 0x10))(s_Day_Night_0074f560);
          if (iVar1 == 0) {
            DAT_00c72188 = (undefined4 *)0x0;
          }
          else {
            pcStack_28 = (char *)0x3f800000;
            if (param_2[0x30] == '\0') {
              pcStack_28 = (char *)0x0;
            }
            (**(code **)*DAT_00c72188)(pcStack_28);
          }
          iVar1 = FUN_00572760(param_1);
          if (iVar1 != 0) {
            DAT_00c7215c = (int *)0x0;
            FUN_005d3eb0(s_sky_3do_0074f56c,&DAT_00c7215c,0,0);
            if (DAT_00c7215c != (int *)0x0) {
              pcStack_28 = (char *)0x0;
              iVar1 = (**(code **)(*DAT_00c7215c + 0x1c))(0,&pcStack_28);
              if (iVar1 == 1) {
                (*(code *)**(undefined4 **)pcVar4)(0,0,0);
                if (DAT_00c721a8 == '\0') {
                  iVar1 = *(int *)pcVar4;
                  fVar2 = (float10)(**(code **)(*DAT_00c72160 + 0xe0))(0,0);
                  (**(code **)(iVar1 + 8))((float)fVar2);
                }
              }
              iVar1 = (**(code **)(*DAT_00c7215c + 0x24))(s_SkyWeather_0074f574,&DAT_00c72194);
              if (iVar1 == 0) {
                _DAT_00c72194 = 0;
              }
              iVar1 = (**(code **)(*DAT_00c7215c + 0x24))(s_RandomSky_0074f580,&DAT_00c72190);
              if (iVar1 == 0) {
                _DAT_00c72190 = 0;
              }
              iVar1 = (**(code **)(*DAT_00c7215c + 0x24))(s_SkySession_0074f58c,&DAT_00c721a0);
              if (iVar1 == 0) {
                _DAT_00c721a0 = 0;
              }
              iVar1 = (**(code **)(*DAT_00c7215c + 0x24))(s_Day_Night_0074f598,&DAT_00c72198);
              if (iVar1 == 0) {
                DAT_00c72198 = (undefined4 *)0x0;
              }
              else {
                uVar3 = 0x3f800000;
                if (param_2[0x30] == '\0') {
                  uVar3 = 0;
                }
                (**(code **)*DAT_00c72198)(uVar3);
              }
              (**(code **)(*DAT_00c72160 + 0x20))(DAT_00c7215c);
            }
            iVar1 = FUN_005d3eb0(s_horiz_3do_0074f5a4,&DAT_00c72158,0,0);
            if (iVar1 != 0) {
              pcStack_28 = (char *)0x0;
              iVar1 = (**(code **)(*DAT_00c72158 + 0x1c))(0,&pcStack_28);
              if (iVar1 == 1) {
                (*(code *)**(undefined4 **)pcVar4)(0,0,0);
                (*(code *)DAT_00c72188[2])(0,0,0);
              }
              iVar1 = (**(code **)(*DAT_00c72158 + 0x24))(s_SkyWeather_0074f5b0,&DAT_00c721a4);
              if (iVar1 == 0) {
                _DAT_00c721a4 = 0;
              }
              (**(code **)(*DAT_00c72160 + 0x1c))(DAT_00c72158);
              iVar1 = FUN_00573ab0();
              if (iVar1 != 0) {
                FUN_00567c60(DAT_00c72160);
                FUN_00587a10();
                return 1;
              }
              (**(code **)(*DAT_00c72158 + 4))();
              DAT_00c72158 = (int *)0x0;
            }
            if (DAT_00c7215c != (int *)0x0) {
              (**(code **)(*DAT_00c7215c + 4))();
              DAT_00c7215c = (int *)0x0;
            }
          }
          (**(code **)(*DAT_00c72160 + 4))();
          DAT_00c72160 = (int *)0x0;
        }
      }
    }
  }
  piStack_14 = (int *)0x573479;
  FUN_00573480();
  return 0;
}


