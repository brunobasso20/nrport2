/* NR2003.exe @ 00559840 FUN_00559840 */

void __fastcall FUN_00559840(undefined4 *param_1)

{
  char cVar1;
  int iVar2;
  undefined4 *puVar3;
  
  if (param_1 != (undefined4 *)&DAT_00c055c0) {
    puVar3 = (undefined4 *)&DAT_00c055c0;
    for (iVar2 = 0x3bf; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_1;
      param_1 = param_1 + 1;
      puVar3 = puVar3 + 1;
    }
    *(undefined *)puVar3 = *(undefined *)param_1;
  }
  cVar1 = FUN_00551880();
  if (cVar1 != '\0') {
    FUN_00551800();
  }
  FUN_00550c60();
  return;
}

