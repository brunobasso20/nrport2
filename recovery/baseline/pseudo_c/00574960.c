/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00574960 */

void FUN_00574960(int param_1)

{
  int iVar1;
  char cVar2;
  undefined1 uVar3;
  int iVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  undefined8 uVar7;
  undefined4 *local_c;
  undefined4 *local_8;
  undefined4 *local_4;
  
  cVar2 = FUN_0059b2d0();
  if (cVar2 != '\0') {
    iVar1 = param_1 * 0xce;
    iVar4 = DAT_00c74e08 * 0x1c;
    local_c = (undefined4 *)((int)&DAT_00c727e6 + iVar1);
    puVar5 = (undefined4 *)(&DAT_00c727f2 + iVar1);
    puVar6 = (undefined4 *)(&DAT_00c727f6 + iVar1);
    DAT_00c74e08 = DAT_00c74e08 + 1;
    *(undefined4 *)(&DAT_00c721f0 + iVar4) = *local_c;
    local_8 = (undefined4 *)(&DAT_00c727ea + iVar1);
    *(undefined4 *)(&DAT_00c721f4 + iVar4) = *local_8;
    local_4 = (undefined4 *)(&DAT_00c727ee + iVar1);
    *(undefined4 *)(&DAT_00c721f8 + iVar4) = *local_4;
    *(undefined4 *)(&DAT_00c721fc + iVar4) = *puVar5;
    *(undefined4 *)(&DAT_00c72200 + iVar4) = *puVar6;
    *(undefined4 *)(&DAT_00c72204 + iVar4) = *(undefined4 *)(&DAT_00c727fa + iVar1);
    *(int *)(&DAT_00c72208 + iVar4) = param_1;
    goto LAB_00574af5;
  }
  iVar1 = param_1 * 0xce;
  local_c = (undefined4 *)((int)&DAT_00c727e6 + iVar1);
  if (*(int **)((int)&DAT_00c727e6 + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)((int)&DAT_00c727e6 + iVar1) + 4))();
  }
  local_8 = (undefined4 *)(&DAT_00c727ea + iVar1);
  if (*(int **)(&DAT_00c727ea + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00c727ea + iVar1) + 4))();
  }
  local_4 = (undefined4 *)(&DAT_00c727ee + iVar1);
  if (*(int **)(&DAT_00c727ee + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00c727ee + iVar1) + 4))();
  }
  puVar5 = (undefined4 *)(&DAT_00c727f2 + iVar1);
  if (*(int **)(&DAT_00c727f2 + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00c727f2 + iVar1) + 4))();
  }
  puVar6 = (undefined4 *)(&DAT_00c727f6 + iVar1);
  if (*(int **)(&DAT_00c727f6 + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00c727f6 + iVar1) + 4))();
  }
  if (*(int **)(&DAT_00c727fa + iVar1) != (int *)0x0) {
    (**(code **)(**(int **)(&DAT_00c727fa + iVar1) + 4))();
  }
  uVar7 = FUN_00574370(param_1);
  if ((int)uVar7 == 0) {
LAB_00574ad8:
    uVar3 = 0;
  }
  else {
    iVar4 = FUN_00574370((int)((ulonglong)uVar7 >> 0x20));
    if (*(int *)(iVar4 + 0x94) == 0) goto LAB_00574ad8;
    uVar3 = 1;
  }
  (&DAT_00c72733)[iVar1] = uVar3;
  (&DAT_00c72732)[iVar1] = 1;
  (&DAT_00c72734)[iVar1] = 0;
  (&DAT_00c72735)[iVar1] = 0;
LAB_00574af5:
  *(undefined4 *)(&DAT_00c727fa + param_1 * 0xce) = 0;
  *puVar6 = 0;
  *puVar5 = 0;
  *local_c = 0;
  *local_8 = 0;
  *local_4 = 0;
  return;
}


