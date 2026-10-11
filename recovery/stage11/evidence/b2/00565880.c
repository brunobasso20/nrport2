/* NR2003.exe @ 00565880 FUN_00565880 */

void FUN_00565880(int param_1,int param_2)

{
  undefined4 uVar1;
  char cVar2;
  int iVar3;
  int *piVar4;
  undefined4 uVar5;
  undefined4 *puVar6;
  undefined4 *puVar7;
  undefined4 *puVar8;
  undefined4 *unaff_EBP;
  undefined4 unaff_retaddr;
  
  uVar5 = *(undefined4 *)(param_2 + 0x5ae);
  uVar1 = *(undefined4 *)(param_2 + 0x5b2);
  iVar3 = FUN_004284f0(param_2 + 0x58e);
  *(undefined4 *)(param_1 + 0x2c) = *(undefined4 *)(param_2 + 0x592);
  *(undefined4 *)(param_1 + 0x14) = 0;
  piVar4 = (int *)FUN_00574690(uVar1);
  *(int **)(param_1 + 0x18) = piVar4;
  (**(code **)(*piVar4 + 0x1c))(0,param_1 + 0x1c);
  *(undefined4 *)(param_1 + 0x4c) = *(undefined4 *)(iVar3 + 0x10);
  *(undefined4 *)(param_1 + 0x50) = *(undefined4 *)(iVar3 + 0x14);
  *(undefined4 *)(param_1 + 0x20) = *(undefined4 *)(param_2 + 0x5b2);
  *(undefined4 *)(param_1 + 0x28) = *(undefined4 *)(param_2 + 0x58a);
  *(int *)(param_1 + 0x24) = iVar3;
  cVar2 = FUN_005365c0(uVar5,0);
  *(byte *)(param_1 + 0x30) =
       (cVar2 << 2 ^ *(byte *)(param_1 + 0x30)) & 0xc ^ *(byte *)(param_1 + 0x30);
  *(byte *)(param_1 + 0x31) = (byte)(*(uint *)(param_2 + 0x14fc) >> 3) & 3;
  *(undefined *)(param_1 + 0x32) = *(undefined *)(param_2 + 0x450);
  *(undefined4 *)(param_1 + 0x68) = *(undefined4 *)(*(int *)(param_2 + 0x576) + 0x2c);
  uVar5 = FUN_005747b0(unaff_retaddr);
  *(undefined4 *)(param_1 + 0x34) = uVar5;
  *(undefined4 *)(param_1 + 0x38) = *(undefined4 *)(iVar3 + 0xec);
  *(undefined4 *)(param_1 + 0x40) = *(undefined4 *)(iVar3 + 0x94);
  *(undefined4 *)(param_1 + 0x44) = *(undefined4 *)(iVar3 + 0x6c);
  *(undefined4 *)(param_1 + 0x3c) = *(undefined4 *)(iVar3 + 0x68);
  *(undefined4 *)(param_1 + 0x48) = *(undefined4 *)(iVar3 + 0x70);
  puVar7 = (undefined4 *)(param_1 + 0x54);
  puVar6 = (undefined4 *)(param_2 + 0x1578);
  iVar3 = 4;
  do {
    uVar5 = *puVar6;
    puVar6 = puVar6 + 1;
    *puVar7 = uVar5;
    puVar7 = puVar7 + 1;
    iVar3 = iVar3 + -1;
  } while (iVar3 != 0);
  *(undefined4 *)(param_1 + 100) = *(undefined4 *)(param_2 + 0x1508);
  *(undefined4 *)(param_1 + 0x6c) = *(undefined4 *)(param_2 + 0x1518);
  *(undefined4 *)(param_1 + 0x70) = *(undefined4 *)(param_2 + 0x151c);
  *(undefined4 *)(param_1 + 0x74) = *(undefined4 *)(param_2 + 0x1520);
  *(undefined4 *)(param_1 + 0x78) = *(undefined4 *)(param_2 + 0x1524);
  *(undefined4 *)(param_1 + 0x7c) = *(undefined4 *)(param_2 + 0x1528);
  *(undefined4 *)(param_1 + 0x80) = *(undefined4 *)(param_2 + 0x152c);
  puVar7 = (undefined4 *)(param_2 + 0x1493);
  puVar6 = (undefined4 *)(param_1 + 0x90);
  for (iVar3 = 0x1a; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar6 = *puVar7;
    puVar7 = puVar7 + 1;
    puVar6 = puVar6 + 1;
  }
  *(undefined4 *)(param_1 + 0x88) = *(undefined4 *)(param_2 + 0x15b0);
  *(undefined4 *)(param_1 + 0x8c) = *(undefined4 *)(param_2 + 0x15b4);
  puVar6 = (undefined4 *)FUN_005ba150();
  puVar7 = puVar6;
  for (iVar3 = 0x26; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar7 = *unaff_EBP;
    unaff_EBP = unaff_EBP + 1;
    puVar7 = puVar7 + 1;
  }
  iVar3 = 4;
  puVar6[0x26] = *(undefined4 *)(param_2 + 0x1594);
  puVar6[0x27] = *(undefined4 *)(param_2 + 0x1598);
  puVar6[0x28] = *(undefined4 *)(param_2 + 0x159c);
  puVar6[0x29] = *(undefined4 *)(param_2 + 0x1590);
  puVar6[0x2a] = *(undefined4 *)(param_2 + 0x15a0);
  puVar6[0x2b] = *(undefined4 *)(param_2 + 0x15a4);
  puVar6[0x2c] = *(undefined4 *)(param_2 + 0x15a8);
  puVar6[0x2d] = *(undefined4 *)(param_2 + 0x1588);
  puVar6[0x2e] = *(undefined4 *)(param_2 + 0x158c);
  puVar6[0x2f] = *(undefined4 *)(param_2 + 0x1554);
  puVar6[0x30] = *(undefined4 *)(param_2 + 0x153c);
  puVar6[0x31] = *(undefined4 *)(param_2 + 0x1540);
  puVar6[0x32] = *(undefined4 *)(param_2 + 0x1544);
  puVar6[0x33] = *(undefined4 *)(param_2 + 0x1548);
  puVar6[0x34] = *(undefined4 *)(param_2 + 0x154c);
  puVar6[0x35] = *(undefined4 *)(param_2 + 0x1550);
  puVar7 = puVar6 + 0x3a;
  puVar8 = (undefined4 *)(param_2 + 0x1568);
  do {
    puVar7[-4] = puVar8[-4];
    *puVar7 = *puVar8;
    puVar7 = puVar7 + 1;
    iVar3 = iVar3 + -1;
    puVar8 = puVar8 + 1;
  } while (iVar3 != 0);
  puVar6[0x3e] = *(undefined4 *)(param_2 + 0x15ac);
  FUN_005ba070();
  return;
}

