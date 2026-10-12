/* NR2003.exe @ 00428710 FUN_00428710 */

undefined4 FUN_00428710(int *param_1,int param_2,int param_3)

{
  char cVar1;
  char *pcVar2;
  undefined4 uVar3;
  uint uVar4;
  uint uVar5;
  char *pcVar6;
  
  if (param_2 == 0) {
    return 0;
  }
  if ((&PTR_PTR_s_pacecar_00722cd8)[*param_1 * 5 + param_1[2]] == (undefined *)0x0) {
    return 0;
  }
  uVar3 = 0;
  pcVar2 = *(char **)((&PTR_PTR_s_pacecar_00722cd8)[*param_1 * 5 + param_1[2]] + param_1[1] * 4);
  if (pcVar2 != (char *)0x0) {
    uVar4 = 0xffffffff;
    pcVar6 = pcVar2;
    do {
      if (uVar4 == 0) break;
      uVar4 = uVar4 - 1;
      cVar1 = *pcVar6;
      pcVar6 = pcVar6 + 1;
    } while (cVar1 != '\0');
    uVar5 = 0xffffffff;
    pcVar6 = s__ui_3do_00722d60;
    do {
      if (uVar5 == 0) break;
      uVar5 = uVar5 - 1;
      cVar1 = *pcVar6;
      pcVar6 = pcVar6 + 1;
    } while (cVar1 != '\0');
    if (param_3 < (int)(~uVar4 + (~uVar5 - 1))) {
      return 0;
    }
    FUN_006c4f81(param_2,&DAT_00722d68,pcVar2,s__ui_3do_00722d60);
    uVar3 = 1;
  }
  return uVar3;
}

