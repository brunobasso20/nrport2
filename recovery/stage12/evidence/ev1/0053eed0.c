/* NR2003.exe @ 0053eed0 FUN_0053eed0 */

void __thiscall FUN_0053eed0(int param_1_00,int *param_1)

{
  char cVar1;
  int iVar2;
  uint uVar3;
  uint uVar4;
  undefined4 uVar5;
  int *piVar6;
  uint *puVar7;
  int *piVar8;
  uint *puVar9;
  bool bVar10;
  uint local_68 [26];
  
  iVar2 = FUN_00544be0();
  if (((*param_1 == iVar2) && (iVar2 = FUN_00509990(), (param_1[1] << 4) >> 4 == iVar2)) &&
     (uVar3 = FUN_005099a0(), (uint)param_1[1] >> 0x1c == uVar3)) {
    uVar3 = param_1[3] & 0x7f;
    iVar2 = 4;
    bVar10 = true;
    piVar6 = &DAT_00acdd57 + uVar3 * 0x885;
    piVar8 = param_1 + 2;
    do {
      if (iVar2 == 0) break;
      iVar2 = iVar2 + -1;
      bVar10 = *piVar6 == *piVar8;
      piVar6 = piVar6 + 1;
      piVar8 = piVar8 + 1;
    } while (bVar10);
    if (!bVar10) {
      FUN_0054b3e0(param_1 + 2);
      FUN_005675c0(local_68);
      puVar7 = local_68;
      puVar9 = &DAT_00acdd57 + uVar3 * 0x885;
      for (iVar2 = 0x1a; iVar2 != 0; iVar2 = iVar2 + -1) {
        *puVar9 = *puVar7;
        puVar7 = puVar7 + 1;
        puVar9 = puVar9 + 1;
      }
      iVar2 = getIntCount();
      (&DAT_00acdd53)[uVar3 * 0x885] = iVar2;
      (&DAT_00acdd4b)[uVar3 * 0x885] = 0;
      (&DAT_00acdd4f)[uVar3 * 0x885] = 0;
      cVar1 = FUN_005c2cf0((&DAT_00acddbf)[uVar3 * 0x885]);
      if (cVar1 != '\0') {
        uVar4 = FUN_005c2e10((&DAT_00acddbf)[uVar3 * 0x885]);
        (&DAT_00acdd4b)[uVar3 * 0x885 + (uVar4 >> 5)] =
             (&DAT_00acdd4b)[uVar3 * 0x885 + (uVar4 >> 5)] | 1 << ((byte)uVar4 & 0x1f);
      }
      iVar2 = FUN_005099b0();
      if ((iVar2 != 7) && (iVar2 = FUN_005099b0(), iVar2 != 5)) {
        return;
      }
      uVar5 = (**(code **)((&DAT_00acca30)[uVar3 * 0x885] + 4))();
      iVar2 = FUN_00547f90(uVar5);
      if (iVar2 != 0) {
        *(undefined *)((local_68[1] & 0x7f) + 0x8b0 + param_1_00) = 0;
        uVar3 = local_68[1] & 0x7f;
        FUN_00538ac0(uVar3);
        FUN_0053b530(uVar3);
      }
    }
  }
  return;
}

