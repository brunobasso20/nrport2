/* Ghidra pseudo-C; NR2003.exe @ 005605c0 */

void FUN_005605c0(void)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  double dVar4;
  undefined4 uVar5;
  int iVar6;
  float *pfVar7;
  uint *puVar8;
  int iVar9;
  uint *puVar10;
  float local_8 [2];
  
  uVar5 = FUN_0055ab00();
  iVar6 = FUN_00562f70(uVar5);
  iVar1 = *(int *)(iVar6 + 0x58a);
  FUN_005f5890(iVar6 + 0x524);
  puVar8 = *(uint **)(iVar6 + 0x520);
  puVar10 = *(uint **)(iVar6 + 0x518);
  iVar9 = 2;
  pfVar7 = local_8;
  do {
    uVar2 = *puVar10;
    uVar3 = *puVar8;
    puVar10 = puVar10 + 1;
    puVar8 = puVar8 + 1;
    iVar9 = iVar9 + -1;
    *pfVar7 = (float)(uVar2 ^ uVar3);
    pfVar7 = pfVar7 + 1;
  } while (iVar9 != 0);
  FUN_005f58a0(iVar6 + 0x524);
  dVar4 = (double)CONCAT44(local_8[1],local_8[0]);
  local_8[0] = (float)dVar4 * *(float *)(iVar1 + 0x28);
  FUN_005b4840(DAT_00c08234,(float)dVar4,local_8[0],local_8[0],local_8[0]);
  return;
}

