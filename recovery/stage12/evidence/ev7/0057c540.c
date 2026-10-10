/* NR2003.exe @ 0057c540 FUN_0057c540 */

void FUN_0057c540(int param_1,int param_2)

{
  char cVar1;
  int *piVar2;
  undefined1 *puVar3;
  
  if (param_1 < 0xd7) {
    puVar3 = &DAT_00d35b1c + param_1 * 10;
    piVar2 = (int *)((int)&DAT_00d37cc8 + param_1 * 0x1d);
    do {
      if ((((DAT_00d3b028 & piVar2[-2]) != 0) && (*piVar2 == 4)) && (piVar2[1] == param_2)) {
        cVar1 = FUN_0057c510(piVar2[2]);
        if (cVar1 != '\0') {
          *(undefined4 *)(puVar3 + -4) = 0x3f800000;
        }
        *puVar3 = 1;
      }
      piVar2 = (int *)((int)piVar2 + 0x1d);
      puVar3 = puVar3 + 10;
    } while ((int)piVar2 < 0xd39523);
  }
  return;
}

