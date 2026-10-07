/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00437e30 */

void __fastcall FUN_00437e30(int *param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  char *pcVar5;
  undefined4 *puVar6;
  float10 fVar7;
  undefined1 uStack_1c;
  undefined4 uStack_1b;
  undefined4 uStack_17;
  undefined4 uStack_13;
  undefined4 uStack_f;
  undefined2 uStack_b;
  undefined1 uStack_9;
  
  cVar1 = (**(code **)(*param_1 + 0x24))();
  if (cVar1 != '\0') {
    FUN_005d0cd0();
    iVar2 = FUN_005d0420();
    uStack_1b = 0;
    uStack_1c = DAT_00894888;
    uStack_17 = 0;
    pcVar5 = (char *)((int)param_1 + 0x10e);
    iVar3 = *(int *)((int)param_1 + 0x10a) << 2;
    uStack_13 = 0;
    uStack_f = 0;
    uStack_b = 0;
    uStack_9 = 0;
    puVar6 = (undefined4 *)((int)param_1 + 0x1d);
    do {
      if (iVar3 < iVar2) {
        if (*pcVar5 != '\0') {
          (**(code **)(*(int *)*puVar6 + 0x44))();
          *pcVar5 = '\0';
        }
        fVar7 = (float10)FUN_005d0750();
        if ((fVar7 != (float10)*(float *)((int)puVar6 + 0xa9)) ||
           (*(char *)((int)param_1 + 0xc5) != '\0')) {
          FUN_006c4f81(&uStack_1c,s____3f_007262c0,(double)(float)fVar7);
          if ((int *)**(int **)(puVar6[0x24] + 0x1ae) != (int *)0x0) {
            (**(code **)(*(int *)**(int **)(puVar6[0x24] + 0x1ae) + 0x6c))();
          }
          FUN_005d0770();
          FUN_006c5018();
          FUN_005fdd50();
          *(float *)((int)puVar6 + 0xa9) = (float)fVar7;
        }
        iVar4 = FUN_005d07c0();
        if ((iVar4 != *(int *)((int)puVar6 + 0xb9)) || (*(char *)((int)param_1 + 0xc5) != '\0')) {
          FUN_006c4f81(&uStack_1c,&DAT_007262c8,iVar4);
          if ((int *)**(int **)(puVar6[0x18] + 0x1ae) != (int *)0x0) {
            (**(code **)(*(int *)**(int **)(puVar6[0x18] + 0x1ae) + 0x6c))();
          }
          *(int *)((int)puVar6 + 0xb9) = iVar4;
        }
        iVar4 = FUN_005d07e0();
        if ((iVar4 != *(int *)((int)puVar6 + 0xc9)) || (*(char *)((int)param_1 + 0xc5) != '\0')) {
          FUN_006c4f81(&uStack_1c,&DAT_007262cc,iVar4);
          if ((int *)**(int **)(puVar6[0x1c] + 0x1ae) != (int *)0x0) {
            (**(code **)(*(int *)**(int **)(puVar6[0x1c] + 0x1ae) + 0x6c))();
          }
          *(int *)((int)puVar6 + 0xc9) = iVar4;
        }
        iVar4 = FUN_005d07a0();
        if ((iVar4 != *(int *)((int)puVar6 + 0xd9)) || (*(char *)((int)param_1 + 0xc5) != '\0')) {
          FUN_006c4f81(&uStack_1c,&DAT_007262d0,iVar4);
          if ((int *)**(int **)(puVar6[0x20] + 0x1ae) != (int *)0x0) {
            (**(code **)(*(int *)**(int **)(puVar6[0x20] + 0x1ae) + 0x6c))();
          }
          *(int *)((int)puVar6 + 0xd9) = iVar4;
        }
      }
      else if (*pcVar5 == '\0') {
        (**(code **)(*(int *)*puVar6 + 0x48))();
        *pcVar5 = '\x01';
      }
      iVar3 = iVar3 + 1;
      pcVar5 = pcVar5 + 1;
      puVar6 = puVar6 + 1;
    } while ((int)(pcVar5 + (-0x10e - (int)param_1)) < 4);
    iVar3 = *(int *)((int)param_1 + 0x10a);
    *(undefined1 *)((int)param_1 + 0xc5) = 0;
    if (iVar3 == 0) {
      if (*(char *)((int)param_1 + 0x116) == '\0') {
        (**(code **)(**(int **)((int)param_1 + 0xbd) + 0x4c))();
        *(undefined1 *)((int)param_1 + 0x116) = 1;
      }
    }
    else if (*(char *)((int)param_1 + 0x116) != '\0') {
      (**(code **)(**(int **)((int)param_1 + 0xbd) + 0x50))();
      *(undefined1 *)((int)param_1 + 0x116) = 0;
    }
    if (iVar3 * 4 + 4 < iVar2) {
      if (*(char *)((int)param_1 + 0x117) != '\0') {
        (**(code **)(**(int **)((int)param_1 + 0xc1) + 0x50))();
        *(undefined1 *)((int)param_1 + 0x117) = 0;
      }
    }
    else if (*(char *)((int)param_1 + 0x117) == '\0') {
      (**(code **)(**(int **)((int)param_1 + 0xc1) + 0x4c))();
      *(undefined1 *)((int)param_1 + 0x117) = 1;
      return;
    }
  }
  return;
}


