/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055c520 */

void FUN_0055c520(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  float10 fVar4;
  undefined8 uVar5;
  byte abStack_90 [8];
  undefined1 auStack_88 [8];
  undefined1 auStack_80 [128];
  
  uVar2 = FUN_005c2d40();
  switch(uVar2) {
  case 0:
  case 1:
  case 3:
  case 4:
    FUN_00567140();
    FUN_0055a4f0();
    return;
  case 2:
    FUN_005b5cb0();
    iVar3 = FUN_0055a5a0();
    while (iVar3 == 5) {
      iVar3 = FUN_005c2ea0();
      if (iVar3 < 1) break;
      uVar5 = CONCAT44(abStack_90,1);
      uVar2 = DAT_00c08194;
      FUN_005c2f70();
      iVar3 = FUN_005c3650(abStack_90,uVar2,uVar5);
      if (iVar3 == 4) {
        FUN_00567140();
        FUN_0055a910();
      }
      else if (iVar3 == 5) {
        FUN_0055be60();
      }
      else if (iVar3 == 6) {
        FUN_0055c750();
      }
      iVar3 = FUN_0055a5a0();
    }
    iVar3 = FUN_0055a5a0();
    if (iVar3 == 5) {
      cVar1 = FUN_00502460();
      if (cVar1 == '\0') {
        FUN_0055a610();
        FUN_005697e0();
      }
      FUN_00503a80();
      FUN_0050d1d0();
      iVar3 = FUN_005c2e40();
      if (0 < iVar3) {
        FUN_005c3670(abStack_90,6);
        abStack_90[0] = abStack_90[0] | 0x40;
        FUN_005c2ec0(DAT_00c08194,1,abStack_90);
      }
    }
    iVar3 = FUN_0055a5a0();
    if (((iVar3 == 5) && (iVar3 = FUN_0055a5c0(), iVar3 != 3)) &&
       (cVar1 = FUN_00574d60(), cVar1 != '\0')) {
      FUN_00501b30();
      FUN_00574d00();
      FUN_005c2fb0();
    }
    cVar1 = FUN_005c2cf0();
    if (((cVar1 != '\0') && (DAT_00c081e0 = DAT_00c081e0 + -1, DAT_00c081e0 < 0)) &&
       (cVar1 = FUN_0057af40(), cVar1 != '\0')) {
      fVar4 = (float10)FUN_005c32d0();
      FUN_006c4f81(auStack_80,s____d__5_3f_0074dea0,0x464,(double)(fVar4 + fVar4));
      FUN_0055c800(1,auStack_80);
      FUN_005cfeb8();
      fVar4 = (float10)FUN_005c3320();
      FUN_006c4f81(auStack_88,s____d__5_3f_0074deac,0x465,(double)fVar4);
      FUN_0055c800(1,auStack_88);
      FUN_005cfeb8();
      DAT_00c081e0 = taskGetRate();
    }
  }
  return;
}


