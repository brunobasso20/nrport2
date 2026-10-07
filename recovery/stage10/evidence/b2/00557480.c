/* NR2003.exe @ 00557480 FUN_00557480 */

bool FUN_00557480(undefined4 param_1,int param_2,undefined4 param_3,undefined4 param_4,
                 undefined4 param_5,undefined4 param_6,undefined4 param_7,undefined4 param_8,
                 undefined4 param_9,undefined4 param_10)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  
  puVar1 = DAT_00bf8d68;
  if (DAT_00bf8d68 != (undefined4 *)0x0) {
    DAT_00bf8d68 = (undefined4 *)*DAT_00bf8d68;
    puVar2 = (undefined4 *)0x0;
    if (param_2 != 0) {
      FUN_005f58d0(puVar1,param_2);
      FUN_005f59f0(puVar1,&DAT_006f5a98);
      puVar2 = puVar1;
    }
    puVar1[0x16] = param_9;
    FUN_004ed0d0(param_1,puVar2,param_3,param_4,param_5,param_6,param_10,FUN_00557530,puVar1,0);
    if (param_2 != 0) {
      *(undefined4 *)(param_2 + 0x34) = param_7;
      *(undefined4 *)(param_2 + 0x38) = param_8;
    }
    FUN_004ed160();
    return param_2 != 0;
  }
  return false;
}

