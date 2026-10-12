/* NR2003.exe @ 00428120 FUN_00428120 */

void __fastcall FUN_00428120(undefined4 *param_1)

{
  int *piVar1;
  
  piVar1 = *(int **)((int)param_1 + 0x56);
  *param_1 = &PTR_LAB_006ee48c;
  if (piVar1 != (int *)0x0) {
    if (*(int **)((int)param_1 + 0x52) != (int *)0x0) {
      (**(code **)(**(int **)((int)param_1 + 0x52) + 0x44))(piVar1);
    }
    (**(code **)(*piVar1 + 4))();
    *(undefined4 *)((int)param_1 + 0x56) = 0;
  }
  piVar1 = *(int **)((int)param_1 + 0x66);
  if (piVar1 != (int *)0x0) {
    if (*(int **)((int)param_1 + 0x52) != (int *)0x0) {
      (**(code **)(**(int **)((int)param_1 + 0x52) + 0x3c))(piVar1);
    }
    (**(code **)(*piVar1 + 4))();
    *(undefined4 *)((int)param_1 + 0x66) = 0;
  }
  if (*(int **)((int)param_1 + 0x62) != (int *)0x0) {
    (**(code **)(**(int **)((int)param_1 + 0x62) + 4))();
  }
  *(undefined4 *)((int)param_1 + 0x62) = 0;
  if (*(int **)((int)param_1 + 0x52) != (int *)0x0) {
    (**(code **)(**(int **)((int)param_1 + 0x52) + 4))();
  }
  *(undefined4 *)((int)param_1 + 0x52) = 0;
  if (*(int **)((int)param_1 + 0x5a) != (int *)0x0) {
    (**(code **)(**(int **)((int)param_1 + 0x5a) + 4))();
  }
  *(undefined4 *)((int)param_1 + 0x5a) = 0;
  if (*(int **)((int)param_1 + 0x5e) != (int *)0x0) {
    (**(code **)(**(int **)((int)param_1 + 0x5e) + 4))();
  }
  *(undefined4 *)((int)param_1 + 0x5e) = 0;
  FUN_00441e50();
  return;
}

