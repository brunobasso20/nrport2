/* NR2003.exe @ 0043d0f0 FUN_0043d0f0 */

uint __fastcall FUN_0043d0f0(int param_1)

{
  undefined *puVar1;
  uint in_EAX;
  undefined **ppuVar2;
  
  if ((((*(int *)(param_1 + 4) != 0) &&
       (in_EAX = FUN_005fbd80(param_1 + 0x1d,s_btnUpSterngMomt_0072710c), (char)in_EAX != '\0')) &&
      (in_EAX = FUN_005fbd80(param_1 + 0x21,s_btnDnSterngMomt_0072711c), (char)in_EAX != '\0')) &&
     (in_EAX = FUN_005fbf80(param_1 + 0x25,s_txtSterngMomt_0072712c), (char)in_EAX != '\0')) {
    in_EAX = FUN_005fc1c0((int **)(param_1 + 0x29),s_sliSterngMomt_0072713c);
    if ((char)in_EAX != '\0') {
      (**(code **)(**(int **)(param_1 + 0x29) + 0x90))(0,0,100);
      FUN_0043d4f0();
      in_EAX = FUN_005fbd80(param_1 + 0x2d,s_btnUpThrotMomt_0072714c);
      if ((((char)in_EAX != '\0') &&
          (in_EAX = FUN_005fbd80(param_1 + 0x31,s_btnDnThrotMomt_0072715c), (char)in_EAX != '\0'))
         && (in_EAX = FUN_005fbf80(param_1 + 0x35,s_txtThrotMomt_0072716c), (char)in_EAX != '\0')) {
        in_EAX = FUN_005fc1c0((int **)(param_1 + 0x39),s_sliThrotMomt_0072717c);
        if ((char)in_EAX != '\0') {
          (**(code **)(**(int **)(param_1 + 0x39) + 0x90))(0,0,100);
          FUN_0043d5c0();
          in_EAX = FUN_005fbd80(param_1 + 0x3d,s_btnUpBrkMomt_0072718c);
          if ((((char)in_EAX != '\0') &&
              (in_EAX = FUN_005fbd80(param_1 + 0x41,s_btnDnBrkMomt_0072719c), (char)in_EAX != '\0'))
             && (in_EAX = FUN_005fbf80(param_1 + 0x45,s_txtBrkMomt_007271ac), (char)in_EAX != '\0'))
          {
            in_EAX = FUN_005fc1c0((int **)(param_1 + 0x49),s_sliBrkMomt_007271b8);
            if ((char)in_EAX != '\0') {
              (**(code **)(**(int **)(param_1 + 0x49) + 0x90))(0,0,100);
              FUN_0043d690();
              in_EAX = FUN_005fbd80(param_1 + 0x4d,s_btnUpSterngAsst_007271c4);
              if ((((char)in_EAX != '\0') &&
                  (in_EAX = FUN_005fbd80(param_1 + 0x51,s_btnDnSterngAsst_007271d4),
                  (char)in_EAX != '\0')) &&
                 (in_EAX = FUN_005fbf80(param_1 + 0x55,s_txtSterngAsst_007271e4),
                 (char)in_EAX != '\0')) {
                in_EAX = FUN_005fc1c0((int **)(param_1 + 0x59),s_sliSterngAsst_007271f4);
                if ((char)in_EAX != '\0') {
                  (**(code **)(**(int **)(param_1 + 0x59) + 0x90))(0,0,100);
                  FUN_0043d760();
                  in_EAX = FUN_005fbd80(param_1 + 0x5d,s_btnUpSterngLin_00727204);
                  if ((((char)in_EAX != '\0') &&
                      (in_EAX = FUN_005fbd80(param_1 + 0x61,s_btnDnSterngLin_00727214),
                      (char)in_EAX != '\0')) &&
                     (in_EAX = FUN_005fbf80(param_1 + 0x65,s_txtSterngLin_00727224),
                     (char)in_EAX != '\0')) {
                    in_EAX = FUN_005fc1c0((int **)(param_1 + 0x69),s_sliSterngLin_00727234);
                    if ((char)in_EAX != '\0') {
                      (**(code **)(**(int **)(param_1 + 0x69) + 0x90))(0,0,100);
                      FUN_0043d830();
                      in_EAX = FUN_005fbe20(param_1 + 0x6d,s_chkSterngRatio_00727244);
                      if (((char)in_EAX != '\0') &&
                         (in_EAX = FUN_005fbe20(param_1 + 0x71,s_chkAnyDrivingKeys_00727254),
                         (char)in_EAX != '\0')) {
                        ppuVar2 = &PTR_s_btnUpSterngMomt_006eebf0;
                        puVar1 = PTR_s_btnUpSterngMomt_006eebf0;
                        while( true ) {
                          if (puVar1 == (undefined *)0x0) {
                            return 1;
                          }
                          in_EAX = FUN_0043d3e0(ppuVar2);
                          if (in_EAX != 1) break;
                          puVar1 = ppuVar2[2];
                          ppuVar2 = ppuVar2 + 2;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return in_EAX & 0xffffff00;
}

