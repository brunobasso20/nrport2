/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00562530 */

void FUN_00562530(void)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  int local_4;
  
  puVar4 = &DAT_00c124e8;
  local_4 = 0x30;
  do {
    puVar1 = puVar4 + -2;
    puVar4[-300] = 0;
    puVar4[-0x12d] = 0;
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar3 = FUN_004f6900();
    *puVar4 = uVar3;
    uVar3 = FUN_004f6900();
    *puVar1 = uVar3;
    uVar3 = FUN_004f6900();
    puVar2 = (undefined4 *)*puVar4;
    puVar4[-1] = uVar3;
    uVar3 = FUN_005cfcfc();
    *puVar2 = uVar3;
    *(undefined4 *)*puVar1 = *(undefined4 *)*puVar4;
    FUN_00425e80(puVar4[-1],*puVar1,&DAT_00f72118,4);
    FUN_005f5870(puVar4 + 1,0x20);
    puVar1 = puVar4 + 10;
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar3 = FUN_004f6900();
    puVar4[0xc] = uVar3;
    uVar3 = FUN_004f6900();
    *puVar1 = uVar3;
    uVar3 = FUN_004f6900();
    puVar4[0xb] = uVar3;
    FUN_004f68c0(puVar4[0xc],4);
    *(undefined4 *)*puVar1 = *(undefined4 *)puVar4[0xc];
    FUN_00425e80(puVar4[0xb],*puVar1,&DAT_00f72118,4);
    FUN_005f5870(puVar4 + 0xd,0x20);
    FUN_004f6560();
    puVar4[-0x12e] = &PTR_DAT_006f5dec;
    FUN_00401fc0((int)puVar4 + 0xcce,4,4,FUN_004ed0c0);
    FUN_00401fc0((int)puVar4 + 0xcee,4,4,FUN_004ed0c0);
    FUN_00401fc0((int)puVar4 + 0xd03,4,4,FUN_004ed0c0);
    FUN_004ed0c0();
    puVar4[-0x12e] = &PTR_FUN_006f5dc8;
    puVar4 = puVar4 + 0x56e;
    local_4 = local_4 + -1;
  } while (local_4 != 0);
  return;
}


