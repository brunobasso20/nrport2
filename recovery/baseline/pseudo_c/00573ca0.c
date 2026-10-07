/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00573ca0 */

void thunk_FUN_00411eb0(void)

{
  undefined *puVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  char cVar4;
  int iVar5;
  undefined4 uVar6;
  undefined4 *puVar7;
  int iVar8;
  int iVar9;
  bool bVar10;
  int iStack_2c;
  int iStack_28;
  int iStack_24;
  undefined1 auStack_20 [4];
  undefined4 uStack_1c;
  int iStack_18;
  undefined4 uStack_14;
  undefined1 auStack_10 [16];
  
  if (DAT_007668d8 == '\0') {
    iVar9 = 0;
    do {
      puVar1 = (&PTR_DAT_007216d8)[iVar9];
      bVar10 = false;
      iVar5 = 0;
      puVar1[0x1894] = 0;
      do {
        if (bVar10) goto LAB_00411eff;
        bVar10 = *(int *)(puVar1 + iVar9 * 4 + 0x1880) != 0;
        iVar5 = iVar5 + 1;
      } while (iVar5 < 4);
      if (bVar10) {
LAB_00411eff:
        FUN_00412240(iVar9,1);
      }
      puVar1 = (&PTR_DAT_007216d8)[iVar9];
      bVar10 = false;
      iVar5 = 0;
      puVar1[0x312d] = 0;
      do {
        if (bVar10) goto LAB_00411f36;
        bVar10 = *(int *)(puVar1 + iVar9 * 4 + 0x3119) != 0;
        iVar5 = iVar5 + 1;
      } while (iVar5 < 4);
      if (bVar10) {
LAB_00411f36:
        FUN_00412240(iVar9,0);
      }
      iVar9 = iVar9 + 1;
    } while (iVar9 < 0x10);
    DAT_007668d8 = '\x01';
    uVar6 = FUN_004233a0();
    iStack_2c = 0;
    iStack_24 = FUN_004279f0(&iStack_2c);
    iStack_28 = 0;
    if (0 < iStack_2c) {
      do {
        iVar9 = iStack_28;
        uVar2 = *(undefined4 *)(iStack_24 + iStack_28 * 4);
        cVar4 = FUN_0056c150(uVar2,0xffffffff);
        if (cVar4 != '\0') {
          iVar8 = 0;
          iVar5 = FUN_00427a30(uVar2);
          if (0 < iVar5) {
            do {
              uStack_1c = uVar6;
              iStack_18 = iVar8;
              uStack_14 = uVar2;
              puVar7 = (undefined4 *)FUN_00432cf0(&uStack_1c);
              if (puVar7 != (undefined4 *)0x0) {
                uVar3 = *puVar7;
                FUN_00412050(uVar3,auStack_10,auStack_20,4,1);
                FUN_00412050(uVar3,auStack_10,auStack_20,4,0);
              }
              iVar8 = iVar8 + 1;
              iVar5 = FUN_00427a30(uVar2);
              iVar9 = iStack_28;
            } while (iVar8 < iVar5);
          }
        }
        iStack_28 = iVar9 + 1;
      } while (iStack_28 < iStack_2c);
    }
  }
  return;
}


