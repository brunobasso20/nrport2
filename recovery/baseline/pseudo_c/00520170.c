/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00520170 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_00520170(int *param_1)

{
  float fVar1;
  int iVar2;
  float10 fVar3;
  char cVar4;
  int iVar5;
  float10 fVar6;
  
  if (*(char *)((int)param_1 + 9) == '\0') {
    fVar1 = *(float *)((int)param_1 + 0xb);
    FUN_00521000();
    fVar6 = (float10)FUN_005208c0();
    fVar3 = (float10)_DAT_006ea454;
    *(float *)((int)param_1 + 0xb) = (float)fVar6;
    if (fVar6 <= fVar3) {
      *(undefined1 *)((int)param_1 + 10) = 0;
    }
    else {
      if ((float10)_DAT_006f4a20 < ABS((float10)fVar1 - fVar6)) {
        *(undefined1 *)((int)param_1 + 10) = 1;
      }
      cVar4 = FUN_00520e50();
      if (cVar4 != '\0') {
        *(undefined1 *)((int)param_1 + 10) = 1;
      }
    }
    if (((char)param_1[1] != '\0') && (*(int *)(*param_1 + 0x5ae) != 0)) {
      (**(code **)(*(int *)*param_1 + 8))();
      iVar2 = *(int *)(*param_1 + 0x5ae);
      iVar5 = taskGetRate();
      FUN_0054b4f0(*(float *)(iVar2 + 0x44) / (float)iVar5);
      return;
    }
  }
  else if ((((char)param_1[1] != '\0') && (*(char *)((int)param_1 + 0x15e) != '\0')) &&
          (((byte)*(undefined4 *)(*param_1 + 0x554) & 0x20) == 0x20)) {
    FUN_0051a7d0(0);
    FUN_0051a800(0);
  }
  return;
}


