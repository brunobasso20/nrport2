/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00512dea */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_00512dea(int param_1,int param_2,int param_3)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  float fVar5;
  float fVar6;
  undefined1 uVar7;
  float local_48;
  float local_44;
  float local_40;
  float local_3c;
  float local_38;
  float local_34;
  float local_30;
  float local_2c;
  float local_28;
  float local_24;
  float local_20;
  float local_1c;
  float local_18;
  float local_14;
  float local_10;
  float local_c;
  float local_8;
  float local_4;
  
  fVar1 = *(float *)(param_1 + 0x58) * _DAT_006ea454;
  fVar2 = fVar1 + *(float *)(param_1 + 0x5c);
  fVar3 = fVar2 * _DAT_006ea454 + *(float *)(param_1 + 0x60);
  fVar4 = fVar3 * _DAT_006ea454 + *(float *)(param_1 + 100);
  fVar1 = ((fVar1 + fVar2) * _DAT_006ea454 + fVar3) * _DAT_006ea454 + fVar4;
  local_18 = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0x68);
  fVar2 = *(float *)(param_1 + 0x6c) * _DAT_006ea454;
  fVar3 = fVar2 + *(float *)(param_1 + 0x70);
  fVar4 = fVar3 * _DAT_006ea454 + *(float *)(param_1 + 0x74);
  fVar5 = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0x78);
  fVar2 = ((fVar2 + fVar3) * _DAT_006ea454 + fVar4) * _DAT_006ea454 + fVar5;
  local_14 = fVar5 * _DAT_006ea454 + *(float *)(param_1 + 0x7c);
  fVar3 = *(float *)(param_1 + 0x80) * _DAT_006ea454;
  fVar4 = fVar3 + *(float *)(param_1 + 0x84);
  fVar5 = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0x88);
  fVar6 = fVar5 * _DAT_006ea454 + *(float *)(param_1 + 0x8c);
  fVar3 = ((fVar3 + fVar4) * _DAT_006ea454 + fVar5) * _DAT_006ea454 + fVar6;
  local_10 = fVar6 * _DAT_006ea454 + *(float *)(param_1 + 0x90);
  local_3c = (((*(float *)(param_1 + 0xd0) * _DAT_006ea454 + *(float *)(param_1 + 0xd4)) *
               _DAT_006ea454 + *(float *)(param_1 + 0xd8)) * _DAT_006ea454 +
             *(float *)(param_1 + 0xdc)) * _DAT_006ea454 + *(float *)(param_1 + 0xe0);
  local_38 = (((*(float *)(param_1 + 0xe4) * _DAT_006ea454 + *(float *)(param_1 + 0xe8)) *
               _DAT_006ea454 + *(float *)(param_1 + 0xec)) * _DAT_006ea454 +
             *(float *)(param_1 + 0xf0)) * _DAT_006ea454 + *(float *)(param_1 + 0xf4);
  local_34 = *(float *)(param_1 + 0x104) * _DAT_006ea454 + *(float *)(param_1 + 0x100);
  local_48 = local_38 * fVar3 - fVar2 * local_34;
  local_44 = fVar1 * local_34 - local_3c * fVar3;
  local_40 = local_3c * fVar2 - local_38 * fVar1;
  FUN_005f6a70(&local_48);
  local_48 = local_48 - *(float *)(param_2 + 0x20);
  local_44 = local_44 - *(float *)(param_2 + 0x24);
  local_40 = local_40 - *(float *)(param_2 + 0x28);
  FUN_005f6a70(&local_48);
  *(float *)(param_1 + 0x10) = local_48;
  *(float *)(param_1 + 0x14) = local_44;
  *(float *)(param_1 + 0x18) = local_40;
  *(float *)(param_1 + 0x1c) = -(local_18 * local_48 + local_14 * local_44 + local_10 * local_40);
  fVar1 = *(float *)(param_1 + 0x94) * _DAT_006ea454;
  fVar2 = fVar1 + *(float *)(param_1 + 0x98);
  fVar3 = fVar2 * _DAT_006ea454 + *(float *)(param_1 + 0x9c);
  fVar4 = fVar3 * _DAT_006ea454 + *(float *)(param_1 + 0xa0);
  fVar1 = ((fVar2 + fVar1) * _DAT_006ea454 + fVar3) * _DAT_006ea454 + fVar4;
  local_c = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0xa4);
  fVar2 = *(float *)(param_1 + 0xa8) * _DAT_006ea454;
  fVar3 = fVar2 + *(float *)(param_1 + 0xac);
  fVar4 = fVar3 * _DAT_006ea454 + *(float *)(param_1 + 0xb0);
  fVar5 = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0xb4);
  fVar2 = ((fVar3 + fVar2) * _DAT_006ea454 + fVar4) * _DAT_006ea454 + fVar5;
  local_8 = fVar5 * _DAT_006ea454 + *(float *)(param_1 + 0xb8);
  fVar3 = *(float *)(param_1 + 0xbc) * _DAT_006ea454;
  fVar4 = fVar3 + *(float *)(param_1 + 0xc0);
  fVar5 = fVar4 * _DAT_006ea454 + *(float *)(param_1 + 0xc4);
  fVar6 = fVar5 * _DAT_006ea454 + *(float *)(param_1 + 200);
  fVar3 = ((fVar4 + fVar3) * _DAT_006ea454 + fVar5) * _DAT_006ea454 + fVar6;
  local_4 = fVar6 * _DAT_006ea454 + *(float *)(param_1 + 0xcc);
  local_48 = fVar2 * local_34 - local_38 * fVar3;
  local_44 = local_3c * fVar3 - fVar1 * local_34;
  local_40 = local_38 * fVar1 - local_3c * fVar2;
  FUN_005f6a70(&local_48);
  local_48 = local_48 - *(float *)(param_2 + 0x20);
  local_44 = local_44 - *(float *)(param_2 + 0x24);
  local_40 = local_40 - *(float *)(param_2 + 0x28);
  FUN_005f6a70(&local_48);
  *(float *)(param_1 + 0x20) = local_48;
  *(float *)(param_1 + 0x24) = local_44;
  *(float *)(param_1 + 0x28) = local_40;
  *(float *)(param_1 + 0x2c) = -(local_c * local_48 + local_8 * local_44 + local_4 * local_40);
  fVar1 = *(float *)(param_1 + 0x5c) + *(float *)(param_1 + 0x58);
  fVar2 = fVar1 + *(float *)(param_1 + 0x60);
  local_30 = fVar2 + *(float *)(param_1 + 100);
  fVar1 = local_30 + fVar2 + fVar1 + *(float *)(param_1 + 0x58);
  local_30 = local_30 + *(float *)(param_1 + 0x68);
  fVar2 = *(float *)(param_1 + 0x70) + *(float *)(param_1 + 0x6c);
  fVar3 = fVar2 + *(float *)(param_1 + 0x74);
  local_2c = fVar3 + *(float *)(param_1 + 0x78);
  fVar2 = local_2c + fVar3 + fVar2 + *(float *)(param_1 + 0x6c);
  local_2c = local_2c + *(float *)(param_1 + 0x7c);
  fVar3 = *(float *)(param_1 + 0x84) + *(float *)(param_1 + 0x80);
  fVar4 = fVar3 + *(float *)(param_1 + 0x88);
  local_28 = fVar4 + *(float *)(param_1 + 0x8c);
  fVar3 = local_28 + fVar4 + fVar3 + *(float *)(param_1 + 0x80);
  local_28 = local_28 + *(float *)(param_1 + 0x90);
  local_3c = *(float *)(param_1 + 0xd4) + *(float *)(param_1 + 0xd0) + *(float *)(param_1 + 0xd8) +
             *(float *)(param_1 + 0xdc) + *(float *)(param_1 + 0xe0);
  local_38 = *(float *)(param_1 + 0xe8) + *(float *)(param_1 + 0xe4) + *(float *)(param_1 + 0xec) +
             *(float *)(param_1 + 0xf0) + *(float *)(param_1 + 0xf4);
  local_34 = *(float *)(param_1 + 0x104) + *(float *)(param_1 + 0x100);
  local_48 = local_38 * fVar3 - fVar2 * local_34;
  local_44 = fVar1 * local_34 - local_3c * fVar3;
  local_40 = local_3c * fVar2 - local_38 * fVar1;
  FUN_005f6a70(&local_48);
  local_48 = local_48 + *(float *)(param_3 + 0x20);
  local_44 = local_44 + *(float *)(param_3 + 0x24);
  local_40 = local_40 + *(float *)(param_3 + 0x28);
  FUN_005f6a70(&local_48);
  *(float *)(param_1 + 0x30) = local_48;
  *(float *)(param_1 + 0x34) = local_44;
  *(float *)(param_1 + 0x38) = local_40;
  *(float *)(param_1 + 0x3c) = -(local_30 * local_48 + local_2c * local_44 + local_28 * local_40);
  fVar1 = *(float *)(param_1 + 0x98) + *(float *)(param_1 + 0x94);
  fVar2 = fVar1 + *(float *)(param_1 + 0x9c);
  local_24 = fVar2 + *(float *)(param_1 + 0xa0);
  fVar1 = local_24 + fVar2 + fVar1 + *(float *)(param_1 + 0x94);
  local_24 = local_24 + *(float *)(param_1 + 0xa4);
  fVar2 = *(float *)(param_1 + 0xac) + *(float *)(param_1 + 0xa8);
  fVar3 = fVar2 + *(float *)(param_1 + 0xb0);
  local_20 = fVar3 + *(float *)(param_1 + 0xb4);
  fVar2 = local_20 + fVar3 + fVar2 + *(float *)(param_1 + 0xa8);
  local_20 = local_20 + *(float *)(param_1 + 0xb8);
  fVar3 = *(float *)(param_1 + 0xc0) + *(float *)(param_1 + 0xbc);
  fVar4 = fVar3 + *(float *)(param_1 + 0xc4);
  local_1c = fVar4 + *(float *)(param_1 + 200);
  fVar3 = local_1c + fVar4 + fVar3 + *(float *)(param_1 + 0xbc);
  local_1c = local_1c + *(float *)(param_1 + 0xcc);
  local_48 = fVar2 * local_34 - local_38 * fVar3;
  local_44 = local_3c * fVar3 - fVar1 * local_34;
  local_40 = local_38 * fVar1 - local_3c * fVar2;
  FUN_005f6a70(&local_48);
  local_48 = local_48 + *(float *)(param_3 + 0x20);
  local_44 = local_44 + *(float *)(param_3 + 0x24);
  local_40 = local_40 + *(float *)(param_3 + 0x28);
  FUN_005f6a70(&local_48);
  *(float *)(param_1 + 0x40) = local_48;
  *(float *)(param_1 + 0x44) = local_44;
  *(float *)(param_1 + 0x48) = local_40;
  fVar1 = -(local_24 * local_48 + local_20 * local_44 + local_1c * local_40);
  *(float *)(param_1 + 0x4c) = fVar1;
  if ((_DAT_006ea454 <=
       local_30 * *(float *)(param_1 + 0x10) +
       local_2c * *(float *)(param_1 + 0x14) + local_28 * *(float *)(param_1 + 0x18) +
       *(float *)(param_1 + 0x1c)) ||
     (_DAT_006ea454 <=
      local_24 * *(float *)(param_1 + 0x10) +
      local_20 * *(float *)(param_1 + 0x14) + local_1c * *(float *)(param_1 + 0x18) +
      *(float *)(param_1 + 0x1c))) {
    uVar7 = 0;
  }
  else {
    uVar7 = 1;
  }
  *(undefined1 *)(param_1 + 0xc) = uVar7;
  if ((_DAT_006ea454 <=
       local_30 * *(float *)(param_1 + 0x20) +
       local_2c * *(float *)(param_1 + 0x24) + local_28 * *(float *)(param_1 + 0x28) +
       *(float *)(param_1 + 0x2c)) ||
     (_DAT_006ea454 <=
      local_24 * *(float *)(param_1 + 0x20) +
      local_20 * *(float *)(param_1 + 0x24) + local_1c * *(float *)(param_1 + 0x28) +
      *(float *)(param_1 + 0x2c))) {
    uVar7 = 0;
  }
  else {
    uVar7 = 1;
  }
  *(undefined1 *)(param_1 + 0xd) = uVar7;
  if ((_DAT_006ea454 <=
       local_18 * *(float *)(param_1 + 0x30) +
       local_14 * *(float *)(param_1 + 0x34) + local_10 * *(float *)(param_1 + 0x38) +
       *(float *)(param_1 + 0x3c)) ||
     (_DAT_006ea454 <=
      local_c * *(float *)(param_1 + 0x30) +
      local_8 * *(float *)(param_1 + 0x34) + local_4 * *(float *)(param_1 + 0x38) +
      *(float *)(param_1 + 0x3c))) {
    uVar7 = 0;
  }
  else {
    uVar7 = 1;
  }
  *(undefined1 *)(param_1 + 0xe) = uVar7;
  if ((local_18 * *(float *)(param_1 + 0x40) +
       local_14 * *(float *)(param_1 + 0x44) + local_10 * *(float *)(param_1 + 0x48) + fVar1 <
       _DAT_006ea454) &&
     (local_c * *(float *)(param_1 + 0x40) +
      local_8 * *(float *)(param_1 + 0x44) + local_4 * *(float *)(param_1 + 0x48) + fVar1 <
      _DAT_006ea454)) {
    *(undefined1 *)(param_1 + 0xf) = 1;
    return;
  }
  *(undefined1 *)(param_1 + 0xf) = 0;
  return;
}


