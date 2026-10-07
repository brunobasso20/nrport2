/* Ghidra pseudo-C; NR2003.exe @ 00560870 */

void recovered_00560870(undefined4 *param_1)

{
  undefined4 *puStack_8;
  undefined4 *puStack_4;
  
  FUN_00550880(&puStack_8,&puStack_4);
  *(undefined4 *)*param_1 = *puStack_8;
  *(undefined4 *)param_1[1] = puStack_8[1];
  *(undefined4 *)param_1[2] = puStack_8[2];
  *(undefined4 *)param_1[3] = *puStack_4;
  *(undefined4 *)param_1[4] = puStack_4[1];
  *(undefined4 *)param_1[5] = puStack_4[2];
  return;
}

