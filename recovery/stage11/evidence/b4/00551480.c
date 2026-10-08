/* NR2003.exe @ 00551480 FUN_00551480 */

undefined * FUN_00551480(void)

{
  bool bVar1;
  undefined4 uVar2;
  int iVar3;
  undefined *puVar4;
  
  bVar1 = inBackground();
  if (bVar1) {
    uVar2 = FUN_0055ab00();
    iVar3 = FUN_00562f70(uVar2);
    if (*(int *)(iVar3 + 4) == 0) {
      return (undefined *)(iVar3 + 4);
    }
    iVar3 = FUN_0055ab00();
    puVar4 = &DAT_00c08874 + iVar3 * 0x32c;
  }
  else {
    uVar2 = FUN_0055ab00();
    iVar3 = FUN_004f5970(uVar2);
    if (*(int *)(iVar3 + 4) == 0) {
      return (undefined *)(iVar3 + 4);
    }
    iVar3 = FUN_0055ab00();
    puVar4 = &DAT_00b32eec + iVar3 * 0x32c;
  }
  *(undefined4 *)(puVar4 + 0x168) = 0;
  *(undefined4 *)(puVar4 + 0x164) = 0;
  *(undefined4 *)(puVar4 + 0x160) = 0;
  *(undefined4 *)(puVar4 + 0x16c) = 0;
  *(undefined4 *)(puVar4 + 0x170) = 0;
  *(undefined4 *)(puVar4 + 0x174) = 0;
  return puVar4;
}

