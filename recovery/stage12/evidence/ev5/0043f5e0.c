/* NR2003.exe @ 0043f5e0 FUN_0043f5e0 */

int FUN_0043f5e0(void)

{
  int iVar1;
  int iVar2;
  undefined4 local_8;
  undefined auStack_4 [4];
  
  iVar2 = 0;
  iVar1 = FUN_00445ef0();
  if (iVar1 != 0) {
    iVar1 = FUN_005cfdda(&local_8,s_controls_cfg_0072c6cc);
    if (iVar1 != 0) {
      iVar1 = FUN_005cfdd4(local_8,auStack_4,0x43434647,0);
      if (iVar1 != 0) {
        iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5e8,1);
        if (iVar1 != 0) {
          iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5e9,1);
          if (iVar1 != 0) {
            iVar1 = FUN_005cfd2c(local_8,&DAT_00894d38,4);
            if (iVar1 != 0) {
              iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5f0,4);
              if (iVar1 != 0) {
                iVar1 = FUN_005cfd2c(local_8,&DAT_00894e18,4);
                if (iVar1 != 0) {
                  iVar1 = FUN_005cfd2c(local_8,&DAT_00894e1c,4);
                  if (iVar1 != 0) {
                    iVar1 = FUN_005cfd2c(local_8,&DAT_00894e20,4);
                    if (iVar1 != 0) {
                      iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5f4,1);
                      if (iVar1 != 0) {
                        iVar1 = FUN_005cfd2c(local_8,&DAT_00894e24,1);
                        if (iVar1 != 0) {
                          iVar1 = FUN_005cfd2c(local_8,&DAT_00894d49,1);
                          if (iVar1 != 0) {
                            iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5ec,4);
                            if (iVar1 != 0) {
                              iVar1 = FUN_005cfd2c(local_8,&DAT_00894e10,4);
                              if (iVar1 != 0) {
                                iVar1 = FUN_005cfd2c(local_8,&DAT_00894e14,4);
                                if (iVar1 != 0) {
                                  iVar1 = FUN_005cfd2c(local_8,&DAT_0072c5f8,4);
                                  if (iVar1 != 0) {
                                    iVar1 = FUN_005d0da0(local_8);
                                    if (iVar1 != 0) {
                                      iVar1 = FUN_0057a6b0(local_8);
                                      if (iVar1 != 0) {
                                        iVar2 = 1;
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
              }
            }
          }
        }
        iVar1 = FUN_005cfdce(local_8,auStack_4);
        if (iVar1 == 0) {
          iVar2 = 0;
        }
      }
      iVar1 = FUN_005cfd08(local_8);
      if (iVar1 == 0) {
        FUN_005cfdc8(s_controls_cfg_0072c6dc);
        return 0;
      }
      if (iVar2 == 0) {
        FUN_005cfdc8(s_controls_cfg_0072c6dc);
      }
    }
  }
  return iVar2;
}

