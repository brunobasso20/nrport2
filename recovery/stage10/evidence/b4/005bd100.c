/* NR2003.exe @ 005bd100 FUN_005bd100 */

void FUN_005bd100(int param_1,uint param_2,uint param_3)

{
  uint *puVar1;
  
  puVar1 = (uint *)FUN_005bd0d0();
  *puVar1 = (*puVar1 & 2 | 1) ^ param_1 << 2;
  puVar1[1] = param_2;
  if (param_2 != 0) {
    *(int *)(param_2 + 0xc) = *(int *)(param_2 + 0xc) + 1;
  }
  puVar1[2] = param_3;
  if ((param_3 != 0) && (param_2 != param_3)) {
    *(int *)(param_3 + 0xc) = *(int *)(param_3 + 0xc) + 1;
  }
  puVar1[3] = 0;
  puVar1[4] = 0;
  *puVar1 = *puVar1 & 0xfffffffd;
  return;
}

