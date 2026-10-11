/* NR2003.exe @ 0054bde0 FUN_0054bde0 */

void FUN_0054bde0(void)

{
  undefined4 *puVar1;
  undefined4 uVar2;
  int iVar3;
  undefined4 *puVar4;
  
  puVar4 = &DAT_00bf3a9c;
  iVar3 = 4;
  do {
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar2 = FUN_004f6900();
    *puVar4 = uVar2;
    puVar1 = puVar4 + -2;
    uVar2 = FUN_004f6900();
    *puVar1 = uVar2;
    uVar2 = FUN_004f6900();
    puVar4[-1] = uVar2;
    FUN_004f68c0(*puVar4,4);
    *(undefined4 *)*puVar1 = *(undefined4 *)*puVar4;
    FUN_00425e80(puVar4[-1],*puVar1,&DAT_00f72118,4);
    FUN_005f5870(puVar4 + 1,0x20);
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar2 = FUN_004f6900();
    puVar4[0xb] = uVar2;
    puVar1 = puVar4 + 9;
    uVar2 = FUN_004f6900();
    *puVar1 = uVar2;
    uVar2 = FUN_004f6900();
    puVar4[10] = uVar2;
    FUN_004f68c0(puVar4[0xb],4);
    *(undefined4 *)*puVar1 = *(undefined4 *)puVar4[0xb];
    FUN_00425e80(puVar4[10],*puVar1,&DAT_00f72118,4);
    FUN_005f5870(puVar4 + 0xc,0x20);
    puVar1 = puVar4 + 0x18;
    FUN_004f67d0();
    uVar2 = FUN_004f6900();
    puVar4[0x1a] = uVar2;
    uVar2 = FUN_004f6900();
    *puVar1 = uVar2;
    uVar2 = FUN_004f6900();
    puVar4[0x19] = uVar2;
    FUN_004f68c0(puVar4[0x1a],4);
    *(undefined4 *)*puVar1 = *(undefined4 *)puVar4[0x1a];
    FUN_00425e80(puVar4[0x19],*puVar1,&DAT_00f72118,4);
    FUN_005f5870(puVar4 + 0x1b,0x20);
    FUN_004f6320();
    FUN_004f6320();
    FUN_00401fc0(puVar4 + 0x39,0x2c,3,FUN_004f6320);
    FUN_00401fc0(puVar4 + 0x5a,0x2c,3,FUN_004f6320);
    FUN_004f6320();
    puVar4 = (undefined4 *)((int)puVar4 + 0xa39);
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  return;
}

