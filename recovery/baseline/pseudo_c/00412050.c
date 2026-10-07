/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00412050 */

void FUN_00412050(int param_1,undefined4 *param_2,int *param_3,undefined4 param_4,char param_5)

{
  int iVar1;
  int iVar2;
  undefined *puVar3;
  undefined4 *puVar4;
  char cVar5;
  int local_8;
  char local_4;
  
  puVar3 = (&PTR_DAT_007216d8)[param_1];
  if (param_5 == '\0') {
    puVar3 = puVar3 + 0x1899;
  }
  cVar5 = puVar3[0x1894] == '\0';
  if ((DAT_007668d8 != '\0') && ((bool)cVar5)) {
    iVar1 = *(int *)(puVar3 + 0x1890);
    if (iVar1 == 0) {
      local_8 = param_1;
      local_4 = param_5;
      param_5 = cVar5;
      bgRequestFGAction((_func_void_void_ptr_void_ptr *)&LAB_004120f0,&local_8,&param_5);
      puVar3[0x1894] = param_5 == '\0';
      cVar5 = param_5;
    }
    if (cVar5 != '\0') {
      if (0 < iVar1) {
        puVar4 = (undefined4 *)(puVar3 + 0x1880);
        for (iVar2 = iVar1; iVar2 != 0; iVar2 = iVar2 + -1) {
          *param_2 = *puVar4;
          puVar4 = puVar4 + 1;
          param_2 = param_2 + 1;
        }
      }
      *param_3 = iVar1;
    }
  }
  return;
}


