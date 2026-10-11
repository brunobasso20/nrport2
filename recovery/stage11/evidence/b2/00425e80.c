/* NR2003.exe @ 00425e80 FUN_00425e80 */

void FUN_00425e80(uint *param_1,uint *param_2,uint *param_3,uint param_4)

{
  uint uVar1;
  uint uVar2;
  
  if (3 < (int)param_4) {
    uVar2 = param_4 >> 2;
    param_4 = param_4 + uVar2 * -4;
    do {
      uVar1 = *param_2;
      param_2 = param_2 + 1;
      *param_1 = uVar1 ^ *param_3;
      param_1 = param_1 + 1;
      param_3 = param_3 + 1;
      uVar2 = uVar2 - 1;
    } while (uVar2 != 0);
  }
  for (; param_4 != 0; param_4 = param_4 - 1) {
    *(byte *)param_1 = *(byte *)param_2 ^ *(byte *)param_3;
    param_1 = (uint *)((int)param_1 + 1);
    param_3 = (uint *)((int)param_3 + 1);
    param_2 = (uint *)((int)param_2 + 1);
  }
  return;
}

