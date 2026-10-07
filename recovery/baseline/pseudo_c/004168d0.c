/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 004168d0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_004168d0(int param_1)

{
  char cVar1;
  ushort uVar2;
  ushort uVar3;
  int iVar4;
  undefined4 uVar5;
  uint uVar6;
  ushort uVar7;
  float10 fVar8;
  int iVar9;
  
  FUN_00538ab0();
  iVar4 = FUN_005398d0();
  if (iVar4 == 5) {
    return 1;
  }
  iVar4 = 0;
  do {
    iVar9 = iVar4;
    FUN_00538ac0(iVar4);
    uVar5 = FUN_0053b6a0(iVar9);
    if (((char)uVar5 != '\0') &&
       (cVar1 = *(char *)(iVar4 + 0x433b + param_1),
       uVar6 = CONCAT31((int3)((uint)uVar5 >> 8),cVar1), cVar1 == '\0')) goto LAB_0041692d;
    iVar4 = iVar4 + 1;
  } while (iVar4 < 0x30);
  fVar8 = (float10)FUN_00516e1a();
  uVar2 = (ushort)(fVar8 * (float10)_DAT_006ecfd8 < (float10)_DAT_006e97d8);
  uVar3 = (ushort)(fVar8 * (float10)_DAT_006ecfd8 == (float10)_DAT_006e97d8);
  uVar7 = uVar2 << 8 | uVar3 << 0xe;
  uVar6 = (uint)uVar7;
  if (uVar2 == 0 && uVar3 == 0) {
    return CONCAT31((uint3)(byte)(uVar7 >> 8),1);
  }
LAB_0041692d:
  return uVar6 & 0xffffff00;
}


