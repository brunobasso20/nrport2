/* NR2003.exe @ 00559400 FUN_00559400 */

void FUN_00559400(undefined4 *param_1,int param_2)

{
  int iVar1;
  undefined4 uVar2;
  undefined local_100 [256];
  
  FUN_004243d0(local_100);
  iVar1 = FUN_00558aa0(local_100);
  if (iVar1 == 0) {
    FUN_00424430(local_100);
    FUN_00558aa0(local_100);
  }
  uVar2 = FUN_00559470(param_2 + 0x25,param_2 + 4);
  *param_1 = uVar2;
  return;
}

