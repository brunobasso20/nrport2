/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00525960 */

int FUN_00525960(int param_1,int param_2,int param_3)

{
  int *piVar1;
  int *piVar2;
  
  if (param_3 == 0) {
    piVar1 = (int *)(&DAT_00761196)[param_2 * 0xdc];
    if (piVar1 == (int *)0x0) {
      (&DAT_0076119a)[param_2 * 0xdc + param_1] = 0;
      return (&DAT_0076119a)[param_2 * 0xdc + param_1];
    }
    piVar2 = &DAT_0076119a + param_2 * 0xdc + param_1;
  }
  else {
    piVar1 = (int *)(&DAT_007610c0)[param_2 * 0xdc];
    if (piVar1 == (int *)0x0) {
      piVar2 = &DAT_007610c4 + param_2 * 0xdc + param_1;
      *piVar2 = 0;
      goto LAB_005259d6;
    }
    piVar2 = &DAT_007610c4 + param_2 * 0xdc + param_1;
  }
  if (*piVar2 == 0) {
    (**(code **)(*piVar1 + 8))(piVar2);
    return *piVar2;
  }
LAB_005259d6:
  return *piVar2;
}


