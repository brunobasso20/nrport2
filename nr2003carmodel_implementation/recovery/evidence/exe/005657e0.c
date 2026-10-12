/* NR2003.exe @ 005657e0 FUN_005657e0 */

void FUN_005657e0(int param_1)

{
  undefined4 *puVar1;
  
  *(undefined4 *)(param_1 + 0x154c) = *(undefined4 *)(param_1 + 0x1534);
  *(undefined4 *)(param_1 + 0x1548) = *(undefined4 *)(param_1 + 0x1530);
  *(undefined4 *)(param_1 + 0x1550) = *(undefined4 *)(param_1 + 0x1538);
  puVar1 = (undefined4 *)FUN_00562f50();
  *(undefined4 *)(param_1 + 0x153c) = *puVar1;
  *(undefined4 *)(param_1 + 0x1540) = puVar1[1];
  *(undefined4 *)(param_1 + 0x1544) = puVar1[2];
  return;
}

