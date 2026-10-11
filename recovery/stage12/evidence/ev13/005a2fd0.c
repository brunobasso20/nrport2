/* NR2003.exe @ 005a2fd0 FUN_005a2fd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005a2fd0(int param_1,ushort *param_2)

{
  float fVar1;
  int iVar2;
  ushort *puVar3;
  char cVar4;
  undefined4 uVar5;
  uint uVar6;
  uint uVar7;
  float10 fVar8;
  float local_4;
  
  puVar3 = param_2;
  fVar8 = (float10)FUN_005beaf0(&DAT_00e0b6c0,*(uint *)(param_2 + 4) >> 10 & 0x3ff);
  param_2 = (ushort *)(float)fVar8;
  fVar8 = (float10)FUN_005beaf0(&DAT_00e0b704,*puVar3 >> 0xb);
  iVar2 = param_1;
  local_4 = (float)fVar8;
  cVar4 = FUN_005a1980();
  if (cVar4 != '\0') {
    uVar5 = FUN_005a19a0();
    param_1 = FUN_005ceb90(*puVar3 >> 1 & 0x3ff,uVar5);
    if (0 < param_1) {
      fVar1 = _DAT_006e97d8 / (float)param_1;
      *(float *)(iVar2 + 0x150c) = ((float)param_2 - *(float *)(iVar2 + 0x1508)) * fVar1;
      *(float *)(iVar2 + 0x1514) = (local_4 - *(float *)(iVar2 + 0x1510)) * fVar1;
      goto LAB_005a3098;
    }
  }
  *(ushort **)(iVar2 + 0x1508) = param_2;
  *(undefined4 *)(iVar2 + 0x150c) = 0;
  *(float *)(iVar2 + 0x1510) = local_4;
  *(undefined4 *)(iVar2 + 0x1514) = 0;
LAB_005a3098:
  uVar7 = *(uint *)(iVar2 + 0x14fc);
  uVar6 = (*(uint *)(puVar3 + 6) >> 0x1d ^ uVar7) & 7 ^ uVar7;
  *(uint *)(iVar2 + 0x14fc) = uVar6;
  *(uint *)(iVar2 + 0x14fc) =
       *(uint *)(puVar3 + 2) >> 0x1c & 8 | CONCAT31((int3)(uVar7 >> 8),(char)uVar6) & 0xffffffe7;
  fVar8 = (float10)FUN_005beaf0(&DAT_00e0b6dc,(int)(short)puVar3[1] >> 10);
  *(float *)(iVar2 + 0x1554) = (float)fVar8;
  FUN_005a2f30(&param_2,&param_1,&local_4,*(uint *)(puVar3 + 4) >> 0x1e);
  uVar7 = ((int)param_2 << 5 ^ *(uint *)(iVar2 + 0x14fc)) & 0x20 ^ *(uint *)(iVar2 + 0x14fc);
  *(undefined *)(iVar2 + 0x14fb) = 1;
  uVar7 = (param_1 << 6 ^ uVar7) & 0x40 ^ uVar7;
  *(uint *)(iVar2 + 0x14fc) = ((int)local_4 << 7 ^ uVar7) & 0x80 ^ uVar7;
  return;
}

