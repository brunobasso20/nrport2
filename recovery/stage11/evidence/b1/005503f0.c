/* NR2003.exe @ 005503f0 FUN_005503f0 */

uint __fastcall FUN_005503f0(undefined4 param_1)

{
  undefined4 uVar1;
  int iVar2;
  uint uVar3;
  
  uVar3 = (uint)DAT_00bf6f35;
  if (DAT_00bf6f35 != 0) {
    DAT_00bf6f35 = 0;
    uVar1 = FUN_0055ab00(param_1);
    iVar2 = FUN_00562f70(uVar1);
    uVar3 = iVar2 + 4;
    if (*(int *)(iVar2 + 4) != 0) {
      uVar1 = FUN_0055ab00(param_1);
      iVar2 = FUN_00562f70(uVar1);
      FUN_004ed0d0(DAT_00d8c378,*(undefined4 *)(iVar2 + 0x5ae),1,0,0x3f800000,6,1,0,0,0);
      uVar1 = FUN_0055ab00();
      iVar2 = FUN_00562f70(uVar1);
      FUN_005576f0(8,*(undefined4 *)(iVar2 + 0x5ae),0x3f800000);
      uVar3 = FUN_004ed160();
    }
  }
  return uVar3;
}

