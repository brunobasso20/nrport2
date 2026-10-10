/* NR2003.exe @ 005d0950 FUN_005d0950 */

void FUN_005d0950(void)

{
  int iVar1;
  int iVar2;
  uint uVar3;
  undefined4 *puVar4;
  int iVar5;
  
  puVar4 = &DAT_00f5d460;
  for (iVar2 = 0x10; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar4 = 0xffffffff;
    puVar4 = puVar4 + 1;
  }
  DAT_00f5d208 = 0;
  DAT_00f5d20c = 0;
  uVar3 = 0;
  FUN_005d1ff0(&DAT_00f5d460,0xffff);
  iVar5 = 0;
  iVar2 = 0;
  do {
    iVar1 = (&DAT_00f5d460)[iVar5];
    (&DAT_00f5d210)[iVar5] = 0;
    (&DAT_00f5d250)[iVar5] = 0;
    (&DAT_00f5d290)[iVar5] = 0;
    (&DAT_00f5d2d0)[iVar5] = 0;
    (&DAT_00f5d310)[iVar5] = 0;
    (&DAT_00f5d354)[iVar5] = 0;
    (&DAT_00f5d394)[iVar5] = 0;
    (&DAT_00f5d3d4)[iVar5] = 0;
    (&DAT_00f5d418)[iVar5] = 0;
    if (iVar1 != -1) {
      (&DAT_00f5d290)[iVar2] = iVar1;
      (&DAT_00f5d4a8)[iVar2] = iVar5;
      uVar3 = uVar3 | 1 << ((byte)iVar5 & 0x1f);
      (&DAT_00f5d210)[iVar2] = iVar1 + -1;
      (&DAT_00f5d2d0)[iVar2] = (&DAT_00f5d290)[iVar2] + 1;
      FUN_005d0a40(iVar2);
      iVar2 = iVar2 + 1;
    }
    iVar5 = iVar5 + 1;
  } while (iVar5 < 0x10);
  DAT_00f5d350 = 0;
  DAT_00f5d208 = iVar2;
  DAT_00f5d20c = uVar3;
  FUN_005d0690();
  return;
}

