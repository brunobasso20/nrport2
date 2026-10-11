/* NR2003.exe @ 00540390 FUN_00540390 */

void __fastcall FUN_00540390(int param_1)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  int iVar3;
  undefined4 *puVar4;
  
  puVar2 = (undefined4 *)(param_1 + 0x453);
  puVar1 = (undefined4 *)(param_1 + 0x46d);
  puVar4 = puVar2;
  for (iVar3 = 6; iVar3 != 0; iVar3 = iVar3 + -1) {
    *puVar4 = *puVar1;
    puVar1 = puVar1 + 1;
    puVar4 = puVar4 + 1;
  }
  *(undefined2 *)puVar4 = *(undefined2 *)puVar1;
  if (*(char *)puVar2 != -1) {
    puVar1 = (undefined4 *)FUN_00536280(*(char *)puVar2);
    if (puVar1 != (undefined4 *)0x0) {
      *puVar1 = *(undefined4 *)(param_1 + 0x455);
      puVar1[1] = *(undefined4 *)(param_1 + 0x459);
      puVar1[2] = *(undefined4 *)(param_1 + 0x45d);
      FUN_00524910(*(undefined *)puVar2,puVar1);
    }
  }
  if (*(char *)(param_1 + 0x454) != -1) {
    puVar2 = (undefined4 *)FUN_00536080(*(char *)(param_1 + 0x454));
    if (puVar2 != (undefined4 *)0x0) {
      *puVar2 = *(undefined4 *)(param_1 + 0x461);
      puVar2[1] = *(undefined4 *)(param_1 + 0x465);
      puVar2[2] = *(undefined4 *)(param_1 + 0x469);
    }
  }
  *(undefined *)(param_1 + 0x452) = 1;
  return;
}

