/* NR2003.exe @ 00557d20 FUN_00557d20 */

void __fastcall FUN_00557d20(undefined4 *param_1)

{
  int iVar1;
  undefined4 uVar2;
  undefined2 *puVar3;
  
  puVar3 = &DAT_00c05150;
  do {
    iVar1 = *(int *)(puVar3 + 1);
    if ((iVar1 == 0) || (*(int *)(iVar1 + 0x12) == 0)) {
      *param_1 = 0;
    }
    else {
      uVar2 = (**(code **)(iVar1 + 0x12))(*(undefined4 *)(iVar1 + 0xe));
      *param_1 = uVar2;
    }
    puVar3 = puVar3 + 3;
    param_1 = param_1 + 1;
  } while ((int)puVar3 < 0xc055a0);
  return;
}

