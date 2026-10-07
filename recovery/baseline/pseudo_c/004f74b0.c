/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004f74b0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_004f74b0(int param_1)

{
  float fVar1;
  int iVar2;
  float *pfVar3;
  float *pfVar4;
  float *pfVar5;
  undefined4 *puVar6;
  
  puVar6 = &DAT_00748544;
  do {
    FUN_004f6e10(*puVar6,1);
    puVar6 = puVar6 + -1;
  } while (0x748523 < (int)puVar6);
  iVar2 = FUN_005099b0();
  if ((iVar2 < 5) || (6 < iVar2)) {
    *(undefined4 *)(param_1 + 0x124) = 0x3f800000;
    *(undefined4 *)(param_1 + 0x11c) = 0x3f800000;
    *(undefined4 *)(param_1 + 0x120) = 0x3f800000;
  }
  else {
    fVar1 = *(float *)(param_1 + 0x5c) - _DAT_006e97d8;
    *(float *)(param_1 + 0x124) = _DAT_0074b3c8 * fVar1 + _DAT_006e97d8;
    *(float *)(param_1 + 0x11c) = _DAT_0074b3e0 * fVar1 + _DAT_006e97d8;
    *(float *)(param_1 + 0x120) = fVar1 * _DAT_0074b3f8 + _DAT_006e97d8;
  }
  switch(DAT_00bdbd00) {
  case 0:
    *(float *)(param_1 + 0x128) =
         (*(float *)(param_1 + 0x74) - _DAT_006e97d8) * _DAT_0074b428 + _DAT_006e97d8;
    break;
  case 1:
  case 2:
  case 3:
    *(float *)(param_1 + 0x128) =
         (*(float *)(param_1 + 0x80) - _DAT_006e97d8) * _DAT_0074b440 + _DAT_006e97d8;
    break;
  case 4:
    *(float *)(param_1 + 0x128) =
         (*(float *)(param_1 + 0x8c) - _DAT_006e97d8) * _DAT_0074b458 + _DAT_006e97d8;
    break;
  case 5:
    *(float *)(param_1 + 0x128) =
         (*(float *)(param_1 + 0x68) - _DAT_006e97d8) * _DAT_0074b410 + _DAT_006e97d8;
    break;
  default:
    *(undefined4 *)(param_1 + 0x128) = 0x3f800000;
  }
  *(undefined4 *)(param_1 + 0x158) = 0;
  *(undefined4 *)(param_1 + 0x15c) = 0;
  *(undefined4 *)(param_1 + 0x160) = 0;
  *(undefined4 *)(param_1 + 0x164) = 0;
  *(undefined4 *)(param_1 + 0x168) = 0;
  pfVar3 = (float *)&DAT_00748554;
  pfVar5 = (float *)(param_1 + 0xe4);
  do {
    pfVar4 = pfVar3 + 1;
    *pfVar5 = (_DAT_006e97d8 - (*(float *)(param_1 + 0xbc) - _DAT_006e97d8) * _DAT_006f3e30) *
              *pfVar3;
    pfVar3 = pfVar4;
    pfVar5 = pfVar5 + 1;
  } while ((int)pfVar4 < 0x748588);
  *(undefined4 *)(param_1 + 0x198) = 0;
  FUN_004f6e90();
  return;
}


