/* NR2003.exe @ 005591f0 FUN_005591f0 */

undefined4 FUN_005591f0(undefined4 param_1,undefined4 param_2,int param_3,int param_4,int param_5)

{
  char cVar1;
  undefined4 *puVar2;
  char *pcVar3;
  int iVar4;
  undefined4 local_304;
  char local_203 [257];
  char local_102 [258];
  
  puVar2 = &local_304;
  for (iVar4 = 0xc0; iVar4 != 0; iVar4 = iVar4 + -1) {
    *puVar2 = 0;
    puVar2 = puVar2 + 1;
  }
  *(undefined2 *)puVar2 = 0;
  *(undefined *)((int)puVar2 + 2) = 0;
  iVar4 = FUN_00558fa0(param_1,param_2,&local_304);
  puVar2 = &local_304;
  if (iVar4 == 0) {
    return 0;
  }
  if (param_3 != 0) {
    do {
      cVar1 = *(char *)puVar2;
      *(char *)((int)puVar2 + (param_3 - (int)&local_304)) = cVar1;
      puVar2 = (undefined4 *)((int)puVar2 + 1);
    } while (cVar1 != '\0');
  }
  if (param_4 != 0) {
    pcVar3 = local_203;
    do {
      cVar1 = *pcVar3;
      pcVar3[param_4 - (int)local_203] = cVar1;
      pcVar3 = pcVar3 + 1;
    } while (cVar1 != '\0');
  }
  if (param_5 != 0) {
    pcVar3 = local_102;
    do {
      cVar1 = *pcVar3;
      pcVar3[param_5 - (int)local_102] = cVar1;
      pcVar3 = pcVar3 + 1;
    } while (cVar1 != '\0');
  }
  return 1;
}

