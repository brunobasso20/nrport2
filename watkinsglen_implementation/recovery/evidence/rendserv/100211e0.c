/* FUN_100211e0 */

undefined4 __fastcall FUN_100211e0(int param_1)

{
  void *pvVar1;
  int **ppiVar2;
  int iVar3;
  int *piVar4;
  success sVar5;
  undefined4 uVar6;
  int **local_c;
  void *local_8;
  void *local_4;

  iVar3 = FUN_10021b00(param_1);
  if (iVar3 != 0) {
    *(uint *)(iVar3 + 0x88) = *(uint *)(iVar3 + 0x88) | 8;
    piVar4 = FUN_100150d0(iVar3);
    *(uint *)(iVar3 + 0x88) = *(uint *)(iVar3 + 0x88) & 0xfffffff7;
    if (piVar4 != (int *)0x0) {
      sVar5 = _memAlloc(&local_8,0x24);
      if ((sVar5 == 0) || (local_8 == (void *)0x0)) {
        local_c = (int **)0x0;
        FUN_10005260(piVar4);
        return 0;
      }
      local_c = (int **)FUN_1001fb80(local_8,piVar4,*(int *)(*(int *)(param_1 + 0x74) + 8),
                                     *(int *)(*(int *)(param_1 + 0x78) + 8));
      if (local_c != (int **)0x0) {
        if (((uint)piVar4[3] >> 4 & 1) != 0) {
          pvVar1 = (void *)(param_1 + 0x24);
          local_8 = pvVar1;
          FUN_10023690(pvVar1,&local_4,&local_8,&local_c);
          if (local_4 != pvVar1) {
            uVar6 = FUN_10021d00(param_1);
            *(undefined4 *)(param_1 + 0x7c) = uVar6;
            return 1;
          }
        }
        if (((uint)piVar4[3] >> 3 & 1) != 0) {
          pvVar1 = (void *)(param_1 + 0x14);
          local_4 = pvVar1;
          FUN_10023690(pvVar1,&local_8,&local_4,&local_c);
          if (local_8 != pvVar1) {
            uVar6 = FUN_10021d00(param_1);
            *(undefined4 *)(param_1 + 0x7c) = uVar6;
            return 1;
          }
        }
        ppiVar2 = local_c;
        if (local_c != (int **)0x0) {
          FUN_1001fbf0(local_c);
          _memFree(ppiVar2);
        }
      }
      FUN_10005260(piVar4);
    }
  }
  return 0;
}
