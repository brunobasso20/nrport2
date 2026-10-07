/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00503480 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_00503480(int param_1)

{
  ushort *puVar1;
  ushort uVar2;
  float fVar3;
  char cVar4;
  ushort *puVar5;
  int iVar6;
  code *pcVar7;
  int iVar8;
  bool bVar9;
  undefined4 uVar10;
  
  puVar5 = DAT_00b8e59e;
  do {
    if (param_1 < 1) {
      if (param_1 < 0) {
        puVar5 = (ushort *)FUN_00501ee0(puVar5);
        if (puVar5 == (ushort *)0x0) {
          return 0;
        }
        if ((puVar5[3] & 1) != 0) {
          FUN_005020e0(1);
          bVar9 = (puVar5[3] & 4) == 0;
          if (bVar9) {
            iVar6 = FUN_00503470();
            uVar10 = *(undefined4 *)(iVar6 + 4);
          }
          else {
            iVar6 = FUN_00503470();
            uVar10 = *(undefined4 *)(iVar6 + 4);
          }
          FUN_00568d10(uVar10,bVar9,0x3dcccccd);
        }
        DAT_00b8e5a2 = DAT_00b8e5a2 + -1;
        DAT_00b8e59e = puVar5;
      }
    }
    else {
      puVar5 = (ushort *)FUN_00501ea0(puVar5);
      if (puVar5 == (ushort *)0x0) {
        return 0;
      }
      if ((DAT_00b8e59e[3] & 1) != 0) {
        FUN_005020e0(1);
        if ((DAT_00b8e59e[3] & 4) != 0) {
          iVar6 = FUN_00503470();
          FUN_00568d10(*(undefined4 *)(iVar6 + 4),0,0x3dcccccd);
          DAT_00b8e5a2 = DAT_00b8e5a2 + 1;
          DAT_00b8e59e = puVar5;
          goto LAB_00503572;
        }
        iVar6 = FUN_00503470();
        FUN_00568d10(*(undefined4 *)(iVar6 + 4),1,0x3dcccccd);
      }
      DAT_00b8e5a2 = DAT_00b8e5a2 + 1;
      DAT_00b8e59e = puVar5;
    }
LAB_00503572:
    if (param_1 == 0) break;
    if (puVar5 == (ushort *)0x0) {
      return 0;
    }
  } while ((puVar5[3] & 2) != 0);
  if (puVar5 == (ushort *)0x0) {
    return 0;
  }
  if (DAT_00b8e5aa == 0) {
    iVar6 = taskGetRate();
    fVar3 = (float)param_1 / (float)iVar6;
  }
  else {
    fVar3 = (float)DAT_00b8e5aa;
    if (DAT_00b8e5ae != '\0') {
      fVar3 = _DAT_006e97d8 / fVar3;
    }
  }
  FUN_005ab450(fVar3);
  uVar2 = *DAT_00b8e59e;
  puVar5 = DAT_00b8e59e + 4;
  FUN_005aa680(DAT_00b8e59e[2] & 0x3ff);
  for (iVar6 = uVar2 - 8; 0 < iVar6; iVar6 = iVar6 - ((uint)*puVar1 + iVar8)) {
    if (puVar5 == DAT_00b70db8) {
      puVar5 = DAT_00b70db0;
    }
    cVar4 = FUN_005ab230(*puVar5);
    if (cVar4 != '\0') {
      pcVar7 = (code *)FUN_005ab350(*puVar5,*puVar5,puVar5[1] - 4,puVar5 + 2,fVar3);
      (*pcVar7)();
    }
    puVar1 = puVar5 + 1;
    iVar8 = FUN_005ad630((uint)*puVar1 + (int)puVar5);
    puVar5 = (ushort *)((int)puVar5 + (uint)*puVar1 + iVar8);
  }
  FUN_005ab480(fVar3);
  FUN_00503700(param_1);
  FUN_005036a0();
  return 1;
}


