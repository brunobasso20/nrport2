/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051fe50 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

bool __thiscall FUN_0051fe50(int param_1_00,float param_1)

{
  undefined4 *puVar1;
  code *pcVar2;
  char cVar3;
  float10 fVar4;
  
  if (*(int *)(param_1_00 + 0x2d) == 0) {
    *(float *)(param_1_00 + 0x21) = param_1 + *(float *)(param_1_00 + 0x21);
    if (*(int *)(param_1_00 + 0x66) != *(int *)(param_1_00 + 0x6a)) {
      *(undefined4 *)(param_1_00 + 0x62) = 0;
      puVar1 = (undefined4 *)**(undefined4 **)(param_1_00 + 0x6e + *(int *)(param_1_00 + 0x66) * 8);
      cVar3 = FUN_0040e780(*puVar1);
      if (cVar3 == '\0') {
        *(undefined4 *)(param_1_00 + 0x2d) = 0;
        *(int *)(param_1_00 + 0x66) = (*(int *)(param_1_00 + 0x66) + 1) % 10;
        return *(int *)(param_1_00 + 0x2d) != 0;
      }
      pcVar2 = *(code **)(param_1_00 + 0x25);
      if (pcVar2 != (code *)0x0) {
        (*pcVar2)((undefined4 *)(param_1_00 + 0x25),*(undefined4 *)(param_1_00 + 0x21),puVar1,
                  param_1_00 + 0x6e + *(int *)(param_1_00 + 0x66) * 8,
                  *(undefined4 *)(param_1_00 + 0xbe));
      }
      FUN_0051ff60();
      return *(int *)(param_1_00 + 0x2d) != 0;
    }
  }
  else {
    do {
      if (*(code **)(param_1_00 + 0x29) == (code *)0x0) {
        fVar4 = (float10)param_1;
      }
      else {
        fVar4 = (float10)(**(code **)(param_1_00 + 0x29))(param_1_00 + 0x25,param_1);
      }
      *(float *)(param_1_00 + 0x21) = (float)(fVar4 + (float10)*(float *)(param_1_00 + 0x21));
      param_1 = (float)((float10)param_1 - fVar4);
      FUN_0051ff60();
    } while ((_DAT_006ef604 < param_1) && (*(int *)(param_1_00 + 0x2d) != 0));
  }
  return *(int *)(param_1_00 + 0x2d) != 0;
}


