/* NR2003.exe @ 004e9d10 FUN_004e9d10 */

void __thiscall FUN_004e9d10(int param_1_00,undefined4 *param_1)

{
  int iVar1;
  
  if (*(int *)(param_1_00 + 0x14) != 0) {
    FUN_005cfccc(*(int *)(param_1_00 + 0x14));
  }
  *(undefined4 **)(param_1_00 + 4) = param_1;
  switch(param_1) {
  case (undefined4 *)0x0:
    iVar1 = FUN_005cfce4(&param_1,0x20);
    if ((iVar1 != 0) && (param_1 != (undefined4 *)0x0)) {
      *param_1 = &PTR_DAT_006f38dc;
      *(undefined4 **)(param_1_00 + 0x14) = param_1;
      *param_1 = &PTR_LAB_006f3864;
      return;
    }
    break;
  case (undefined4 *)0x1:
    iVar1 = FUN_005cfce4(&param_1,0x86d);
    if ((iVar1 != 0) && (param_1 != (undefined4 *)0x0)) {
      *param_1 = &PTR_DAT_006f38dc;
      *(undefined4 **)(param_1_00 + 0x14) = param_1;
      *(undefined *)(param_1 + 8) = 0;
      *param_1 = &PTR_LAB_006f3884;
      *(undefined **)((int)param_1 + 0x861) = &LAB_004e9500;
      *(undefined **)((int)param_1 + 0x865) = &LAB_004e9510;
      *(undefined **)((int)param_1 + 0x869) = &LAB_004e9540;
      return;
    }
    break;
  case (undefined4 *)0x2:
    iVar1 = FUN_005cfce4(&param_1,0x859);
    if ((iVar1 != 0) && (param_1 != (undefined4 *)0x0)) {
      *param_1 = &PTR_DAT_006f38dc;
      *(undefined4 **)(param_1_00 + 0x14) = param_1;
      *(undefined *)(param_1 + 0xd) = 0;
      *param_1 = &PTR_LAB_006f38b0;
      *(undefined **)((int)param_1 + 0x84d) = &LAB_004e9130;
      *(undefined **)((int)param_1 + 0x851) = &LAB_004e9180;
      *(undefined **)((int)param_1 + 0x855) = &LAB_004e9200;
      return;
    }
    break;
  default:
    *(undefined4 *)(param_1_00 + 0x14) = 0;
    return;
  case (undefined4 *)0x4:
    iVar1 = FUN_005cfce4(&param_1,4);
    if ((iVar1 != 0) && (param_1 != (undefined4 *)0x0)) {
      *param_1 = &PTR_DAT_006f38dc;
      *(undefined4 **)(param_1_00 + 0x14) = param_1;
      *param_1 = &PTR_LAB_006f3838;
      return;
    }
  }
  *(undefined4 *)(param_1_00 + 0x14) = 0;
  return;
}

