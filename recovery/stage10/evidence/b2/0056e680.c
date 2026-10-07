/* NR2003.exe @ 0056e680 FUN_0056e680 */

void FUN_0056e680(undefined *param_1)

{
  int iVar1;
  undefined4 *puVar2;
  
  if (param_1 != (undefined *)0x0) {
    *param_1 = 0;
    param_1[0x20] = 0;
    *(undefined4 *)(param_1 + 0x40) = 0;
    *(undefined4 *)(param_1 + 0x67) = 0;
    puVar2 = (undefined4 *)(param_1 + 0x44);
    for (iVar1 = 8; iVar1 != 0; iVar1 = iVar1 + -1) {
      *puVar2 = 0;
      puVar2 = puVar2 + 1;
    }
    *(undefined2 *)puVar2 = 0;
    *(undefined *)((int)puVar2 + 2) = 0;
  }
  return;
}

