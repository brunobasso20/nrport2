/* NR2003.exe @ 00548a00 FUN_00548a00 */

uint FUN_00548a00(undefined4 param_1)

{
  undefined4 uVar1;
  int *piVar2;
  uint uVar3;
  sbyte sVar4;
  
  uVar1 = FUN_0055ab00();
  piVar2 = (int *)FUN_00562f70(uVar1);
  uVar3 = (**(code **)(*piVar2 + 4))();
  switch(param_1) {
  case 0:
    sVar4 = 0;
    break;
  default:
    return uVar3 & 0xffffff00;
  case 2:
    sVar4 = 1;
    break;
  case 3:
    sVar4 = 2;
    break;
  case 4:
    sVar4 = 3;
    break;
  case 5:
    sVar4 = 4;
    break;
  case 6:
    sVar4 = 5;
    break;
  case 7:
    sVar4 = 6;
    break;
  case 8:
    sVar4 = 7;
  }
  return (uint)((*(byte *)(uVar3 + 0xe) & (byte)(1 << sVar4)) != 0);
}

