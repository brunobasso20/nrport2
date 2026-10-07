/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0040f100 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0040f100(int param_1)

{
  char cVar1;
  int *piVar2;
  undefined4 unaff_ESI;
  float10 fVar3;
  undefined4 uVar4;
  undefined1 local_1;
  
  if (*(char *)(param_1 + 0x8d) == '\0') {
    fVar3 = (float10)(**(code **)(*DAT_00bdb9d8 + 0x1c))
                               (*(undefined4 *)(*(int *)(param_1 + 0x89) + 0x5b2),&local_1);
  }
  else {
    piVar2 = (int *)FUN_00538b40();
    fVar3 = (float10)(**(code **)(*piVar2 + 0x38))(&local_1);
  }
  *(float *)(param_1 + 0x109) = (float)fVar3;
  if ((*(char *)(param_1 + 0x10f) == '\0') || (*(char *)(param_1 + 0x10d) != '\0')) {
    *(char *)(param_1 + 0x10d) = (char)((uint)unaff_ESI >> 0x18);
  }
  cVar1 = FUN_00520e50();
  if (cVar1 == '\0') {
    cVar1 = FUN_00523450();
    if (cVar1 == '\0') goto LAB_0040f188;
  }
  *(undefined1 *)(param_1 + 0x10d) = 1;
LAB_0040f188:
  if ((*(char *)(param_1 + 0x10d) == '\0') || (*(char *)(param_1 + 0x111) == '\0')) {
    *(undefined1 *)(param_1 + 0xf6) = 0;
    *(undefined1 *)(param_1 + 0xf7) = 0;
    *(undefined4 *)(param_1 + 0xf8) = 0;
    if (*(char *)(param_1 + 0xb41) != '\0') {
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      *(char *)(param_1 + 0xb41) = *(char *)(param_1 + 0xb41) + -1;
    }
  }
  else {
    *(undefined1 *)(param_1 + 0xf6) = *(undefined1 *)(param_1 + 0xd4);
    *(undefined1 *)(param_1 + 0xf7) = *(undefined1 *)(param_1 + 0xd5);
    *(undefined4 *)(param_1 + 0xf8) = *(undefined4 *)(param_1 + 0xd6);
  }
  if ((*(char *)(param_1 + 0xf6) == '\0') && (*(char *)(param_1 + 0xf7) == '\0')) {
    if (*(char *)(param_1 + 0xb41) != '\0') {
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
      FUN_00520030(3,0);
    }
  }
  else {
    if (*(char *)(param_1 + 0xb41) == '\0') {
      FUN_00520030(2,0);
      FUN_00520030(2,0);
      FUN_00520030(2,2);
      FUN_00520030(2,0);
      FUN_00520030(2,2);
      *(char *)(param_1 + 0xb41) = *(char *)(param_1 + 0xb41) + '\x01';
    }
    FUN_00520030(0,0);
    FUN_00520030(0,0);
    if (*(char *)(param_1 + 0xf7) == '\0') {
      FUN_00520030(5,0);
      FUN_00520030(5,0);
      FUN_00520030(5,0);
      FUN_00520030(5,0);
      uVar4 = 5;
    }
    else {
      FUN_00520030(4,0);
      FUN_00520030(4,0);
      uVar4 = 4;
    }
    FUN_00520030(uVar4,0);
    *(char *)(param_1 + 0xb42) = *(char *)(param_1 + 0xb42) + '\x01';
  }
  if (0 < *(int *)(param_1 + 0xf8)) {
    FUN_00520030(6,4);
    FUN_00520030(6,0);
    *(char *)(param_1 + 0xb44) = *(char *)(param_1 + 0xb44) + '\x01';
  }
  if ((*(char *)(param_1 + 0xb60) == '\0') &&
     ((((*(char *)(param_1 + 0xf6) != '\0' || (*(char *)(param_1 + 0xf7) != '\0')) ||
       (0 < *(int *)(param_1 + 0xf8))) || (_DAT_006ea454 < *(float *)(param_1 + 0x109))))) {
    FUN_00520030(6,0);
    *(char *)(param_1 + 0xb60) = *(char *)(param_1 + 0xb60) + '\x01';
  }
  if (((*(char *)(param_1 + 0xb61) == '\0') && (*(char *)(param_1 + 0xf6) == '\0')) &&
     ((*(char *)(param_1 + 0xf7) == '\0' &&
      ((0 < *(int *)(param_1 + 0xf8) || (_DAT_006ea454 < *(float *)(param_1 + 0x109))))))) {
    FUN_00520030(0x33,0);
    *(char *)(param_1 + 0xb61) = *(char *)(param_1 + 0xb61) + '\x01';
  }
  FUN_00520030(0xf,0);
  return;
}


