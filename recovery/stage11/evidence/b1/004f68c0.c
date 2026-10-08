/* NR2003.exe @ 004f68c0 FUN_004f68c0 */

void FUN_004f68c0(undefined4 *param_1,uint param_2)

{
  undefined uVar1;
  undefined4 uVar2;
  uint uVar3;
  
  if (3 < (int)param_2) {
    uVar3 = param_2 >> 2;
    param_2 = param_2 + uVar3 * -4;
    do {
      uVar2 = FUN_005cfcfc();
      *param_1 = uVar2;
      param_1 = param_1 + 1;
      uVar3 = uVar3 - 1;
    } while (uVar3 != 0);
  }
  for (; param_2 != 0; param_2 = param_2 - 1) {
    uVar1 = FUN_005cfcfc();
    *(undefined *)param_1 = uVar1;
    param_1 = (undefined4 *)((int)param_1 + 1);
  }
  return;
}

