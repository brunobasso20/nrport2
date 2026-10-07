/* NR2003.exe @ 006c4d21 FUN_006c4d21 */

/* WARNING: Instruction at (ram,0x006c4dd8) overlaps instruction at (ram,0x006c4dd6)
    */
/* WARNING: Control flow encountered bad instruction data */
/* WARNING (jumptable): Unable to track spacebase fully for stack */
/* WARNING: Unable to track spacebase fully for stack */
/* WARNING: This function may have set the stack pointer */
/* WARNING: Removing unreachable block (ram,0x006c4f89) */
/* WARNING: Removing unreachable block (ram,0x006c4f8e) */
/* WARNING: Removing unreachable block (ram,0x006c4f19) */
/* WARNING: Removing unreachable block (ram,0x006c4f23) */
/* WARNING: Removing unreachable block (ram,0x006c4f7c) */
/* WARNING: Removing unreachable block (ram,0x006c4f40) */
/* WARNING: Removing unreachable block (ram,0x006c4f62) */
/* WARNING: Removing unreachable block (ram,0x006c4f65) */
/* WARNING: Removing unreachable block (ram,0x006c4fd9) */
/* WARNING: Removing unreachable block (ram,0x006c4f46) */
/* WARNING: Removing unreachable block (ram,0x006c4f90) */
/* WARNING: Removing unreachable block (ram,0x006c4f9b) */
/* WARNING: Removing unreachable block (ram,0x006c4f9d) */
/* WARNING: Removing unreachable block (ram,0x006c4fae) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_006c4d21(int param_1,undefined4 param_2)

{
  byte *pbVar1;
  char *pcVar2;
  undefined4 uVar3;
  uint uVar4;
  code *pcVar5;
  byte bVar6;
  undefined *puVar7;
  uint uVar8;
  uint *puVar9;
  int extraout_ECX;
  uint extraout_ECX_00;
  uint extraout_ECX_01;
  byte bVar11;
  undefined2 extraout_DX;
  undefined2 extraout_DX_00;
  undefined2 uVar10;
  char cVar13;
  int iVar12;
  undefined2 *puVar14;
  code *unaff_EBP;
  int unaff_ESI;
  int unaff_EDI;
  undefined2 in_ES;
  undefined2 in_CS;
  undefined2 uVar15;
  undefined2 in_DS;
  bool bVar16;
  float10 fVar17;
  undefined6 uVar18;
  undefined4 *unaff_retaddr;
  undefined4 in_stack_fffffff4;
  int iVar19;
  undefined4 in_stack_fffffff8;
  int iVar20;
  undefined4 in_stack_fffffffc;
  
  iVar20 = CONCAT22((short)((uint)in_stack_fffffff8 >> 0x10),in_ES);
  cVar13 = (char)((ushort)in_DS >> 8) + (char)param_1;
  iVar12 = CONCAT22((short)((uint)in_stack_fffffffc >> 0x10),CONCAT11(cVar13,(char)in_DS));
  puVar9 = (uint *)(param_1 + -1);
  if ((puVar9 == (uint *)0x0 || cVar13 != '\0') || (iVar12 = iVar12 + 1, -1 < iVar12)) {
    iVar19 = CONCAT22((short)((uint)in_stack_fffffff4 >> 0x10),in_CS);
    uVar15 = 0x1c74;
    func_0x11429e47(iVar19,iVar20,param_1);
    bVar16 = false;
    *(byte *)(iVar12 + 0x71cf626e) = *(byte *)(iVar12 + 0x71cf626e) & 0x45;
    uVar18 = func_0x40c63341();
    uVar3 = _DAT_579d815d;
    uVar10 = (undefined2)((uint6)uVar18 >> 0x20);
    puVar14 = (undefined2 *)&DAT_579d815d;
    if (extraout_ECX != 0) {
      out(*(undefined *)(unaff_ESI + 1),uVar10);
      puVar7 = (undefined *)((int)uVar18 + -1);
      *(uint *)(unaff_EDI + -0x16) = *(uint *)(unaff_EDI + -0x16) & (uint)puVar7;
      *(int *)(extraout_ECX + -0x2023dab4) = *(int *)(extraout_ECX + -0x2023dab4) + -1;
      out(*puVar7,uVar10);
                    /* WARNING: Could not recover jumptable at 0x006c4d64. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      uVar8 = (**(code **)(unaff_ESI + 2))();
      return uVar8;
    }
    out(uVar10,(int)uVar18);
    if (!bVar16) {
      *(char *)(unaff_ESI + 0x242cb42) = *(char *)(unaff_ESI + 0x242cb42) + '\x01';
      *(undefined4 *)(iVar19 + 0x5a98642c) = uRam579d8161;
      *(byte *)(unaff_ESI + -0x43a341bc) = *(byte *)(unaff_ESI + -0x43a341bc) & (byte)uVar3;
      puVar14 = (undefined2 *)*(undefined6 *)((int)(undefined4 *)(unaff_EDI + 4) * 8 + 0x7166ef57);
      in(0x96);
    }
    *puVar14 = uVar15;
    *(undefined4 *)(puVar14 + -2) = 0x6c4df2;
    fVar17 = (float10)func_0x6c61e371();
    in(0xf2);
    uVar8 = in(0x95);
    *(float *)(uVar8 + 0x58004ff3) = (float)fVar17;
    return uVar8;
  }
  uVar8 = _DAT_6b78fd73 | *puVar9;
  if ((int)uVar8 < 0) {
    puVar9 = (uint *)(iVar20 + 0x50);
    *puVar9 = *puVar9 >> 0xb;
    return uVar8;
  }
  cVar13 = '\0';
  if (puVar9 != (uint *)0x0) {
    *(char *)(unaff_EDI + 8) = *(char *)(unaff_EDI + 8) + (char)((uint)puVar9 >> 8);
    uVar3 = in((short)param_2);
    *(undefined4 *)(unaff_EDI + 4) = uVar3;
    iVar12 = in(0xef);
    pbVar1 = (byte *)(iVar12 + 0x64edacf5);
    bVar6 = *pbVar1;
    bVar11 = (byte)((uint)param_2 >> 8);
    *pbVar1 = *pbVar1 + bVar11;
    *(int *)(unaff_EBP + -0x76) = unaff_ESI;
    *(int *)(unaff_EDI + -0x7e) =
         *(int *)(unaff_EDI + -0x7e) + unaff_ESI + (uint)CARRY1(bVar6,bVar11);
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  (*unaff_EBP)();
  pcVar5 = (code *)swi(4);
  uVar8 = extraout_ECX_00;
  uVar10 = extraout_DX;
  if (cVar13 == '\x01') {
    (*pcVar5)();
    uVar8 = extraout_ECX_01;
    uVar10 = extraout_DX_00;
  }
  out(*(undefined *)(unaff_ESI + 2),uVar10);
  if ((uVar8 & 0x40) == 0) {
    in(uVar10);
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  uVar4 = (uint)((uVar8 & 1) != 0);
  bVar6 = ((char)_DAT_c28ee074 + 'j') -
          (unaff_EBP < _DAT_c28ee074 || (uint)((int)unaff_EBP - (int)_DAT_c28ee074) < uVar4);
  out(6,bVar6);
  bVar16 = 9 < (bVar6 & 0xf) || (uVar8 & 0x10) != 0;
  bVar6 = bVar6 + bVar16 * '\x06';
  pcVar2 = (char *)(CONCAT31((int3)((uint)_DAT_c28ee074 >> 8),
                             bVar6 + (0x90 < (bVar6 & 0xf0) | bVar16 * (0xf9 < bVar6)) * '`') +
                   (((int)unaff_EBP - (int)_DAT_c28ee074) - uVar4));
  _DAT_1f68a8b0 = unaff_ESI + 3 + (uint)((uVar8 & 0x400) != 0) * -2;
  *pcVar2 = *pcVar2 + '\x01';
  uVar3 = in(uVar10);
  *unaff_retaddr = uVar3;
  pcVar5 = (code *)swi(0x16);
  (*pcVar5)();
  bVar6 = in(0x2f);
  return (uint)bVar6;
}

