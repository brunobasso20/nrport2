/* NR2003.exe @ 0051c3f0 FUN_0051c3f0 */

float10 __thiscall FUN_0051c3f0(uint **param_1,float *param_2)

{
  uint *puVar1;
  uint uVar2;
  uint *puVar3;
  
  FUN_005f5890(param_1 + 3);
  if ((*param_1[1] ^ DAT_00f72118) != **param_1) {
    do {
      DAT_00f7212c = FUN_005cfcfc();
    } while (DAT_00f7212c == 0);
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3f) == 0) {
    puVar1 = param_1[2];
    uVar2 = FUN_005cfcfc();
    *puVar1 = uVar2;
  }
  **param_1 = *param_1[2] ^ (uint)*param_2;
  *param_1[1] = **param_1 ^ DAT_00f72118;
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    puVar1 = param_1[2];
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar3 = uVar2;
    param_1[2] = puVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    puVar1 = *param_1;
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      FUN_004f68c0(&DAT_00f72118,4);
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar3 = uVar2;
    *param_1 = puVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    puVar1 = param_1[1];
    if (DAT_00f7212a == '\0') {
      FUN_004f6a80(&DAT_00f70918,0x1800,5);
      DAT_00f7212a = '\x01';
      DAT_00f72118 = FUN_005cfcfc();
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_004f6900();
    FUN_004f69a0(puVar1);
    *puVar3 = uVar2;
    param_1[1] = puVar3;
  }
  FUN_005f58a0(param_1 + 3);
  return (float10)*param_2;
}

