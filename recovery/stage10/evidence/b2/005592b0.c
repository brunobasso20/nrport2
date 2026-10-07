/* NR2003.exe @ 005592b0 FUN_005592b0 */

void FUN_005592b0(undefined4 param_1,undefined4 param_2,char *param_3,char *param_4,char *param_5)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined4 local_304;
  char local_203 [257];
  char local_102 [258];
  
  puVar3 = &local_304;
  for (iVar2 = 0xc0; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  *(undefined2 *)puVar3 = 0;
  *(undefined *)((int)puVar3 + 2) = 0;
  FUN_00558fa0(param_1,param_2,&local_304);
  if (param_3 != (char *)0x0) {
    iVar2 = (int)&local_304 - (int)param_3;
    do {
      cVar1 = *param_3;
      param_3[iVar2] = cVar1;
      param_3 = param_3 + 1;
    } while (cVar1 != '\0');
  }
  if (param_4 != (char *)0x0) {
    iVar2 = -(int)param_4;
    do {
      cVar1 = *param_4;
      param_4[(int)(local_203 + iVar2)] = cVar1;
      param_4 = param_4 + 1;
    } while (cVar1 != '\0');
  }
  if (param_5 != (char *)0x0) {
    iVar2 = -(int)param_5;
    do {
      cVar1 = *param_5;
      param_5[(int)(local_102 + iVar2)] = cVar1;
      param_5 = param_5 + 1;
    } while (cVar1 != '\0');
  }
  FUN_005590d0(param_1,param_2,&local_304);
  return;
}

