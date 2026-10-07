/* NR2003.exe @ 005fdd50 FUN_005fdd50 */

void __thiscall FUN_005fdd50(int *param_1_00,int param_1)

{
  char cVar1;
  int *piVar2;
  int iVar3;
  undefined4 *puVar4;
  
  cVar1 = (**(code **)(*param_1_00 + 0x8c))(param_1);
  if ((cVar1 != '\0') && (*(int *)((int)param_1_00 + 0x9c1) != param_1)) {
    iVar3 = *(int *)((int)param_1_00 + 0x5ad);
    *(int *)((int)param_1_00 + 0x9c1) = param_1;
    if (0 < iVar3) {
      puVar4 = (undefined4 *)((int)param_1_00 + 0x1ad);
      do {
        piVar2 = (int *)FUN_005fdc90(*puVar4);
        if (piVar2 != (int *)0x0) {
          (**(code **)(*piVar2 + 0x74))(param_1);
        }
        puVar4 = puVar4 + 1;
        iVar3 = iVar3 + -1;
      } while (iVar3 != 0);
    }
    (**(code **)(*param_1_00 + 0x88))();
  }
  return;
}

