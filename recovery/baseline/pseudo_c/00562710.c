/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00562710 */

void FUN_00562710(void)

{
  undefined4 *puVar1;
  int *piVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined4 *puVar6;
  int iVar7;
  int local_8;
  
  local_8 = 0x30;
  puVar6 = (undefined4 *)&DAT_00c537cc;
  do {
    FUN_004ed160();
    FUN_00401f80((undefined *)((int)puVar6 + -0x919),4,4,FUN_004ed160);
    FUN_00401f80((undefined *)((int)puVar6 + -0x92e),4,4,FUN_004ed160);
    FUN_00401f80((undefined *)((int)puVar6 + -0x94e),4,4,FUN_004ed160);
    FUN_0040c120(puVar6[-0x56d]);
    FUN_0040c120(puVar6[-0x56f]);
    FUN_0040c120(puVar6[-0x56e]);
    FUN_005f5880(puVar6 + -0x56c);
    puVar1 = (undefined4 *)puVar6[-0x57b];
    iVar7 = 0;
    iVar4 = 0;
    iVar5 = 0x600;
    if (0 < DAT_00f6eb00) {
      iVar3 = 0;
      do {
        piVar2 = (int *)(DAT_00f6eb04 + iVar3);
        LOCK();
        *piVar2 = *piVar2 + 1;
        UNLOCK();
        if ((*piVar2 == 0) && (*(int *)(iVar3 + 4 + DAT_00f6eb04) < iVar5)) {
          iVar5 = *(int *)(iVar3 + 4 + DAT_00f6eb04);
          iVar4 = iVar7;
        }
        LOCK();
        *(int *)(DAT_00f6eb04 + iVar3) = *(int *)(DAT_00f6eb04 + iVar3) + -1;
        UNLOCK();
        iVar7 = iVar7 + 1;
        iVar3 = iVar3 + 0xc;
      } while (iVar7 < DAT_00f6eb00);
    }
    while( true ) {
      piVar2 = (int *)(DAT_00f6eb04 + iVar4 * 0xc);
      LOCK();
      *piVar2 = *piVar2 + 1;
      UNLOCK();
      if (*piVar2 == 0) break;
      piVar2 = (int *)(iVar4 * 0xc + DAT_00f6eb04);
      LOCK();
      *piVar2 = *piVar2 + -1;
      UNLOCK();
      iVar4 = (iVar4 + 1) % DAT_00f6eb00;
    }
    iVar4 = iVar4 * 0xc;
    *puVar1 = *(undefined4 *)(iVar4 + 8 + DAT_00f6eb04);
    *(undefined4 **)(iVar4 + 8 + DAT_00f6eb04) = puVar1;
    *(int *)(iVar4 + 4 + DAT_00f6eb04) = *(int *)(iVar4 + 4 + DAT_00f6eb04) + 1;
    LOCK();
    *(int *)(iVar4 + DAT_00f6eb04) = *(int *)(iVar4 + DAT_00f6eb04) + -1;
    UNLOCK();
    FUN_004f69a0(puVar6[-0x57d]);
    FUN_004f69a0(puVar6[-0x57c]);
    FUN_005f5880(puVar6 + -0x57a);
    FUN_004f69a0(puVar6[-0x587]);
    FUN_004f69a0(puVar6[-0x589]);
    FUN_004f69a0(puVar6[-0x588]);
    FUN_005f5880(puVar6 + -0x586);
    local_8 = local_8 + -1;
    puVar6 = puVar6 + -0x56e;
  } while (local_8 != 0);
  return;
}


