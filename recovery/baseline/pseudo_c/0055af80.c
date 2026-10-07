/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0055af80 */

void FUN_0055af80(void)

{
  char cVar1;
  undefined4 uVar2;
  int iVar3;
  float10 fVar4;
  undefined8 uVar5;
  undefined1 auStack_a0 [4];
  undefined4 uStack_9c;
  undefined1 auStack_90 [8];
  undefined1 auStack_88 [8];
  undefined1 auStack_80 [128];
  
  uVar2 = FUN_005c2d40();
  switch(uVar2) {
  case 0:
  case 1:
  case 3:
  case 4:
    FUN_0055a4f0();
    break;
  case 2:
    FUN_005b5cb0();
    iVar3 = FUN_005c2ea0(DAT_00c08194);
    while ((0 < iVar3 && (iVar3 = FUN_0055a5a0(), iVar3 == 3))) {
      uVar5 = CONCAT44(auStack_90,1);
      uVar2 = DAT_00c08194;
      FUN_005c2f70();
      iVar3 = FUN_005c3650(auStack_90,uVar2,uVar5);
      if (iVar3 == 5) {
        FUN_0055b140();
      }
      iVar3 = FUN_005c2ea0();
    }
    iVar3 = FUN_0055a5a0();
    if ((iVar3 == 3) && (iVar3 = FUN_005c2e40(), 0 < iVar3)) {
      FUN_005c3670(auStack_a0,4);
      uStack_9c = FUN_0055a6f0();
      FUN_005c2ec0(DAT_00c08194,1,auStack_a0);
    }
    cVar1 = FUN_005c2cf0();
    if (((cVar1 != '\0') && (DAT_00c081d4 = DAT_00c081d4 + -1, DAT_00c081d4 < 0)) &&
       (cVar1 = FUN_0057af40(), cVar1 != '\0')) {
      fVar4 = (float10)FUN_005c32d0();
      FUN_006c4f81(auStack_80,s____d__5_3f_0074de70,0x464,(double)(fVar4 + fVar4));
      FUN_0055c800(1,auStack_80);
      FUN_005cfeb8();
      fVar4 = (float10)FUN_005c3320();
      FUN_006c4f81(auStack_88,s____d__5_3f_0074de7c,0x465,(double)fVar4);
      FUN_0055c800(1,auStack_88);
      FUN_005cfeb8();
      DAT_00c081d4 = taskGetRate();
      return;
    }
  }
  return;
}


