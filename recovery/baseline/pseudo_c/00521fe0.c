/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00521fe0 */

void __fastcall FUN_00521fe0(int param_1)

{
  int iVar1;
  undefined1 *puVar2;
  int iVar3;
  undefined4 *puVar4;
  
  iVar3 = 0;
  iVar1 = FUN_0040ecf0();
  if (0 < iVar1) {
    do {
      FUN_00520010();
      iVar3 = iVar3 + 1;
      iVar1 = FUN_0040ecf0();
    } while (iVar3 < iVar1);
  }
  *(undefined4 *)(param_1 + 0x8f) = 0;
  *(undefined4 *)(param_1 + 0x93) = 2;
  *(undefined1 *)(param_1 + 0x86) = 0;
  *(undefined1 *)(param_1 + 0xfc) = 1;
  *(undefined1 *)(param_1 + 0xfd) = 1;
  *(undefined1 *)(param_1 + 0x10e) = 0;
  *(undefined4 *)(param_1 + 0xb9) = 0;
  *(undefined1 *)(param_1 + 0x10f) = 0;
  *(undefined1 *)(param_1 + 0x110) = 0;
  *(undefined1 *)(param_1 + 0x112) = 0;
  *(undefined1 *)(param_1 + 0x113) = 0;
  iVar3 = 0;
  iVar1 = FUN_0040ecf0();
  if (0 < iVar1) {
    puVar4 = (undefined4 *)(param_1 + 0x287);
    do {
      *(undefined1 *)((int)puVar4 + -5) = 1;
      puVar4[-1] = 0;
      *puVar4 = 0;
      puVar4[1] = 0;
      puVar4[2] = 0;
      puVar4[3] = 0;
      iVar3 = iVar3 + 1;
      puVar4 = (undefined4 *)((int)puVar4 + 0xcb);
      iVar1 = FUN_0040ecf0();
    } while (iVar3 < iVar1);
  }
  if (*(char *)(param_1 + 0x8d) == '\0') {
    FUN_00523ac0(&DAT_00bd64e8 + *(int *)(*(int *)(param_1 + 0x89) + 0x5b2) * 0x68);
    iVar1 = 0;
    do {
      FUN_00523b00(&DAT_00bd44a8 + (iVar1 + *(int *)(*(int *)(param_1 + 0x89) + 0x5b2) * 2) * 0x34,
                   (&DAT_0074ba58)[iVar1],1);
      iVar1 = iVar1 + 1;
    } while (iVar1 < 2);
  }
  else {
    FUN_00523ac0(&DAT_00bd2318);
    iVar3 = 0;
    iVar1 = FUN_0040ecf0();
    if (0 < iVar1) {
      puVar2 = &DAT_00bd0ef0;
      do {
        FUN_00523b00(puVar2,iVar3,0);
        iVar3 = iVar3 + 1;
        puVar2 = puVar2 + 0x34;
        iVar1 = FUN_0040ecf0();
      } while (iVar3 < iVar1);
      return;
    }
  }
  return;
}


