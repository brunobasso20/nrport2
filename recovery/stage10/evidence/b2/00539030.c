/* NR2003.exe @ 00539030 FUN_00539030 */

void FUN_00539030(void)

{
  undefined4 *puVar1;
  int iVar2;
  int iVar3;
  
  puVar1 = (undefined4 *)FUN_00538b00();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b10();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b30();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b40();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b50();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b20();
  (**(code **)*puVar1)();
  puVar1 = (undefined4 *)FUN_00538b60();
  (**(code **)*puVar1)();
  iVar3 = 0;
  do {
    iVar2 = FUN_00538b70(iVar3);
    *(int *)(iVar2 + 0x24) = iVar3;
    puVar1 = (undefined4 *)FUN_00538b70(iVar3);
    (**(code **)*puVar1)();
    iVar3 = iVar3 + 1;
  } while (iVar3 < 2);
  iVar3 = 0;
  do {
    iVar2 = FUN_00538b80(iVar3);
    *(int *)(iVar2 + 0x24) = iVar3;
    puVar1 = (undefined4 *)FUN_00538b80(iVar3);
    (**(code **)*puVar1)();
    iVar3 = iVar3 + 1;
  } while (iVar3 < 2);
  iVar3 = 0;
  do {
    iVar2 = FUN_00538b90(iVar3);
    *(int *)(iVar2 + 0x24) = iVar3;
    puVar1 = (undefined4 *)FUN_00538b90(iVar3);
    (**(code **)*puVar1)();
    iVar3 = iVar3 + 1;
  } while (iVar3 < 0x1a);
  return;
}

