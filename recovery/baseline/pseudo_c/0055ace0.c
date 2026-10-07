/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055ace0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0055ace0(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  char local_29;
  int local_28;
  undefined4 local_24;
  undefined1 local_20 [31];
  undefined1 local_1;
  
  uVar2 = FUN_005c2d40(DAT_00c08194);
  switch(uVar2) {
  case 2:
    FUN_005b5cb0(DAT_00c08194);
    iVar3 = FUN_0055a5a0();
    if (iVar3 != 2) {
      return;
    }
    uVar2 = FUN_0055a5c0();
    switch(uVar2) {
    case 0:
      cVar1 = FUN_006262b0();
      if (cVar1 != '\0') {
        iVar3 = taskGetRate();
        _DAT_00c06d3a = getIntCount();
        _DAT_00c06d3a = _DAT_00c06d3a + iVar3 * 0x78;
        FUN_0055a5b0(1);
        return;
      }
      uVar2 = FUN_0061cdf0(0xf,0);
      FUN_00619640(local_20,0x20,uVar2);
      break;
    case 1:
      FUN_005c2fb0(DAT_00c08194);
      cVar1 = FUN_00626320(&local_24,&local_28,&local_29);
      if (cVar1 != '\0') {
        if (local_29 == '\0') {
          if (local_28 == 0) {
            FUN_0055a5b0(2);
          }
          else {
            iVar3 = FUN_005c38b0(DAT_00c08194,0x45,local_28,local_24);
            if (iVar3 != 0) {
              FUN_00626380();
            }
          }
        }
        else {
          uVar2 = FUN_0061cdf0(0x10,0);
          FUN_00619640(local_20,0x20,uVar2);
          local_1 = 0;
          FUN_0055c800(4,local_20);
          FUN_005cfeb8();
          FUN_0055a4f0(6);
        }
      }
      iVar3 = getIntCount();
      if (iVar3 <= _DAT_00c06d3a) {
        return;
      }
      uVar2 = FUN_0061cdf0(0x10,0);
      FUN_00619640(local_20,0x20,uVar2);
      local_1 = 0;
      break;
    case 2:
      uVar2 = FUN_0055aaf0();
      iVar3 = FUN_005c38b0(DAT_00c08194,3,0xe6,uVar2);
      if (iVar3 == 0) {
        return;
      }
      FUN_0055a5b0(3);
      return;
    case 3:
      FUN_005c2fb0(DAT_00c08194);
      return;
    default:
      goto switchD_0055ad24_caseD_4;
    }
    FUN_0055c800(4,local_20);
    FUN_005cfeb8();
  case 0:
  case 3:
  case 4:
    FUN_0055a4f0(6);
  default:
switchD_0055ad24_caseD_4:
    return;
  }
}


