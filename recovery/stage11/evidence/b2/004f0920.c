/* NR2003.exe @ 004f0920 FUN_004f0920 */

void __thiscall
FUN_004f0920(int param_1_00,undefined4 *param_1,undefined4 *param_2,undefined param_3)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 *puVar3;
  
  *(undefined *)(param_1_00 + 0x152) = param_3;
  *(bool *)(param_1_00 + 0x50) = param_1 != (undefined4 *)0x0;
  *(bool *)(param_1_00 + 0x51) = param_2 != (undefined4 *)0x0;
  if (param_1 != (undefined4 *)0x0) {
    *(undefined4 *)(param_1_00 + 0x52) = *param_1;
    uVar1 = param_1[2];
    *(undefined4 *)(param_1_00 + 0x56) = param_1[1];
    *(undefined4 *)(param_1_00 + 0x5a) = uVar1;
  }
  if (param_2 != (undefined4 *)0x0) {
    puVar3 = (undefined4 *)(param_1_00 + 0x5e);
    for (iVar2 = 0x26; iVar2 != 0; iVar2 = iVar2 + -1) {
      *puVar3 = *param_2;
      param_2 = param_2 + 1;
      puVar3 = puVar3 + 1;
    }
  }
  return;
}

