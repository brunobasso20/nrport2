/* NR2003.exe @ 004247e0 FUN_004247e0 */

void __fastcall FUN_004247e0(int param_1)

{
  int iVar1;
  int iVar2;
  float fVar3;
  float fVar4;
  undefined4 uVar5;
  
  iVar2 = DAT_00c05266;
  iVar1 = DAT_00c05260;
  if ((DAT_00871ad4 == 1) || (DAT_00871ad4 == 5)) {
    fVar3 = (float)(**(code **)(DAT_00c05260 + 0x16))(*(undefined4 *)(param_1 + 0xb4));
    fVar4 = (float)(**(code **)(iVar2 + 0x16))(*(undefined4 *)(param_1 + 0xb8));
    if (fVar4 < fVar3) {
      uVar5 = (**(code **)(iVar1 + 0x12))(fVar4);
      *(undefined4 *)(param_1 + 0xb4) = uVar5;
    }
  }
  return;
}

