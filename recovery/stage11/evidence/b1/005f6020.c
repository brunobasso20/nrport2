/* NR2003.exe @ 005f6020 FUN_005f6020 */

void FUN_005f6020(undefined4 *param_1)

{
  int iVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  
  puVar2 = param_1 + 0x26;
  puVar3 = param_1;
  for (iVar1 = 0x26; iVar1 != 0; iVar1 = iVar1 + -1) {
    *puVar3 = *puVar2;
    puVar2 = puVar2 + 1;
    puVar3 = puVar3 + 1;
  }
  param_1[0x4c] = param_1[0x4f];
  param_1[0x4d] = param_1[0x50];
  param_1[0x4e] = param_1[0x51];
  param_1[0x52] = param_1[0x55];
  param_1[0x53] = param_1[0x56];
  param_1[0x54] = param_1[0x57];
  return;
}

