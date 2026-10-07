/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0052d700 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0052d700(int param_1)

{
  float *pfVar1;
  float fVar2;
  float fVar3;
  undefined4 unaff_EBX;
  undefined4 unaff_ESI;
  undefined4 unaff_EDI;
  float10 fVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 *puVar7;
  undefined1 *puVar8;
  undefined1 *puVar9;
  undefined4 uVar10;
  undefined1 *puVar11;
  undefined4 local_a0;
  undefined4 local_9c;
  undefined4 local_98;
  undefined4 local_94;
  undefined4 local_90;
  undefined4 local_8c;
  undefined4 local_88;
  undefined4 local_84;
  undefined4 local_80;
  undefined4 local_7c;
  undefined4 local_78;
  undefined4 local_74;
  undefined1 local_70 [8];
  float local_68;
  float local_5c;
  float local_50;
  float local_44;
  undefined1 local_40 [16];
  undefined1 local_30 [48];
  
  pfVar1 = (float *)(param_1 + 0x18aa);
  if ((*(byte *)(param_1 + 0x139f) & 0x10) == 0) {
    FUN_005f74a0(pfVar1,*(int *)(param_1 + 0x1a76) + 0x58);
  }
  else {
    *pfVar1 = *(float *)(param_1 + 0x1a92) + *(float *)(param_1 + 0x18a6);
  }
  puVar11 = local_40;
  puVar9 = local_70;
  uVar10 = 0;
  puVar8 = local_30;
  uVar5 = *(undefined4 *)(param_1 + 0x1a76);
  puVar7 = &local_a0;
  uVar6 = 4;
  local_a0 = 0x3fb33333;
  local_9c = 0x3f428f5c;
  local_98 = 0;
  local_94 = 0x3fb33333;
  local_90 = 0xbf428f5c;
  local_8c = 0;
  local_88 = 0xbfb33333;
  local_84 = 0x3f428f5c;
  local_80 = 0;
  local_7c = 0xbfb33333;
  local_78 = 0xbf428f5c;
  local_74 = 0;
  FUN_0051669a(uVar5,4,puVar7,puVar8,puVar9,0,puVar11);
  fVar2 = (local_5c + local_68) * _DAT_006ea44c;
  fVar3 = (local_44 + local_50) * _DAT_006ea44c;
  *(float *)(param_1 + 0x18d2) =
       (fVar3 + fVar2) * _DAT_006ea44c - *(float *)(*(int *)(param_1 + 0x1a76) + 0x30);
  fVar4 = (float10)FUN_006c6f60(uVar5,uVar6,puVar7,puVar8,puVar9,uVar10,puVar11,unaff_EDI,unaff_ESI,
                                unaff_EBX,fVar2,fVar3);
  fVar4 = fVar4 + (float10)*(float *)(param_1 + 0x18da);
  *(float *)(param_1 + 0x18d6) = (float)fVar4;
  *(float *)(param_1 + 0x18ca) = (float)fVar4;
  fVar4 = (float10)FUN_006c6f60();
  fVar4 = fVar4 + (float10)*(float *)(param_1 + 0x18e2);
  *(float *)(param_1 + 0x18de) = (float)fVar4;
  *(float *)(param_1 + 0x18ce) = (float)fVar4;
  FUN_005f5a90();
  fVar2 = -((_DAT_006e97d8 / _DAT_00b8f258) * *(float *)(param_1 + 0x1992) * _DAT_0074ab88) +
          *(float *)(param_1 + 0x18e6);
  *pfVar1 = fVar2 * *(float *)(param_1 + 0x1a96) + *pfVar1;
  *(float *)(param_1 + 0x18ca) = fVar2 * *(float *)(param_1 + 0x1a9a) + *(float *)(param_1 + 0x18ca)
  ;
  *(float *)(param_1 + 0x18ce) =
       (_DAT_006e97d8 / _DAT_00b8f258) * *(float *)(param_1 + 0x199e) * _DAT_0074aba0 +
       *(float *)(param_1 + 0x18ee) + *(float *)(param_1 + 0x18ea) + *(float *)(param_1 + 0x18ce);
  return;
}


