/* NR2003.exe @ 10011b10 recovered_10011b10 */

void __fastcall recovered_10011b10(void *param_1)

{
  undefined4 uVar1;
  int iVar2;
  float10 fVar3;
  char cStack_5;
  float fStack_4;
  
  cStack_5 = '\0';
  uVar1 = FUN_100244d0(DAT_10042dcc,(float *)((int)param_1 + 0x10),&cStack_5);
  if ((char)uVar1 != '\0') {
    fStack_4 = *(float *)(DAT_10042dbc + 0x14);
    if (*(char *)((int)param_1 + 0x44) == '\0') {
      fVar3 = (float10)(**(code **)(*DAT_10042dc4 + 0x20))();
    }
    else {
      fVar3 = (float10)(**(code **)(*DAT_10042dc4 + 0x24))();
    }
    fStack_4 = (float)(fVar3 * (float10)fStack_4);
    iVar2 = FUN_100118e0(param_1,fStack_4);
    (**(code **)(**(int **)(*(int *)((int)param_1 + 0x40) + iVar2 * 4) + 0x14))();
    DAT_10042a1c = DAT_10042a1c + -1;
    *(char *)((int)DAT_10042dcc + 0x20b0) = cStack_5;
  }
  return;
}

