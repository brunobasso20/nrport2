/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051dd90 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_0051dd90(int param_1,char param_2)

{
  float *pfVar1;
  float *pfVar2;
  int iVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  float fVar6;
  undefined4 uVar7;
  float10 fVar8;
  float local_68;
  float local_64;
  float local_60;
  float local_5c;
  float local_58;
  float local_54;
  float local_50;
  float local_4c;
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
  
  pfVar1 = (float *)(param_1 + 0x1916);
  FUN_0051dc80(param_1,&local_38,pfVar1);
  local_50 = local_38 + *pfVar1 * _DAT_006ea44c;
  local_4c = local_34 + *(float *)(param_1 + 0x191a) * _DAT_006ea44c;
  local_48 = local_30 + *(float *)(param_1 + 0x191e) * _DAT_006ea44c;
  if (param_2 != '\0') {
    fVar6 = *(float *)(param_1 + 7000) - *(float *)(param_1 + 0x18aa);
    if (fVar6 <= (float)_DAT_006e97f8) {
      if (fVar6 < (float)_DAT_006f4638) {
        do {
          fVar6 = fVar6 + _DAT_006ee484;
        } while (fVar6 < (float)_DAT_006f4638);
      }
    }
    else {
      do {
        fVar6 = fVar6 - _DAT_006ee484;
      } while ((float)_DAT_006e97f8 < fVar6);
    }
    fVar6 = fVar6 * _DAT_006f4990 - *(float *)(param_1 + 0x18ae) * _DAT_006f498c;
    *(float *)(param_1 + 0x18b2) = fVar6;
    *(float *)(param_1 + 0x18ae) = fVar6 + *(float *)(param_1 + 0x18ae);
  }
  pfVar2 = *(float **)(param_1 + 0x1a76);
  local_2c = *pfVar2 + local_50;
  local_28 = pfVar2[1] + local_4c;
  local_24 = pfVar2[2] + local_48;
  local_68 = (local_38 + *pfVar1) * _DAT_006f410c;
  local_64 = (local_34 + *(float *)(param_1 + 0x191a)) * _DAT_006f410c;
  local_60 = (local_30 + *(float *)(param_1 + 0x191e)) * _DAT_006f410c;
  thunk_FUN_005f58d0(*(undefined4 *)(param_1 + 0x1a76),&local_2c);
  local_5c = 0.0;
  fVar8 = (float10)FUN_00516e5a(*(undefined4 *)(param_1 + 0x1a76));
  local_58 = (float)(fVar8 * (float10)*(float *)(param_1 + 0x1a96) *
                     (float10)*(float *)(param_1 + 0x1872) * (float10)_DAT_006f410c);
  local_54 = *(float *)(param_1 + 0x18ae) * _DAT_006f410c;
  FUN_005f5ac0(*(undefined4 *)(param_1 + 0x1a76),&local_68,&local_5c);
  local_44 = local_5c * _DAT_006f4988;
  local_40 = local_58 * _DAT_006f4988;
  local_3c = local_54 * _DAT_006f4988;
  FUN_005f7150(&local_10,*(int *)(param_1 + 0x1a76) + 0x7c,&local_44);
  iVar3 = *(int *)(param_1 + 0x1a76);
  local_20 = local_10 + *(float *)(iVar3 + 0x7c);
  local_1c = local_c + *(float *)(iVar3 + 0x80);
  local_18 = local_8 + *(float *)(iVar3 + 0x84);
  local_14 = local_4 + *(float *)(iVar3 + 0x88);
  FUN_005f6ff0(&local_20);
  FUN_005f5a60(*(undefined4 *)(param_1 + 0x1a76),&local_20);
  (**(code **)(**(int **)(param_1 + 0x13a7) + 0x10))(param_1);
  if ((*(byte *)(param_1 + 0x139f) & 0x10) == 0) {
    uVar7 = FUN_00546840();
    uVar4 = *(undefined4 *)(param_1 + 0x5b2);
    uVar5 = *(undefined4 *)(param_1 + 0x21ec);
    uVar7 = FUN_005cebb0(uVar7);
    FUN_005a02b0(uVar4,*(undefined4 *)(param_1 + 0x1a76),uVar7,uVar5);
  }
  *(float *)(param_1 + 0x191e) = *(float *)(param_1 + 0x191e) - _DAT_006e9814;
  return;
}


