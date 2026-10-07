/* Ghidra pseudo-C; NR2003.exe @ 005b9ed0 */

/* WARNING: Removing unreachable block (ram,0x005b9f6f) */
/* WARNING: Removing unreachable block (ram,0x005b9f88) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_005b9ed0(void)

{
  uint uVar1;
  uint uVar2;
  longlong lVar3;
  longlong lVar4;
  int iVar5;
  int iVar6;
  uint *puVar7;
  undefined4 uVar8;
  int iVar9;
  undefined4 unaff_EBX;
  int iVar10;
  undefined4 unaff_EBP;
  int iVar11;
  undefined4 unaff_ESI;
  char *pcVar12;
  int iVar13;
  undefined4 unaff_EDI;
  char *pcVar14;
  int iVar15;
  bool bVar16;
  undefined8 uVar17;
  longlong lVar18;
  longlong lVar19;
  int in_stack_00019b02;
  undefined4 in_stack_00019b06;
  undefined4 in_stack_00019b0a;
  longlong in_stack_00019b0e;
  float in_stack_0002688d;
  
  DAT_00ebbd84 = 0;
  iVar5 = FUN_005b9e90();
  iVar6 = FUN_005b9e70();
  iVar9 = 0x17;
  bVar16 = true;
  pcVar12 = (char *)(iVar6 + 0x10);
  pcVar14 = (char *)(iVar5 + 0x10);
  do {
    if (iVar9 == 0) break;
    iVar9 = iVar9 + -1;
    bVar16 = *pcVar12 == *pcVar14;
    pcVar12 = pcVar12 + 1;
    pcVar14 = pcVar14 + 1;
  } while (bVar16);
  if (!bVar16) {
    return;
  }
  puVar7 = (uint *)FUN_005b9e70();
  uVar17 = FUN_005cfcfc();
  iVar11 = *puVar7 - (uint)uVar17;
  iVar10 = (puVar7[1] - (int)((ulonglong)uVar17 >> 0x20)) - (uint)(*puVar7 < (uint)uVar17);
  lVar4 = CONCAT44(iVar10,iVar11);
  FUN_005b9e90();
  uVar17 = FUN_005b9e70();
  puVar7 = (uint *)((ulonglong)uVar17 >> 0x20);
  uVar1 = *(uint *)uVar17;
  uVar2 = *puVar7;
  iVar13 = uVar1 - uVar2;
  iVar15 = (((uint *)uVar17)[1] - puVar7[1]) - (uint)(uVar1 < uVar2);
  iVar5 = iVar13;
  iVar6 = iVar15;
  iVar9 = FUN_005b9e90();
  iVar9 = FUN_005b9e70(*(undefined4 *)(iVar9 + 8));
  uVar8 = FUN_005ceb90(*(undefined4 *)(iVar9 + 8));
  lVar18 = FUN_006c6b50(iVar13,iVar15,0xfffffff8,0xffffffff,unaff_EBP,unaff_EBX,unaff_EDI,unaff_ESI,
                        uVar8,iVar11,iVar10,iVar5,iVar6);
  if (lVar18 <= lVar4) {
    lVar19 = FUN_006c6b50();
    lVar18 = lVar19 + CONCAT44(iVar15,iVar13);
    lVar3 = CONCAT44(in_stack_00019b0a,in_stack_00019b06);
    if (lVar4 <= lVar19 + CONCAT44(iVar15,iVar13)) goto LAB_005b9f94;
  }
  lVar3 = lVar18;
LAB_005b9f94:
  if ((0 < in_stack_00019b02) && (in_stack_00019b02 < 0x21)) {
    DAT_00ebbd7c = _DAT_006e97d8 - (float)lVar3 / (float)in_stack_00019b0e;
    lVar18 = FUN_006c6b50();
    DAT_00ebbd84 = 1;
    _DAT_00ebbd80 = _DAT_006e97d8 - in_stack_0002688d / (float)lVar18;
    return;
  }
  if ((in_stack_00019b02 < 0) && (-0x21 < in_stack_00019b02)) {
    DAT_00ebbd7c = _DAT_006e97d8 - (float)lVar3 / (float)in_stack_00019b0e;
    lVar18 = FUN_006c6b50();
    DAT_00ebbd84 = 1;
    _DAT_00ebbd80 = in_stack_0002688d / (float)lVar18;
    return;
  }
  DAT_00ebbd84 = 1;
  _DAT_00ebbd80 = 1.0;
  DAT_00ebbd7c = 1.0;
  return;
}

