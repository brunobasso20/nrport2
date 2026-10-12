/* NR2003.exe @ 0042b030 FUN_0042b030 */

void FUN_0042b030(int param_1,int param_2)

{
  int iVar1;
  int *piVar2;
  int *piVar3;
  undefined4 local_c;
  int local_8;
  int local_4;
  
  piVar2 = (int *)(&DAT_008726f8 + (param_2 + param_1 * 4) * 0x380);
  local_c = FUN_004233a0();
  piVar3 = piVar2;
  for (iVar1 = 0xe0; iVar1 != 0; iVar1 = iVar1 + -1) {
    *piVar3 = 0;
    piVar3 = piVar3 + 1;
  }
  local_8 = param_2;
  local_4 = param_1;
  *piVar2 = param_1;
  if (param_1 == 0) {
    FUN_00429370(piVar2,&local_c);
    return;
  }
  FUN_00429a80(piVar2,&local_c);
  return;
}

