/* NR2003.exe @ 005a5620 FUN_005a5620 */

uint __thiscall FUN_005a5620(uint **param_1,uint *param_2)

{
  uint *puVar1;
  uint uVar2;
  uint *puVar3;
  
  FUN_005f5890(param_1 + 3);
  if ((*param_1[1] ^ DAT_00f7211c) != **param_1) {
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
  **param_1 = *param_1[2] ^ *param_2;
  *param_1[1] = **param_1 ^ DAT_00f7211c;
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x3ff) == 0) {
    puVar1 = param_1[2];
    if (DAT_00f72129 == '\0') {
      FUN_005a5db0(&DAT_00f6eb08,0x600,5);
      DAT_00f72129 = '\x01';
      FUN_005a5bf0(&DAT_00f7211c,4);
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_005a5c30();
    FUN_005a5cd0(puVar1);
    *puVar3 = uVar2;
    param_1[2] = puVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x1ff) == 0) {
    puVar1 = *param_1;
    if (DAT_00f72129 == '\0') {
      FUN_005a5db0(&DAT_00f6eb08,0x600,5);
      DAT_00f72129 = '\x01';
      FUN_005a5bf0(&DAT_00f7211c,4);
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_005a5c30();
    FUN_005a5cd0(puVar1);
    *puVar3 = uVar2;
    *param_1 = puVar3;
  }
  uVar2 = FUN_005cfcfc();
  if ((uVar2 & 0x7ff) == 0) {
    puVar1 = param_1[1];
    if (DAT_00f72129 == '\0') {
      FUN_005a5db0(&DAT_00f6eb08,0x600,5);
      DAT_00f72129 = '\x01';
      DAT_00f7211c = FUN_005cfcfc();
    }
    uVar2 = *puVar1;
    puVar3 = (uint *)FUN_005a5c30();
    FUN_005a5cd0(puVar1);
    *puVar3 = uVar2;
    param_1[1] = puVar3;
  }
  FUN_005f58a0(param_1 + 3);
  return *param_2;
}

