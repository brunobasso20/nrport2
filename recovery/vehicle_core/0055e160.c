/* Ghidra pseudo-C; NR2003.exe @ 0055e160 */

void recovered_0055e160(undefined4 *param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  
  uVar1 = param_1[4];
  uVar2 = param_1[5];
  *(undefined4 *)*param_1 = param_1[3];
  *(undefined4 *)param_1[1] = uVar1;
  *(undefined4 *)param_1[2] = uVar2;
  return;
}

