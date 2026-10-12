/* NR2003.exe @ 0056b8a0 FUN_0056b8a0 */

undefined4 FUN_0056b8a0(int param_1)

{
  char cVar1;
  float *pfVar2;
  int extraout_EDX;
  int iVar3;
  undefined8 uVar4;
  
  cVar1 = FUN_0056b710();
  if (cVar1 != '\0') {
    *(undefined4 *)(param_1 + 0xc) = *(undefined4 *)(extraout_EDX + 4);
    *(undefined4 *)(param_1 + 0x10) = *(undefined4 *)(extraout_EDX + 0xc);
    iVar3 = *(int *)(param_1 + 0xc);
    if ((0x12 < iVar3) && (iVar3 < 0x16)) {
      *(int *)(param_1 + 0x14) = iVar3 + -0x13;
      *(undefined4 *)(param_1 + 0x18) = *(undefined4 *)(extraout_EDX + 0x165 + (iVar3 + -0x13) * 4);
    }
    uVar4 = FUN_0056b720();
    iVar3 = (int)((ulonglong)uVar4 >> 0x20);
    pfVar2 = (float *)uVar4;
    *pfVar2 = *(float *)(iVar3 + 0x350) * *(float *)(iVar3 + 0x34c);
    pfVar2[7] = *(float *)(iVar3 + 0x354);
    if (*(int *)(iVar3 + 4) == 0x10) {
      pfVar2[1] = *(float *)(iVar3 + 0x171);
      pfVar2[2] = *(float *)(iVar3 + 0x175);
      pfVar2[3] = *(float *)(iVar3 + 0x179);
      pfVar2[4] = *(float *)(iVar3 + 0x17d);
      pfVar2[5] = *(float *)(iVar3 + 0x181);
      pfVar2[6] = *(float *)(iVar3 + 0x185);
      FUN_005ba070();
    }
    return 1;
  }
  DAT_00c5c279 = 0;
  return 0;
}

