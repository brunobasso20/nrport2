/* NR2003.exe @ 005a2db0 FUN_005a2db0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005a2db0(int param_1,int param_2)

{
  float fVar1;
  char cVar2;
  undefined4 uVar3;
  int iVar4;
  uint uVar5;
  uint uVar6;
  float10 fVar7;
  float10 fVar8;
  int local_c;
  int local_8;
  int local_4;
  
  fVar7 = (float10)FUN_005beaf0(&DAT_00e0b6c0,*(uint *)(param_2 + 0x3c) >> 0x13 & 0x3ff);
  fVar8 = (float10)FUN_005beaf0(&DAT_00e0b704,(*(ushort *)(param_2 + 2) & 0x7c00) >> 10);
  cVar2 = FUN_005a1980();
  if (cVar2 != '\0') {
    uVar3 = FUN_005a19a0();
    iVar4 = FUN_005ceb90(*(ushort *)(param_2 + 2) & 0x3ff,uVar3);
    if (0 < iVar4) {
      fVar1 = _DAT_006e97d8 / (float)iVar4;
      *(float *)(param_1 + 0x150c) = ((float)fVar7 - *(float *)(param_1 + 0x1508)) * fVar1;
      *(float *)(param_1 + 0x1514) = ((float)fVar8 - *(float *)(param_1 + 0x1510)) * fVar1;
      goto LAB_005a2e7b;
    }
  }
  *(float *)(param_1 + 0x1508) = (float)fVar7;
  *(undefined4 *)(param_1 + 0x150c) = 0;
  *(float *)(param_1 + 0x1510) = (float)fVar8;
  *(undefined4 *)(param_1 + 0x1514) = 0;
LAB_005a2e7b:
  uVar6 = *(uint *)(param_1 + 0x14fc);
  uVar5 = (*(uint *)(param_2 + 0x3c) >> 0xe ^ uVar6) & 7 ^ uVar6;
  *(uint *)(param_1 + 0x14fc) = uVar5;
  *(uint *)(param_1 + 0x14fc) =
       (*(ushort *)(param_2 + 2) & 0x8000) >> 0xc ^
       CONCAT31((int3)(uVar6 >> 8),(char)uVar5) & 0xffffffe7;
  fVar7 = (float10)FUN_005beaf0(&DAT_00e0b6dc,(*(int *)(param_2 + 0x3c) << 0x12) >> 0x19);
  *(float *)(param_1 + 0x1554) = (float)fVar7;
  FUN_005a2f30(&local_c,&local_8,&local_4,*(uint *)(param_2 + 0x3c) >> 0x11 & 3);
  uVar6 = (local_c << 5 ^ *(uint *)(param_1 + 0x14fc)) & 0x20 ^ *(uint *)(param_1 + 0x14fc);
  *(undefined *)(param_1 + 0x14fb) = 1;
  uVar6 = (local_8 << 6 ^ uVar6) & 0x40 ^ uVar6;
  *(uint *)(param_1 + 0x14fc) = (local_4 << 7 ^ uVar6) & 0x80 ^ uVar6;
  return;
}

