/* NR2003.exe @ 0043f1d0 FUN_0043f1d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_0043f1d0(void)

{
  int iVar1;
  undefined4 uVar2;
  undefined4 local_10;
  int iStack_c;
  int iStack_8;
  undefined auStack_4 [4];
  
  DAT_00894e26 = 0;
  uVar2 = 0;
  iVar1 = FUN_00445ef0();
  if ((iVar1 != 0) && (iVar1 = FUN_005cfdc2(&local_10,s_controls_cfg_0072c6bc), iVar1 != 0)) {
    iVar1 = FUN_005cfdbc(&iStack_c,&iStack_8,auStack_4,local_10);
    if ((((iVar1 != 0) &&
         ((((iStack_c == 0x43434647 && (iStack_8 == 0)) &&
           (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d3c,1), iVar1 != 0)) &&
          ((iVar1 = FUN_005cfdb6(local_10,&DAT_00894d74,1), iVar1 != 0 &&
           (iVar1 = FUN_005cfdb6(local_10,&DAT_00894de4,4), iVar1 != 0)))))) &&
        (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d40,4), iVar1 != 0)) &&
       ((((iVar1 = FUN_005cfdb6(local_10,&DAT_00894dd8,4), iVar1 != 0 &&
          (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d7c,4), iVar1 != 0)) &&
         ((iVar1 = FUN_005cfdb6(local_10,&DAT_00894ddc,4), iVar1 != 0 &&
          (((iVar1 = FUN_005cfdb6(local_10,&DAT_00894d75,1), iVar1 != 0 &&
            (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d48,1), iVar1 != 0)) &&
           (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d80,1), iVar1 != 0)))))) &&
        (((iVar1 = FUN_005cfdb6(local_10,&DAT_00894de0,4), iVar1 != 0 &&
          (iVar1 = FUN_005cfdb6(local_10,&DAT_00894dac,4), iVar1 != 0)) &&
         ((iVar1 = FUN_005cfdb6(local_10,&DAT_00894d78,4), iVar1 != 0 &&
          (iVar1 = FUN_005cfdb6(local_10,&DAT_00894d44,4), iVar1 != 0)))))))) {
      if (DAT_00894d44 != DAT_0072c5f8) {
        FUN_005d0410();
        DAT_00894e25 = 0;
        FUN_005d03f0(DAT_00894d44 != 0);
      }
      iVar1 = FUN_005d0e20(local_10);
      if (iVar1 != 0) {
        DAT_00894e25 = 1;
      }
      iVar1 = FUN_0057a580(local_10);
      if (iVar1 == 0) {
        if (DAT_00894d44 != DAT_0072c5f8) {
          FUN_005d0410();
          DAT_00894e25 = 0;
          FUN_005d03f0(DAT_00894d44 != 0);
        }
      }
      else {
        DAT_00894e26 = DAT_00894e25;
        DAT_00894d38 = DAT_00894de4;
        DAT_0072c5e8 = DAT_00894d3c;
        DAT_0072c5e9 = DAT_00894d74;
        uVar2 = 1;
        if (DAT_00894d3c == '\0') {
          if (DAT_00894d74 == '\0') {
            uVar2 = 3;
          }
        }
        else {
          uVar2 = 0;
        }
        FUN_00570ec0(uVar2);
        iVar1 = DAT_00894d38;
        if ((DAT_00894d38 != 2) && (DAT_00894d38 != 1)) {
          iVar1 = 0;
        }
        FUN_00570ef0(iVar1);
        DAT_0072c5f0 = DAT_00894d40;
        FUN_00570f20((float)DAT_00894d40 * _DAT_006ea4a4);
        DAT_00894e18 = DAT_00894dd8;
        FUN_00570f50((float)DAT_00894dd8);
        DAT_00894e1c = DAT_00894d7c;
        FUN_00570f80((float)DAT_00894d7c);
        DAT_00894e20 = DAT_00894ddc;
        FUN_00570fb0((float)DAT_00894ddc);
        DAT_0072c5f4 = DAT_00894d75;
        FUN_00570fe0(DAT_00894d75);
        DAT_00894e24 = DAT_00894d48;
        FUN_00571010(DAT_00894d48);
        DAT_00894d49 = DAT_00894d80;
        FUN_00570e00(DAT_00894d80);
        DAT_0072c5ec = DAT_00894de0;
        FUN_00570e30((float)DAT_00894de0);
        DAT_00894e10 = DAT_00894dac;
        FUN_00570e60((float)DAT_00894dac);
        DAT_00894e14 = DAT_00894d78;
        FUN_00570e90((float)DAT_00894d78);
        uVar2 = 1;
        DAT_0072c5f8 = DAT_00894d44;
      }
    }
    FUN_005cfd08(local_10);
  }
  return uVar2;
}

