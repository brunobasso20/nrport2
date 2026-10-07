/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005215c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_005215c0(int param_1)

{
  float fVar1;
  float fVar2;
  float fVar3;
  float fVar4;
  char cVar5;
  int iVar6;
  float *pfVar7;
  undefined *puVar8;
  float *pfVar9;
  char local_71;
  float *local_70;
  float *local_6c;
  float *local_68;
  float local_64 [3];
  float local_58 [22];
  
  *(undefined4 *)(param_1 + 0x104) = 0;
  *(undefined1 *)(param_1 + 0x108) = 1;
  local_70 = *(float **)(*(int *)(param_1 + 0x89) + 0x5ae);
  if (local_70 != (float *)0x0) {
    if (*(char *)(param_1 + 0x8d) != '\0') {
      local_68 = local_64;
      pfVar7 = local_70;
      pfVar9 = local_58;
      for (iVar6 = 0x16; iVar6 != 0; iVar6 = iVar6 + -1) {
        *pfVar9 = *pfVar7;
        pfVar7 = pfVar7 + 1;
        pfVar9 = pfVar9 + 1;
      }
      local_6c = local_64;
      pfVar7 = local_70 + 0x16;
      puVar8 = &DAT_0074ba60;
      do {
        FUN_005f6d20(local_64,pfVar7,puVar8);
        fVar1 = local_6c[1];
        fVar2 = local_70[1];
        fVar3 = local_6c[2];
        fVar4 = local_70[2];
        *local_68 = *local_6c + *local_70;
        local_68[1] = fVar1 + fVar2;
        local_68[2] = fVar3 + fVar4;
        FUN_005f58d0(local_58,local_64);
        cVar5 = FUN_00536660(local_58,*(undefined4 *)(param_1 + 0x65),&local_71);
        if (cVar5 != '\0') {
          *(float *)(param_1 + 0x104) = *(float *)(param_1 + 0x104) + _DAT_006f4a2c;
        }
        if (local_71 == '\0') {
          *(undefined1 *)(param_1 + 0x108) = 0;
        }
        puVar8 = puVar8 + 0xc;
      } while ((int)puVar8 < 0x74ba90);
      return;
    }
    cVar5 = FUN_00536660(local_70,*(undefined4 *)(param_1 + 0x65),0);
    if (cVar5 != '\0') {
      *(undefined4 *)(param_1 + 0x104) = 0x3f800000;
      return;
    }
    *(undefined1 *)(param_1 + 0x108) = 0;
  }
  return;
}


