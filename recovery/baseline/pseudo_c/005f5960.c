/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005f5960 */

void FUN_005f5960(undefined4 *param_1,undefined4 param_2,undefined4 param_3,float param_4)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  undefined4 uVar3;
  undefined1 local_4 [4];
  
  puVar2 = param_1;
  puVar1 = param_1 + 6;
  uVar3 = FUN_005150fa(puVar1,param_1 + 7,param_1 + 8,param_1 + 0xc,param_1 + 9,param_1 + 10,
                       param_1 + 0xb,param_1 + 0xd,param_1 + 0xe,&param_1,local_4,param_2,param_3,
                       param_1[0x15]);
  puVar2[0x15] = uVar3;
  *puVar2 = *puVar1;
  puVar2[1] = puVar2[7];
  puVar2[0xf] = param_2;
  puVar2[0x10] = param_3;
  puVar2[2] = param_4 + (float)puVar2[8];
  uVar3 = FUN_006c5018();
  puVar2[0x13] = uVar3;
  uVar3 = FUN_006c5018();
  puVar2[0x14] = uVar3;
  return;
}


