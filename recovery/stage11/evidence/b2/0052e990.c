/* NR2003.exe @ 0052e990 FUN_0052e990 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall
FUN_0052e990(int param_1_00,undefined4 param_1,int param_2,undefined4 param_3,float param_4)

{
  int iVar1;
  uint uVar2;
  undefined4 uVar3;
  int iVar4;
  float *local_64;
  float local_60;
  char local_58 [84];
  
  local_58[0] = '\0';
  uVar3 = *(undefined4 *)(param_1_00 + 0x5b2);
  iVar1 = FUN_00567630();
  switch(param_1) {
  case 1:
    iVar4 = FUN_006c5018();
    if (3 < iVar4) {
      iVar4 = 3;
    }
    FUN_0054b9b0(param_3,iVar4);
    *(undefined4 *)(param_1_00 + 0x1ca6) = 0x16;
    if (_DAT_006ea454 < _DAT_0074b7d0) {
      FUN_006c4f81(local_58,s_AIMECHFAIL__d__Suspension__wheel_0074bcd4,
                   *(undefined4 *)(param_1_00 + 0x1222),param_3,iVar4);
    }
    break;
  case 2:
    iVar4 = FUN_006c5018();
    if (3 < iVar4) {
      iVar4 = 3;
    }
    FUN_0054b970(param_3,iVar4);
    *(undefined4 *)(param_1_00 + 0x1ca6) = 0x18;
    if (_DAT_006ea454 < _DAT_0074b7d0) {
      FUN_006c4f81(local_58,s_AIMECHFAIL__d__Tire__wheel__d__d_0074bd04,
                   *(undefined4 *)(param_1_00 + 0x1222),param_3,iVar4);
    }
    break;
  case 3:
    if (param_2 == 8) {
      local_64 = (float *)(*(float *)(iVar1 + 0x54) + param_4);
      if (_DAT_006e97d8 < (float)local_64 != (NAN(_DAT_006e97d8) || NAN((float)local_64))) {
        local_64 = (float *)0x3f800000;
      }
      FUN_0054b800();
      *(undefined4 *)(param_1_00 + 0x1ca6) = 0xe;
      if (_DAT_006ea454 < _DAT_0074b7d0) {
        FUN_006c4f81(local_58,s_AIMECHFAIL__d__Fuel_leak__damage_0074bd30,
                     *(undefined4 *)(param_1_00 + 0x1222),(double)(float)local_64);
      }
    }
    else {
      local_64 = (float *)(*(float *)(iVar1 + 0x5c) + param_4);
      if (_DAT_006e97d8 < (float)local_64 != (NAN(_DAT_006e97d8) || NAN((float)local_64))) {
        local_64 = (float *)0x3f800000;
      }
      FUN_0054b880();
      iVar4 = FUN_006c5bf8();
      *(int *)(param_1_00 + 0x1ca6) = iVar4 % 3 + 0xf;
      if (_DAT_006ea454 < _DAT_0074b7d0) {
        FUN_006c4f81(local_58,s_AIMECHFAIL__d__Fuel_system__dama_0074bd58,
                     *(undefined4 *)(param_1_00 + 0x1222),(double)(float)local_64);
      }
    }
    break;
  case 4:
    local_64 = (float *)(*(float *)(iVar1 + 0x58) + param_4);
    if (_DAT_006e97d8 < (float)local_64 != (NAN(_DAT_006e97d8) || NAN((float)local_64))) {
      local_64 = (float *)0x3f800000;
    }
    FUN_0054b5a0();
    uVar2 = FUN_006c5bf8();
    uVar2 = uVar2 & 0x80000007;
    if ((int)uVar2 < 0) {
      uVar2 = (uVar2 - 1 | 0xfffffff8) + 1;
    }
    *(uint *)(param_1_00 + 0x1ca6) = uVar2 + 4;
    if (_DAT_006ea454 < _DAT_0074b7d0) {
      FUN_006c4f81(local_58,s_AIMECHFAIL__d__Engine__damage____0074bd80,
                   *(undefined4 *)(param_1_00 + 0x1222),(double)(float)local_64);
    }
    break;
  case 5:
    local_64 = (float *)(iVar1 + 0x3c);
    iVar4 = 0;
    do {
      local_60 = *local_64 + param_4;
      if (_DAT_006e97d8 < local_60 != (NAN(_DAT_006e97d8) || NAN(local_60))) {
        local_60 = 1.0;
      }
      FUN_0054b9f0(iVar4,local_60);
      iVar4 = iVar4 + 1;
      local_64 = local_64 + 1;
    } while (iVar4 < 4);
    *(undefined4 *)(param_1_00 + 0x1ca6) = 1;
    if (_DAT_006ea454 < _DAT_0074b7d0) {
      FUN_006c4f81(local_58,s_AIMECHFAIL__d__Brakes_0074bda4,*(undefined4 *)(param_1_00 + 0x1222));
    }
    break;
  case 6:
    if (param_2 == 8) {
      local_64 = (float *)(*(float *)(iVar1 + 0x50) + param_4);
      if (_DAT_006e97d8 < (float)local_64 != (NAN(_DAT_006e97d8) || NAN((float)local_64))) {
        local_64 = (float *)0x3f800000;
      }
      FUN_0054b900();
      *(undefined4 *)(param_1_00 + 0x1ca6) = 2;
      if (_DAT_006ea454 < _DAT_0074b7d0) {
        FUN_006c4f81(local_58,s_AIMECHFAIL__d__Coolant_leak__dam_0074bdbc,
                     *(undefined4 *)(param_1_00 + 0x1222),(double)(float)local_64);
      }
      break;
    }
  default:
LAB_0052ee13:
    FUN_00502460();
    break;
  case 7:
    if (param_2 == 8) {
      local_64 = (float *)(*(float *)(iVar1 + 0x4c) + param_4);
      if (_DAT_006e97d8 < (float)local_64 != (NAN(_DAT_006e97d8) || NAN((float)local_64))) {
        local_64 = (float *)0x3f800000;
      }
      FUN_0054b8c0();
      *(undefined4 *)(param_1_00 + 0x1ca6) = 0x12;
      if (_DAT_006ea454 < _DAT_0074b7d0) {
        FUN_006c4f81(local_58,s_AIMECHFAIL__d__Oil_leak__damage___0074bde8,
                     *(undefined4 *)(param_1_00 + 0x1222),(double)(float)local_64);
      }
      break;
    }
    goto LAB_0052ee13;
  }
  uVar3 = FUN_00567610(uVar3,iVar1);
  FUN_0052e270(uVar3,iVar1);
  FUN_00567660();
  FUN_0052e0a0();
  if ((_DAT_006ea454 < _DAT_0074b7d0) && (local_58[0] != '\0')) {
    FUN_004fabc0(1,local_58);
  }
  return;
}

