/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b56c0 */

void FUN_005b56c0(void)

{
  int iVar1;
  undefined *puVar2;
  int extraout_EDX;
  undefined4 *puVar3;
  
  puVar3 = &DAT_00ea9db8;
  for (iVar1 = 0x500; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar3 = 0;
    puVar3 = puVar3 + 1;
  }
  DAT_00eab1c0 = 0;
  DAT_00eab1bc = 0;
  puVar2 = &DAT_00e95da8;
  do {
    FUN_005b4ca0(puVar2);
    puVar2 = (undefined *)(extraout_EDX + 0x40);
  } while ((int)puVar2 < 0xea5da8);
  return;
}


