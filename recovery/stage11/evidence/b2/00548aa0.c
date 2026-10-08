/* NR2003.exe @ 00548aa0 FUN_00548aa0 */

void FUN_00548aa0(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  int *piVar2;
  
  uVar1 = FUN_0055ab00();
  piVar2 = (int *)FUN_00562f70(uVar1);
  (**(code **)(*piVar2 + 8))();
  switch(param_1) {
  case 0:
    FUN_0054b940(0,param_2);
    return;
  case 2:
    FUN_0054b940(1,param_2);
    return;
  case 3:
    FUN_0054b940(2,param_2);
    return;
  case 4:
    FUN_0054b940(3,param_2);
    return;
  case 5:
    FUN_0054b940(4,param_2);
    return;
  case 6:
    FUN_0054b940(5,param_2);
    return;
  case 7:
    FUN_0054b940(6,param_2);
    return;
  case 8:
    FUN_0054b940(7,param_2);
  }
  return;
}

