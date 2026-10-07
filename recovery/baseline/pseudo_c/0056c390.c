/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0056c390 */

undefined4 __thiscall
FUN_0056c390(undefined4 *param_1,undefined1 param_2,undefined4 *param_3,undefined4 param_4)

{
  undefined1 *puVar1;
  undefined4 *puVar2;
  char cVar3;
  int iVar4;
  undefined4 *puVar5;
  int iVar6;
  uint uVar7;
  uint uVar8;
  undefined4 *puVar9;
  int *piVar10;
  undefined4 *local_4;
  
  iVar6 = DAT_00c5c2e4;
  local_4 = param_1;
  if (((*DAT_00c5ca24 == DAT_00c5c2e4) &&
      (iVar4 = FUN_005cfce4(&local_4,(DAT_00c5c2e4 + 0x80) * 5), puVar2 = local_4, iVar4 != 0)) &&
     (local_4 != (undefined4 *)0x0)) {
    if (-1 < iVar6 + 0x7f) {
      iVar6 = iVar6 + 0x80;
      puVar5 = local_4;
      do {
        *(undefined1 *)puVar5 = 0;
        *(undefined4 *)((int)puVar5 + 1) = 0;
        puVar5 = (undefined4 *)((int)puVar5 + 5);
        iVar6 = iVar6 + -1;
      } while (iVar6 != 0);
    }
    if (0 < DAT_00c5c2e4) {
      uVar8 = DAT_00c5c2e4 * 5;
      puVar5 = DAT_00c5c2e8;
      puVar9 = local_4;
      for (uVar7 = uVar8 >> 2; uVar7 != 0; uVar7 = uVar7 - 1) {
        *puVar9 = *puVar5;
        puVar5 = puVar5 + 1;
        puVar9 = puVar9 + 1;
      }
      for (uVar8 = uVar8 & 3; uVar8 != 0; uVar8 = uVar8 - 1) {
        *(undefined1 *)puVar9 = *(undefined1 *)puVar5;
        puVar5 = (undefined4 *)((int)puVar5 + 1);
        puVar9 = (undefined4 *)((int)puVar9 + 1);
      }
    }
    if (DAT_00c5c2e8 != (undefined4 *)0x0) {
      FUN_005cfccc(DAT_00c5c2e8);
    }
    DAT_00c5c2e4 = DAT_00c5c2e4 + 0x80;
    DAT_00c5c2e8 = puVar2;
  }
  puVar2 = param_3;
  if ((*DAT_00c5ca24 < DAT_00c5c2e4) && (cVar3 = FUN_005cfd74(param_3), cVar3 != '\0')) {
    iVar6 = FUN_005cfce4(&param_3,0x1ab);
    puVar5 = param_3;
    if ((iVar6 == 0) || (param_3 == (undefined4 *)0x0)) {
      puVar5 = (undefined4 *)0x0;
    }
    else {
      param_3[8] = 0;
      param_3[9] = 0;
      *(undefined1 *)(param_3 + 10) = 0;
      *(undefined4 *)((int)param_3 + 0xdd) = 0xffffffff;
      *(undefined4 *)((int)param_3 + 0xd9) = 0;
      *(undefined4 *)((int)param_3 + 0x119) = 0;
      *(undefined4 *)((int)param_3 + 0x199) = 0;
      *(undefined4 *)((int)param_3 + 0x19d) = 0;
      *(undefined4 *)((int)param_3 + 0x1a1) = 0;
      *(undefined4 *)((int)param_3 + 0x1a5) = 0;
      *(undefined1 *)((int)param_3 + 0x1a9) = 0;
      *(undefined1 *)((int)param_3 + 0x1aa) = 1;
      puVar9 = param_3;
      for (iVar6 = 8; iVar6 != 0; iVar6 = iVar6 + -1) {
        *puVar9 = 0;
        puVar9 = puVar9 + 1;
      }
      FUN_004fef00();
    }
    *(undefined4 **)(*DAT_00c5ca24 * 5 + 1 + (int)DAT_00c5c2e8) = puVar5;
    if (*(int *)(*DAT_00c5ca24 * 5 + 1 + (int)DAT_00c5c2e8) != 0) {
      iVar6 = FUN_004fe280(puVar2,param_4,0,1);
      piVar10 = DAT_00c5ca24;
      if (iVar6 != 0) {
        puVar1 = (undefined1 *)((int)DAT_00c5c2e8 + *DAT_00c5ca24 * 5);
        iVar6 = *(int *)((int)DAT_00c5c2e8 + *DAT_00c5ca24 * 5 + 1);
        iVar4 = *(int *)(iVar6 + 0x24);
        if (((-1 < iVar4) && (iVar4 < 3)) &&
           (cVar3 = FUN_0056c150(*(undefined4 *)(iVar6 + 0xd5),0xffffffff), cVar3 != '\0')) {
          *puVar1 = param_2;
          piVar10 = DAT_00c5ca24;
          puVar2 = DAT_00c5c2e8;
          iVar6 = *(int *)(*(int *)(*DAT_00c5ca24 * 5 + 1 + (int)DAT_00c5c2e8) + 0x24);
          *(int *)(&DAT_00c5ca28 + iVar6 * 4) = *(int *)(&DAT_00c5ca28 + iVar6 * 4) + 1;
          iVar6 = *(int *)(*(int *)(*piVar10 * 5 + 1 + (int)puVar2) + 0xd5);
          (&DAT_00c5ca38)[iVar6] = (&DAT_00c5ca38)[iVar6] + 1;
          *piVar10 = *piVar10 + 1;
          return 1;
        }
      }
      iVar6 = *(int *)(*piVar10 * 5 + 1 + (int)DAT_00c5c2e8);
      if (iVar6 != 0) {
        FUN_004fe420(0x3f);
        FUN_005cfccc(iVar6);
        piVar10 = DAT_00c5ca24;
      }
      *(undefined4 *)(*piVar10 * 5 + 1 + (int)DAT_00c5c2e8) = 0;
    }
  }
  return 0;
}


