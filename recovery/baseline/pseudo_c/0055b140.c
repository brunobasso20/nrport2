/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055b140 */

void FUN_0055b140(byte *param_1)

{
  ushort uVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  float10 fVar6;
  undefined1 local_20 [32];
  
  iVar3 = FUN_0055a6f0();
  if (*(int *)(param_1 + 8) != iVar3) {
    return;
  }
  bgBeginLengthyLoadOperation();
  iVar3 = FUN_0055a680();
  iVar4 = FUN_0055a7b0();
  if ((iVar4 != 0) && (iVar4 = FUN_0055a830(), iVar4 != 0)) {
    bgEndLengthyLoadOperation();
    FUN_0055a4f0();
    FUN_00566e30();
    uVar1 = *(ushort *)(param_1 + 2);
    FUN_00566e50((int)(short)(uVar1 << 4) >> 8,uVar1 & 0xf,uVar1 >> 0xc);
    fVar6 = (float10)FUN_005c3290(DAT_00c08194);
    FUN_0055a740((double)(fVar6 + (float10)*(float *)(param_1 + 4)));
    FUN_0055a7a0();
    FUN_004233a0();
    uVar5 = FUN_004233c0();
    FUN_00424710(uVar5);
    FUN_0055aa60();
    FUN_00562f90();
    FUN_00547e90(*(uint *)(iVar3 + 0x4c) >> 0x16 & 3);
    if (*param_1 >> 6 != 0) {
      FUN_0055a940();
    }
    FUN_005c2fb0();
    return;
  }
  bgEndLengthyLoadOperation();
  FUN_005c2fb0();
  FUN_0055a650();
  iVar3 = FUN_005c2d20(DAT_00c08194);
  if (iVar3 == 1) {
    cVar2 = FUN_005c37f0(DAT_00c08194,1,0);
    if (cVar2 != '\0') {
      return;
    }
    iVar3 = FUN_005c38b0(DAT_00c08194,1,0,0);
    if (iVar3 == 0) {
      return;
    }
    FUN_00619640(local_20,0x20,0x7d6,0);
  }
  else {
    FUN_005c2910();
    FUN_00619640(local_20,0x20,0x7d7,0);
  }
  FUN_0055c800(2,local_20);
  FUN_005cfeb8();
  return;
}


