/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00522320 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00522320(int param_1)

{
  undefined1 uVar1;
  char cVar2;
  int *piVar3;
  float10 fVar4;
  undefined4 uVar5;
  double dVar6;
  
  *(undefined4 *)(param_1 + 0x93) = 2;
  *(undefined1 *)(param_1 + 0x86) = 1;
  if ((((*(char *)(param_1 + 0x87) != '\0') || (_DAT_006ed67c <= *(float *)(param_1 + 0xa7))) ||
      (*(char *)(param_1 + 0xd2) == '\0')) || (*(char *)(param_1 + 0xd3) == '\0')) {
    uVar1 = 0;
  }
  else {
    uVar1 = 1;
  }
  *(undefined1 *)(param_1 + 0xc9) = uVar1;
  *(undefined1 *)(param_1 + 0xfc) = 1;
  *(undefined1 *)(param_1 + 0xfd) = 1;
  if ((*(char *)(param_1 + 0x10d) != '\0') && (*(char *)(param_1 + 0x111) != '\0')) {
    FUN_005234b0();
    FUN_00523520();
  }
  FUN_005202f0();
  if (_DAT_006ea4cc <= *(float *)(param_1 + 0x109)) {
    *(undefined1 *)(param_1 + 0xc9) = 0;
  }
  if (*(char *)(param_1 + 0x8d) == '\0') {
    uVar5 = *(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2);
    fVar4 = (float10)FUN_00509a20();
    dVar6 = (double)fVar4;
    FUN_00538ab0(uVar5,dVar6);
    FUN_0053b270(uVar5,dVar6);
    if ((*(char *)(param_1 + 0x10d) != '\0') && (*(char *)(param_1 + 0x111) != '\0')) {
      FUN_004f7650();
    }
  }
  else {
    piVar3 = (int *)FUN_00538b40();
    (**(code **)(*piVar3 + 0x2c))();
    FUN_00538b20();
    FUN_00540880();
  }
  if (_DAT_006ea4cc <= *(float *)(param_1 + 0x109)) {
    *(undefined1 *)(param_1 + 0x10e) = 1;
    *(undefined4 *)(param_1 + 0xb9) = *(undefined4 *)(param_1 + 0x109);
  }
  else {
    *(undefined1 *)(param_1 + 0x10e) = 0;
    cVar2 = FUN_00520f40();
    if (cVar2 == '\0') {
      *(undefined1 *)(param_1 + 0x8e) = 0;
      FUN_00521ee0(1);
      if (*(char *)(param_1 + 0x8d) != '\0') {
        piVar3 = (int *)FUN_00538b40();
        (**(code **)(*piVar3 + 0x2c))();
        FUN_00538b20();
        FUN_00540880();
      }
    }
  }
  *(undefined1 *)(param_1 + 0x100) = 0;
  *(undefined1 *)(param_1 + 0x101) = 0;
  *(undefined1 *)(param_1 + 0x102) = 0;
  *(undefined1 *)(param_1 + 0x103) = 0;
  FUN_0051a7d0(1);
  FUN_0051a800(1);
  return;
}


