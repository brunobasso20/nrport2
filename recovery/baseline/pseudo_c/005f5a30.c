/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5a30 */

void thunk_FUN_005f58d0(undefined4 *param_1,undefined4 *param_2)

{
  undefined4 *puVar1;
  undefined4 uVar2;
  
  puVar1 = param_1;
  *param_1 = *param_2;
  param_1[1] = param_2[1];
  param_1[2] = param_2[2];
  uVar2 = FUN_0051370a(param_1 + 0xf,param_1 + 0x10,param_1 + 6,param_1 + 7,param_1 + 8,
                       param_1 + 0xc,param_1 + 9,param_1 + 10,param_1 + 0xb,param_1 + 0xd,
                       param_1 + 0xe,&param_2,&param_1,*param_2,param_2[1],param_2[2],param_1[0x15])
  ;
  puVar1[0x15] = uVar2;
  uVar2 = FUN_006c5018();
  puVar1[0x13] = uVar2;
  uVar2 = FUN_006c5018();
  puVar1[0x14] = uVar2;
  return;
}


