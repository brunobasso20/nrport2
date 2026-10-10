/* NR2003.exe @ 0049d900 FUN_0049d900 */

undefined4 __fastcall FUN_0049d900(int param_1)

{
  undefined uVar1;
  char cVar2;
  undefined4 uVar3;
  uint uVar4;
  int iVar5;
  float10 fVar6;
  int local_4;
  
  local_4 = param_1;
  uVar3 = FUN_0043ef10();
  *(undefined4 *)(param_1 + 0x129) = uVar3;
  *(undefined *)(param_1 + 0x131) = 0;
  uVar1 = FUN_0043ef70();
  *(undefined *)(param_1 + 0x132) = uVar1;
  uVar3 = FUN_0043ef90();
  *(undefined4 *)(param_1 + 0x133) = uVar3;
  uVar3 = FUN_0043efe0();
  *(undefined4 *)(param_1 + 0x137) = uVar3;
  uVar3 = FUN_0043f030();
  *(undefined4 *)(param_1 + 0x13b) = uVar3;
  uVar3 = FUN_0043f180();
  *(undefined4 *)(param_1 + 0x12d) = uVar3;
  iVar5 = 0;
  do {
    uVar1 = FUN_00441670(iVar5);
    *(undefined *)(param_1 + 0x30d + iVar5) = uVar1;
    iVar5 = iVar5 + 1;
  } while (iVar5 < 5);
  iVar5 = 0;
  do {
    uVar1 = FUN_004416f0(iVar5);
    *(undefined *)(param_1 + 0x312 + iVar5) = uVar1;
    iVar5 = iVar5 + 1;
  } while (iVar5 < 6);
  iVar5 = 0;
  do {
    uVar1 = FUN_00441750(iVar5);
    *(undefined *)(param_1 + 0x318 + iVar5) = uVar1;
    iVar5 = iVar5 + 1;
  } while (iVar5 < 4);
  uVar3 = FUN_004417b0();
  *(undefined4 *)(param_1 + 0x31d) = uVar3;
  uVar3 = FUN_00441860();
  *(undefined4 *)(param_1 + 0x321) = uVar3;
  uVar3 = FUN_00441900();
  *(undefined4 *)(param_1 + 0x325) = uVar3;
  fVar6 = (float10)FUN_00441c10();
  *(float *)(param_1 + 0x332) = (float)fVar6;
  uVar3 = FUN_004419a0();
  *(undefined4 *)(param_1 + 0x32a) = uVar3;
  uVar3 = FUN_004419e0();
  *(undefined4 *)(param_1 + 0x32e) = uVar3;
  uVar3 = FUN_00441a20();
  *(undefined4 *)(param_1 + 0x33f) = uVar3;
  uVar3 = FUN_00441ae0();
  *(undefined4 *)(param_1 + 0x343) = uVar3;
  uVar3 = FUN_00441b20();
  *(undefined4 *)(param_1 + 0x347) = uVar3;
  uVar3 = FUN_00441a80();
  *(undefined4 *)(param_1 + 0x34b) = uVar3;
  uVar3 = FUN_00441650();
  *(undefined4 *)(param_1 + 0x34f) = uVar3;
  uVar3 = FUN_00441c30();
  *(undefined4 *)(param_1 + 0x336) = uVar3;
  uVar3 = FUN_00441c50();
  *(undefined4 *)(param_1 + 0x33a) = uVar3;
  uVar1 = FUN_00441c70();
  *(undefined *)(param_1 + 0x33e) = uVar1;
  uVar1 = FUN_00441b80();
  *(undefined *)(param_1 + 0x35f) = uVar1;
  uVar1 = FUN_00441ba0();
  *(undefined *)(param_1 + 0x360) = uVar1;
  uVar1 = FUN_00441bc0();
  *(undefined *)(param_1 + 0x361) = uVar1;
  uVar3 = FUN_00441df0();
  *(undefined4 *)(param_1 + 0x362) = uVar3;
  local_4 = 0x40;
  FUN_00441e20(&local_4);
  *(int *)(param_1 + 0x366) = local_4;
  iVar5 = FUN_00441db0();
  *(bool *)(param_1 + 0x36a) = iVar5 != 0;
  uVar4 = FUN_00441dc0();
  *(byte *)(param_1 + 0x36b) = (byte)(uVar4 >> 1) & 1;
  uVar1 = FUN_00441dd0();
  *(undefined *)(param_1 + 0x36c) = uVar1;
  uVar4 = FUN_0043ef30();
  *(uint *)(param_1 + 0x13f) = uVar4 & 0xff;
  uVar4 = FUN_0043ef50();
  *(uint *)(param_1 + 0x143) = uVar4 & 0xff;
  uVar4 = FUN_00442ff0();
  *(uint *)(param_1 + 0x147) = uVar4 & 0xff;
  uVar4 = FUN_00443010();
  *(uint *)(param_1 + 0x14b) = uVar4 & 0xff;
  uVar4 = FUN_00443030();
  *(undefined *)(param_1 + 0x153) = 1;
  *(uint *)(param_1 + 0x14f) = uVar4 & 0xff;
  *(undefined *)(param_1 + 0x154) = 1;
  uVar1 = FUN_00442fb0();
  *(undefined *)(param_1 + 0x156) = uVar1;
  uVar1 = FUN_00442fd0();
  *(undefined *)(param_1 + 0x155) = uVar1;
  uVar1 = FUN_00441b60();
  *(undefined *)(param_1 + 0x474) = uVar1;
  uVar4 = FUN_00443f70();
  *(uint *)(param_1 + 0x475) = uVar4 & 0xff;
  uVar4 = FUN_00443070();
  *(uint *)(param_1 + 0x353) = uVar4 & 0xff;
  uVar4 = FUN_00443090();
  *(uint *)(param_1 + 0x357) = uVar4 & 0xff;
  uVar3 = FUN_00443140();
  *(undefined4 *)(param_1 + 0x35b) = uVar3;
  uVar3 = FUN_00443dc0();
  *(undefined4 *)(param_1 + 0x40a) = uVar3;
  uVar3 = FUN_00443e10(1);
  *(undefined4 *)(param_1 + 0x40e) = uVar3;
  uVar3 = FUN_00443e10(2);
  *(undefined4 *)(param_1 + 0x412) = uVar3;
  uVar3 = FUN_00443e10(3);
  *(undefined4 *)(param_1 + 0x416) = uVar3;
  uVar3 = FUN_00443e10(4);
  *(undefined4 *)(param_1 + 0x41a) = uVar3;
  uVar3 = FUN_00443e10(5);
  *(undefined4 *)(param_1 + 0x41e) = uVar3;
  uVar3 = FUN_00443e10(6);
  *(undefined4 *)(param_1 + 0x422) = uVar3;
  uVar3 = FUN_00443e10(8);
  *(undefined4 *)(param_1 + 0x426) = uVar3;
  uVar3 = FUN_00443e70();
  *(undefined4 *)(param_1 + 0x42a) = uVar3;
  iVar5 = FUN_00443d40();
  *(bool *)(param_1 + 0x42e) = iVar5 != 0;
  iVar5 = FUN_00443d80();
  *(bool *)(param_1 + 0x42f) = iVar5 == 2;
  uVar3 = FUN_00443ed0();
  *(undefined4 *)(param_1 + 0x46c) = uVar3;
  uVar3 = FUN_00443f30();
  *(undefined4 *)(param_1 + 0x470) = uVar3;
  *(undefined *)(param_1 + 0x15b) = 0;
  cVar2 = FUN_0043f830();
  if (cVar2 == '\0') {
    FUN_0060a670(2);
    FUN_004a23b0(2);
    iVar5 = FUN_005d0420();
    if (iVar5 < 1) {
      FUN_005d0410();
      uVar4 = (uint)(*(int *)(param_1 + 0x12d) == 0);
      *(uint *)(param_1 + 0x12d) = uVar4;
      FUN_005d03f0(uVar4 != 0);
      iVar5 = FUN_005d0420();
      if (0 < iVar5) {
        FUN_00570cd0();
        *(undefined *)(param_1 + 0x15b) = 1;
      }
      FUN_0043f1a0(uVar4);
    }
    else {
      *(undefined *)(param_1 + 0x15b) = 1;
    }
  }
  *(undefined *)(param_1 + 0x15c) = 0;
  *(undefined *)(param_1 + 0x329) = 0;
  *(undefined *)(param_1 + 0x479) = 0;
  *(undefined *)(param_1 + 0x58) = 0;
  return 1;
}

