/* NR2003.exe @ 1000eee0 recovered_1000eee0 */

int * __fastcall recovered_1000eee0(int *param_1)

{
  undefined4 *puVar1;
  int iVar2;
  code **ppcVar3;
  bool bVar4;
  undefined *puVar5;
  int iVar6;
  byte *pbVar7;
  uint uVar8;
  success sVar9;
  void *this;
  void *this_00;
  int iVar10;
  int *piVar11;
  int *piVar12;
  undefined4 *puStack_8;
  int *piStack_4;
  
  iVar6 = FUN_1000e9d0(param_1[0x10],param_1[0xe]);
  if (iVar6 == 0) {
    FUN_10005260(param_1);
    return (int *)0x0;
  }
  iVar6 = 0;
  iVar10 = 0;
  bVar4 = true;
  if (0 < param_1[0xe]) {
    do {
      puVar5 = PTR_s_CompiledMaterialRef_1003e488;
      puVar1 = *(undefined4 **)(param_1[0x10] + iVar10 * 4);
      if ((puVar1 != (undefined4 *)0x0) && (bVar4)) {
        pbVar7 = (byte *)(**(code **)*puVar1)();
        uVar8 = FUN_10033990(this,puVar5,pbVar7);
        if (uVar8 != 0) {
          return param_1;
        }
        iVar2 = *(int *)(param_1[0x10] + iVar10 * 4);
        if (iVar6 == 0) {
          iVar6 = *(int *)(iVar2 + 0x2c);
        }
        else if (iVar6 != *(int *)(iVar2 + 0x2c)) {
          bVar4 = false;
        }
      }
      iVar10 = iVar10 + 1;
    } while (iVar10 < param_1[0xe]);
    if ((((bVar4) && (iVar6 != 0)) && (sVar9 = _memAlloc(&puStack_8,0x34), sVar9 != 0)) &&
       ((puStack_8 != (undefined4 *)0x0 &&
        (piStack_4 = (int *)FUN_1000f440(puStack_8), piStack_4 != (int *)0x0)))) {
      ppcVar3 = *(code ***)(iVar6 + 8);
      piVar11 = param_1 + 4;
      piVar12 = piStack_4 + 4;
      for (iVar10 = 7; iVar10 != 0; iVar10 = iVar10 + -1) {
        *piVar12 = *piVar11;
        piVar11 = piVar11 + 1;
        piVar12 = piVar12 + 1;
      }
      iVar10 = param_1[3];
      piStack_4[0xc] = (int)param_1;
      piStack_4[3] = iVar10;
      piStack_4[0xb] = iVar6;
      (**ppcVar3)();
      iVar6 = 0;
      if (0 < param_1[0xe]) {
        do {
          puVar5 = PTR_s_CompiledMaterialRef_1003e488;
          pbVar7 = (byte *)(**(code **)**(undefined4 **)(param_1[0x10] + iVar6 * 4))();
          uVar8 = FUN_10033990(this_00,puVar5,pbVar7);
          if (uVar8 == 0) {
            piVar11 = *(int **)(param_1[0x10] + iVar6 * 4);
            iVar10 = piVar11[0xc];
            *(int *)(param_1[0x10] + iVar6 * 4) = iVar10;
            (***(code ***)(iVar10 + 8))();
            FUN_10005260(piVar11);
          }
          iVar6 = iVar6 + 1;
        } while (iVar6 < param_1[0xe]);
      }
      return piStack_4;
    }
  }
  return param_1;
}

