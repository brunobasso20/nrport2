/* NR2003.exe @ 005587e0 FUN_005587e0 */

void FUN_005587e0(int param_1,undefined4 *param_2,undefined4 *param_3,uint param_4)

{
  uint uVar1;
  
  if (param_1 == 1) {
    for (uVar1 = param_4 >> 2; uVar1 != 0; uVar1 = uVar1 - 1) {
      *param_2 = *param_3;
      param_3 = param_3 + 1;
      param_2 = param_2 + 1;
    }
    for (param_4 = param_4 & 3; param_4 != 0; param_4 = param_4 - 1) {
      *(undefined *)param_2 = *(undefined *)param_3;
      param_3 = (undefined4 *)((int)param_3 + 1);
      param_2 = (undefined4 *)((int)param_2 + 1);
    }
    return;
  }
  for (uVar1 = param_4 >> 2; uVar1 != 0; uVar1 = uVar1 - 1) {
    *param_3 = *param_2;
    param_2 = param_2 + 1;
    param_3 = param_3 + 1;
  }
  for (param_4 = param_4 & 3; param_4 != 0; param_4 = param_4 - 1) {
    *(undefined *)param_3 = *(undefined *)param_2;
    param_2 = (undefined4 *)((int)param_2 + 1);
    param_3 = (undefined4 *)((int)param_3 + 1);
  }
  return;
}

