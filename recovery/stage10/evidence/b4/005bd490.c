/* NR2003.exe @ 005bd490 FUN_005bd490 */

void FUN_005bd490(undefined4 param_1,int param_2,int param_3,undefined4 param_4)

{
  switch(param_1) {
  case 0:
  case 1:
  case 2:
  case 3:
    FUN_005bd520(param_2,param_4);
    if (param_2 != param_3) {
      FUN_005bd520(param_3,param_4);
      return;
    }
    break;
  case 5:
  case 6:
  case 7:
  case 8:
  case 9:
  case 10:
  case 0xb:
    FUN_005bd520(param_2,param_4);
    return;
  case 0xf:
    FUN_005bd520(param_3,param_4);
  }
  return;
}

