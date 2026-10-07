/* NR2003.exe @ 00546c20 FUN_00546c20 */

void FUN_00546c20(undefined4 param_1,undefined4 param_2,int param_3)

{
  uint uVar1;
  char cVar2;
  
  uVar1 = *(uint *)(param_3 + 8);
  if ((uVar1 & 0x80000) == 0) {
    cVar2 = (-((uVar1 & 0x20000000) != 0) & 0x17U) + 0x2d;
  }
  else {
    cVar2 = (-((uVar1 & 0x20000000) != 0) & 0xecU) + 0x56;
  }
  FUN_006c4f81(param_1,s__d_c_c_c_c_c_c_c_c_c_c_c_0074c8b8,uVar1 >> 0x16 & 3,
               (-((uVar1 & 0x100000) != 0) & 0x2cU) + 0x2d,
               (-((*(byte *)(param_3 + 0x20) & 1) != 0) & 0x19U) + 0x2d,
               (-((uVar1 & 0x2000000) != 0) & 0x14U) + 0x2d,
               (-(*(char *)(param_3 + 0x22) != '\0') & 0x1cU) + 0x2d,
               (-((uVar1 & 0x40000000) != 0) & 0x26U) + 0x2d,
               (-((uVar1 & 0x60000) != 0) & 0x17U) + 0x2d,(int)cVar2,
               (-((uVar1 & 0x200000) != 0) & 0x20U) + 0x2d,
               (-((*(byte *)(param_3 + 0xb) & 1) != 0) & 0x1fU) + 0x2d,
               (int)(char)((-(*(int *)(param_3 + 0x10) != 0) & 0xd6U) + 0x57),
               (*(uint *)(param_3 + 0xc) & 3) + 0x31);
  return;
}

