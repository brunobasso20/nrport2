/* NR2003.exe @ 00540550 FUN_00540550 */

void __fastcall FUN_00540550(int param_1)

{
  int iVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  int iVar4;
  
  iVar4 = 0;
  if (0 < *(int *)(param_1 + 0x487)) {
    puVar3 = (undefined4 *)(param_1 + 0x48d);
    do {
      iVar1 = FUN_00536170();
      if (iVar1 <= iVar4) break;
      puVar2 = (undefined4 *)FUN_00536280(iVar4);
      if (puVar2 != (undefined4 *)0x0) {
        *puVar2 = *puVar3;
        puVar2[1] = puVar3[1];
        puVar2[2] = puVar3[2];
      }
      iVar4 = iVar4 + 1;
      puVar3 = puVar3 + 3;
    } while (iVar4 < *(int *)(param_1 + 0x487));
  }
  *(undefined *)(param_1 + 0x48c) = 1;
  return;
}

