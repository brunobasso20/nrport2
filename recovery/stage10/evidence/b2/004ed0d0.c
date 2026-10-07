/* NR2003.exe @ 004ed0d0 FUN_004ed0d0 */

undefined4 * __thiscall
FUN_004ed0d0(undefined4 *param_1_00,int param_1,undefined4 param_2,undefined4 param_3,
            undefined4 param_4,undefined4 param_5,undefined4 param_6,undefined4 param_7,
            undefined4 param_8,undefined4 param_9,undefined4 param_10)

{
  int iVar1;
  undefined4 *puVar2;
  
  *param_1_00 = 0;
  if (param_1 != 0) {
    iVar1 = FUN_004f0710(0x15b);
    if (iVar1 != 0) {
      puVar2 = (undefined4 *)
               FUN_004f05f0(param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,
                            param_10);
      if (puVar2 != (undefined4 *)0x0) {
        iVar1 = puVar2[1];
        *param_1_00 = puVar2;
        puVar2[1] = iVar1 + 1;
        puVar2[1] = iVar1 + 2;
        puVar2[1] = iVar1 + 1;
        if (iVar1 + 1 == 0) {
          (**(code **)*puVar2)(1);
        }
        FUN_004eeb20(param_1_00,param_3);
      }
    }
  }
  return param_1_00;
}

