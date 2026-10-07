/* NR2003.exe @ 005599b0 FUN_005599b0 */

void __thiscall FUN_005599b0(int param_1_00,char *param_1)

{
  char cVar1;
  uint uVar2;
  char *pcVar3;
  
  uVar2 = 0xffffffff;
  pcVar3 = param_1;
  do {
    if (uVar2 == 0) break;
    uVar2 = uVar2 - 1;
    cVar1 = *pcVar3;
    pcVar3 = pcVar3 + 1;
  } while (cVar1 != '\0');
  FUN_006c4b00(param_1_00 + 0x4f1,param_1,~uVar2 - 1);
  uVar2 = 0xffffffff;
  pcVar3 = param_1;
  do {
    if (uVar2 == 0) break;
    uVar2 = uVar2 - 1;
    cVar1 = *pcVar3;
    pcVar3 = pcVar3 + 1;
  } while (cVar1 != '\0');
  if (0xff < ~uVar2 - 1) {
    *(undefined *)(param_1_00 + 0x5f0) = 0;
    return;
  }
  uVar2 = 0xffffffff;
  do {
    if (uVar2 == 0) break;
    uVar2 = uVar2 - 1;
    cVar1 = *param_1;
    param_1 = param_1 + 1;
  } while (cVar1 != '\0');
  *(undefined *)(~uVar2 + 0x4f0 + param_1_00) = 0;
  return;
}

