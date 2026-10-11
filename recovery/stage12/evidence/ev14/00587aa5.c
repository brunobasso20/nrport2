/* NR2003.exe @ 00587aa5 recovered_00587aa5 */

void recovered_00587aa5(void)

{
  undefined4 *puVar1;
  int iVar2;
  undefined4 *puVar3;
  undefined4 in_stack_0000001c;
  
  FUN_005662d0();
  puVar1 = (undefined4 *)FUN_005d44c0();
  puVar3 = (undefined4 *)&stack0x00000008;
  for (iVar2 = 7; iVar2 != 0; iVar2 = iVar2 + -1) {
    *puVar3 = *puVar1;
    puVar1 = puVar1 + 1;
    puVar3 = puVar3 + 1;
  }
  FUN_005d4ec0(in_stack_0000001c);
  return;
}

