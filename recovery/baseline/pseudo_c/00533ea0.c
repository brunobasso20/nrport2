/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00533ea0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00533ea0(undefined4 *param_1,undefined4 param_2,float param_3,float param_4)

{
  float fVar1;
  float fVar2;
  float fVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  undefined *puVar7;
  int iVar8;
  float local_18;
  int local_14;
  
  iVar4 = FUN_005337e0(*param_1);
  iVar4 = iVar4 + -1;
  iVar5 = FUN_005337e0(param_1[1]);
  iVar5 = iVar5 + 1;
  iVar6 = FUN_005337e0(param_1[2]);
  fVar1 = _DAT_006e97d8 / (float)(iVar6 - iVar4);
  fVar2 = _DAT_006e97d8 / (float)(iVar5 - iVar6);
  if (iVar4 <= iVar5) {
    local_14 = 0;
    iVar8 = iVar5 - iVar4;
    puVar7 = PTR_DAT_0074bf54;
    do {
      local_18 = 0.0;
      if (_DAT_006ea454 < param_4) {
        if (iVar6 < iVar4) {
          local_18 = (float)iVar8 * fVar2;
        }
        else {
          local_18 = (float)local_14 * fVar1;
        }
        local_18 = local_18 * param_4;
      }
      fVar3 = param_3;
      if (param_3 < _DAT_006f52dc) {
        if (iVar6 < iVar4) {
          fVar3 = (float)iVar8 * fVar2;
        }
        else {
          fVar3 = (float)local_14 * fVar1;
        }
        fVar3 = (fVar3 + _DAT_006e97d8) * _DAT_006ea44c * param_3;
      }
      if (*(float *)(PTR_DAT_0074bf4c + iVar4 * 4) <= fVar3 + local_18) {
        if (((float)param_1[8] < *(float *)(puVar7 + iVar4 * 4)) ||
           ((_DAT_006ea454 < local_18 && (*(float *)(puVar7 + iVar4 * 4) == DAT_006f5254)))) {
          *(undefined4 *)(puVar7 + iVar4 * 4) = param_1[8];
          *(float *)(PTR_DAT_0074bf4c + iVar4 * 4) =
               local_18 + *(float *)(PTR_DAT_0074bf4c + iVar4 * 4);
          puVar7 = PTR_DAT_0074bf54;
          if (*(int *)(PTR_DAT_0074bf50 + iVar4 * 4) == 0) {
            *(undefined4 **)(PTR_DAT_0074bf50 + iVar4 * 4) = param_1;
            puVar7 = PTR_DAT_0074bf54;
          }
        }
      }
      else {
        *(float *)(PTR_DAT_0074bf4c + iVar4 * 4) = fVar3 + local_18;
        *(undefined4 **)(PTR_DAT_0074bf50 + iVar4 * 4) = param_1;
        puVar7 = PTR_DAT_0074bf54;
        if ((float)param_1[8] < *(float *)(PTR_DAT_0074bf54 + iVar4 * 4)) {
          *(undefined4 *)(PTR_DAT_0074bf54 + iVar4 * 4) = param_1[8];
          puVar7 = PTR_DAT_0074bf54;
        }
      }
      iVar4 = iVar4 + 1;
      local_14 = local_14 + 1;
      iVar8 = iVar8 + -1;
    } while (iVar4 <= iVar5);
  }
  return;
}


