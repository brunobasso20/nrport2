/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00589260 */

void FUN_00589260(int param_1,int param_2,undefined4 param_3,float param_4,int param_5)

{
  undefined4 *puVar1;
  int iVar2;
  
  iVar2 = 0;
  if (0 < param_5) {
    do {
      if (param_4 < *(float *)(param_2 + iVar2 * 4)) break;
      iVar2 = iVar2 + 1;
    } while (iVar2 < param_5);
  }
  if (iVar2 < param_5) {
    puVar1 = (undefined4 *)(param_2 + -4 + param_5 * 4);
    do {
      *(undefined4 *)(param_1 + param_5 * 4) = *(undefined4 *)((param_1 - param_2) + (int)puVar1);
      puVar1[1] = *puVar1;
      param_5 = param_5 + -1;
      puVar1 = puVar1 + -1;
    } while (iVar2 < param_5);
  }
  *(undefined4 *)(param_1 + iVar2 * 4) = param_3;
  *(float *)(param_2 + iVar2 * 4) = param_4;
  return;
}


