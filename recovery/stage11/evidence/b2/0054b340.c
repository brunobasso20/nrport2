/* NR2003.exe @ 0054b340 FUN_0054b340 */

int FUN_0054b340(undefined4 param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined8 uVar5;
  
  iVar3 = 0;
  iVar4 = 0;
  do {
    iVar1 = FUN_005484e0(param_1,iVar4);
    iVar3 = iVar3 + iVar1;
    iVar4 = iVar4 + 1;
  } while (iVar4 < 0xb);
  iVar4 = 0;
  do {
    uVar5 = FUN_00548b90(param_1,iVar4);
    iVar4 = (int)((ulonglong)uVar5 >> 0x20) + 1;
    iVar3 = iVar3 + (int)uVar5 * 2;
  } while (iVar4 < 4);
  FUN_00548910(param_1);
  iVar4 = FUN_006c5018();
  FUN_005487f0(param_1);
  iVar1 = FUN_006c5018();
  FUN_00548960(param_1);
  iVar2 = FUN_006c5018();
  return ((iVar4 - iVar1) - iVar2) + iVar3;
}

