/* NR2003.exe @ 00435420 FUN_00435420 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00435420(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4_00,
                 undefined4 param_4)

{
  int iVar1;
  undefined local_c;
  undefined4 local_b;
  undefined4 local_7;
  undefined local_3;
  
  local_b = 0;
  local_c = DAT_008947c9;
  local_7 = 0;
  local_3 = 0;
  iVar1 = FUN_004430c0();
  if (iVar1 != 0) {
    FUN_006c4f81(&local_c,&DAT_00725eb4,param_4,(double)CONCAT44(param_4_00,param_3) * _DAT_006ee6d8
                );
    FUN_005f9900(&DAT_00f72794,0x2912,param_1,param_2,&local_c);
    return;
  }
  FUN_006c4f81(&local_c,&DAT_00725ebc,param_4,param_3,param_4_00);
  FUN_005f9900(&DAT_00f72794,0x2911,param_1,param_2,&local_c);
  return;
}

