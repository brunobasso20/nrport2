/* NR2003.exe @ 00547fa0 FUN_00547fa0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00547fa0(int param_1,int param_2)

{
  char cVar1;
  int iVar2;
  int extraout_ECX;
  uint uVar3;
  int iVar4;
  float10 fVar5;
  int local_100 [64];
  
  if (param_2 == 0x22) {
    if ((*(uint *)(param_1 + 0xc) & 0xfc00) != 0) {
      return;
    }
    param_2 = 0x1b;
    cVar1 = FUN_00548310(param_1);
    if (cVar1 != '\0') {
      local_100[0] = 4;
    }
    uVar3 = (uint)(cVar1 != '\0');
    fVar5 = (float10)FUN_00548360(param_1);
    if ((float10)_DAT_006ea470 < fVar5) {
      local_100[uVar3] = 5;
      local_100[uVar3 + 1] = 5;
      local_100[uVar3 + 2] = 5;
      local_100[uVar3 + 3] = 7;
      local_100[uVar3 + 4] = 7;
      local_100[uVar3 + 5] = 7;
      local_100[uVar3 + 6] = 10;
      local_100[uVar3 + 7] = 10;
      local_100[uVar3 + 8] = 10;
      local_100[uVar3 + 9] = 0xb;
      local_100[uVar3 + 10] = 9;
      local_100[uVar3 + 0xb] = 6;
      local_100[uVar3 + 0xc] = 9;
      local_100[uVar3 + 0xd] = 6;
      uVar3 = uVar3 + 0xe;
    }
    iVar4 = 0;
    do {
      cVar1 = FUN_005489b0(param_1,iVar4);
      if (cVar1 != '\0') {
        local_100[uVar3] = 8;
        uVar3 = uVar3 + 1;
        break;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 8);
    cVar1 = FUN_00548420(param_1);
    if (cVar1 != '\0') {
      local_100[uVar3] = 0x1d;
      uVar3 = uVar3 + 1;
    }
    fVar5 = (float10)FUN_00548790(param_1);
    if ((float10)_DAT_006ea454 < fVar5) {
      local_100[uVar3] = 0xc;
      uVar3 = uVar3 + 1;
    }
    fVar5 = (float10)FUN_005487f0(param_1);
    if ((float10)_DAT_006ea454 < fVar5) {
      local_100[uVar3] = 0xe;
      uVar3 = uVar3 + 1;
    }
    fVar5 = (float10)FUN_005488b0(param_1);
    if ((float10)_DAT_006ea470 < fVar5) {
      local_100[uVar3] = 0x10;
      local_100[uVar3 + 1] = 0xf;
      local_100[uVar3 + 2] = 0x11;
      uVar3 = uVar3 + 3;
    }
    fVar5 = (float10)FUN_00548850(param_1);
    if ((float10)_DAT_006ea470 < fVar5) {
      local_100[uVar3] = 0xd;
      uVar3 = uVar3 + 1;
    }
    fVar5 = (float10)FUN_00548910(param_1);
    if ((float10)_DAT_006ea454 < fVar5) {
      local_100[uVar3] = 0x12;
      local_100[uVar3 + 1] = 0x13;
      local_100[uVar3 + 2] = 0x14;
      local_100[uVar3 + 3] = 0x15;
      uVar3 = uVar3 + 4;
    }
    fVar5 = (float10)FUN_00548960(param_1);
    if ((float10)_DAT_006ea454 < fVar5) {
      local_100[uVar3] = 2;
      local_100[uVar3 + 1] = 3;
      uVar3 = uVar3 + 2;
    }
    iVar4 = 0;
    do {
      iVar2 = FUN_00548b90(param_1,iVar4);
      if (iVar2 == 3) {
        local_100[uVar3] = 0x19;
LAB_00548203:
        uVar3 = uVar3 + 1;
        break;
      }
      if (0 < iVar2) {
        local_100[uVar3] = 0x17;
        uVar3 = uVar3 + 1;
        local_100[uVar3] = 0x18;
        goto LAB_00548203;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 4);
    iVar4 = 0;
    do {
      fVar5 = (float10)FUN_00548c50(param_1,iVar4);
      if ((float10)_DAT_006ea470 < fVar5) {
        local_100[uVar3] = 1;
        uVar3 = uVar3 + 1;
        break;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 4);
    iVar4 = 0;
    do {
      cVar1 = FUN_00548ce0(param_1,iVar4);
      if (cVar1 != '\0') {
        local_100[uVar3] = 0x1e;
        uVar3 = uVar3 + 1;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 2);
    iVar4 = 0;
    do {
      iVar2 = FUN_00548bf0(param_1,iVar4);
      if (1 < iVar2) {
        local_100[uVar3] = 0x16;
        uVar3 = uVar3 + 1;
        break;
      }
      iVar4 = iVar4 + 1;
    } while (iVar4 < 4);
    if ((int)uVar3 < 1) goto LAB_005482e5;
    rndUniform(0);
    iVar4 = FUN_006c5018();
    if ((int)uVar3 <= iVar4) {
      iVar4 = uVar3 - 1;
    }
    if (iVar4 < 0) {
      iVar4 = 0;
    }
    param_2 = local_100[iVar4];
    if ((param_2 != 0x1b) && (cVar1 = FUN_00547f50(param_1), param_2 = extraout_ECX, cVar1 != '\0'))
    {
      param_2 = 0x1a;
      goto LAB_005482e5;
    }
  }
  if (param_2 == 3) {
    *(uint *)(param_1 + 0xc) = *(uint *)(param_1 + 0xc) | 0x8000000;
  }
  else if (param_2 == 9) {
    *(uint *)(param_1 + 0xc) = *(uint *)(param_1 + 0xc) | 0x4000000;
  }
LAB_005482e5:
  *(uint *)(param_1 + 0xc) =
       (param_2 << 10 ^ *(uint *)(param_1 + 0xc)) & 0xfc00 ^ *(uint *)(param_1 + 0xc);
  return;
}

