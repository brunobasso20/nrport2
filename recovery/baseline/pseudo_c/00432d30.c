/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00432d30 */

void FUN_00432d30(void)

{
  undefined4 *puVar1;
  int iVar2;
  undefined4 *puVar3;
  int *piVar4;
  
  if (DAT_00894790 != (undefined4 *)0x0) {
    piVar4 = &DAT_0089478c;
    puVar3 = DAT_00894790;
    do {
      puVar1 = (undefined4 *)*piVar4;
      iVar2 = puVar1[0xf];
      puVar1[0xf] = iVar2 + -1;
      if (iVar2 + -1 < 1) {
        (**(code **)*puVar1)(1);
        puVar3 = DAT_00894790;
      }
      *piVar4 = 0;
      piVar4 = piVar4 + -1;
    } while (0x89477b < (int)piVar4);
    iVar2 = puVar3[0xf];
    puVar3[0xf] = iVar2 + -1;
    if (iVar2 + -1 < 1) {
      (**(code **)*puVar3)(1);
    }
    DAT_00894790 = (undefined4 *)0x0;
  }
  return;
}


