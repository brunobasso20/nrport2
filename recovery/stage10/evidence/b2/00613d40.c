/* NR2003.exe @ 00613d40 FUN_00613d40 */

void __fastcall FUN_00613d40(int param_1)

{
  int iVar1;
  char *pcVar2;
  int **ppiStack_c;
  
  pcVar2 = (char *)(*(int *)(param_1 + 0xe) + 0x1ed);
  if (*pcVar2 != '\0') {
    ppiStack_c = *(int ***)(param_1 + 0x1ae);
    if (*ppiStack_c != (int *)0x0) {
      iVar1 = **ppiStack_c;
      FUN_005fa970(&ppiStack_c,pcVar2);
      (**(code **)(iVar1 + 0x78))();
    }
  }
  return;
}

