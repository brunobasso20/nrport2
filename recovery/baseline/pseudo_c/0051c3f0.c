/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0051c3f0 */

float10 __thiscall FUN_0051c3f0(undefined4 *param_1,float *param_2)

{
  undefined4 *puVar1;
  uint uVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  
  FUN_005f5890(param_1 + 3);
  if ((*(uint *)param_1[1] ^ DAT_00f72118) != *(uint *)*param_1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    puVar1 = (undefined4 *)param_1[2];
    uVar3 = FUN_005cfcfc();
    *puVar1 = uVar3;
  }
  *(uint *)*param_1 = *(uint *)param_1[2] ^ (uint)*param_2;
  *(uint *)param_1[1] = *(uint *)*param_1 ^ DAT_00f72118;
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    puVar1 = (undefined4 *)param_1[2];
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar3 = *puVar1;
    puVar4 = (undefined4 *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar4 = uVar3;
    param_1[2] = puVar4;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    puVar1 = (undefined4 *)*param_1;
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar3 = *puVar1;
    puVar4 = (undefined4 *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar4 = uVar3;
    *param_1 = puVar4;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    puVar1 = (undefined4 *)param_1[1];
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      DAT_00f72118 = FUN_005cfcfc();
    }
    uVar3 = *puVar1;
    puVar4 = (undefined4 *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar4 = uVar3;
    param_1[1] = puVar4;
  }
  FUN_005f58a0(param_1 + 3);
  return (float10)*param_2;
}


