/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 005b6190 */

/* WARNING: Type propagation algorithm not settling */

int FUN_005b6190(undefined4 param_1,uint param_2,uint param_3,undefined4 *param_4)

{
  char cVar1;
  byte bVar2;
  int iVar3;
  int iVar4;
  char *pcVar5;
  int *piVar6;
  undefined4 extraout_ECX;
  uint uVar7;
  undefined4 extraout_EDX;
  undefined4 extraout_EDX_00;
  char *pcVar8;
  int *piVar9;
  undefined4 uVar10;
  undefined1 *puVar11;
  undefined4 *puVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  uint local_38c [3];
  undefined1 auStack_380 [31];
  undefined1 uStack_361;
  undefined1 auStack_360 [64];
  undefined1 local_320 [256];
  undefined1 local_220 [256];
  undefined1 local_120 [288];
  
  iVar3 = (param_2 & 0xff) - 0x40;
  local_38c[2] = 0xffffffff;
  local_38c[1] = 0;
  switch(param_2 & 0xff) {
  case 0x40:
    iVar4 = FUN_005b6030(local_38c + 1,local_38c,local_220,0x100,param_4);
    iVar3 = 0;
    if (iVar4 != 0) {
      FUN_005b6b10(local_120,0x120,local_220,local_38c + 1,local_38c[0]);
      FUN_0055c810(local_38c[0],local_120);
      iVar3 = FUN_005cfeb8();
      return iVar3;
    }
    break;
  case 0x41:
    FUN_0055c800(*param_4,param_4 + 1);
    iVar3 = FUN_005cfeb8();
    return iVar3;
  case 0x42:
    iVar3 = FUN_0055a5a0();
    if (iVar3 == 3) {
      iVar3 = FUN_0055a6f0();
      if (param_4[0x10] != iVar3) {
        iVar3 = FUN_0055a660(param_4);
        return iVar3;
      }
    }
    else {
      iVar3 = iVar3 + -4;
      if ((iVar3 == 0) && (iVar3 = FUN_0055a6f0(), param_4[0x10] != iVar3)) {
        FUN_00567140();
        FUN_0055a910();
        iVar3 = FUN_0055a660(param_4);
        return iVar3;
      }
    }
    break;
  case 0x43:
    pcVar5 = (char *)FUN_00574370(*param_4);
    if (((pcVar5 != (char *)0x0) && (pcVar5[0xac] == '\0')) && (DAT_007522c2 != '\0')) {
      iVar3 = -1;
      pcVar8 = pcVar5 + 0x24;
      do {
        if (iVar3 == 0) break;
        iVar3 = iVar3 + -1;
        cVar1 = *pcVar8;
        pcVar8 = pcVar8 + 1;
      } while (cVar1 != '\0');
      if (iVar3 == -2) {
        if (*pcVar5 == '\0') {
          FUN_006c4f81(local_320,&DAT_00722324,pcVar5 + 0x10);
        }
        else {
          FUN_006c4f81(local_320,s__s__s_0074f628,pcVar5,pcVar5 + 0x10);
        }
      }
      else {
        FUN_006c4f81(local_320,&DAT_00722324,pcVar5 + 0x24);
      }
      FUN_006c4b00(auStack_380,local_320,0x1f);
      iVar3 = param_4[1];
      uStack_361 = 0;
      if (iVar3 == 0) {
        iVar3 = 0x81b;
      }
      FUN_00619640(auStack_360,0x40,iVar3,auStack_380);
      FUN_0055c800(1,auStack_360);
      FUN_005cfeb8();
    }
    iVar3 = FUN_005742e0(*param_4);
    return iVar3;
  case 0x44:
    piVar6 = (int *)FUN_00538b20();
    iVar3 = (**(code **)(*piVar6 + 0x2c))(param_3);
    DAT_00c0819b = 0;
    DAT_00c0819a = 1;
    return iVar3;
  case 0x45:
    iVar3 = FUN_0055ab50(param_3,param_4);
    return iVar3;
  case 0x80:
    FUN_0055ab30(param_4[0x2a]);
    FUN_00574020(param_4);
    uVar13 = FUN_0055a5d0(CONCAT31((int3)((uint)extraout_EDX >> 8),
                                   *(undefined1 *)((int)param_4 + 0xae)) & 0xffffff01);
    FUN_0055a5f0(CONCAT31((int3)((uint)uVar13 >> 8),*(byte *)((int)param_4 + 0xae) >> 1) &
                 0xffffff01);
    FUN_0055c800(1,0x7dd);
    FUN_005cfed0();
    DAT_00c0819a = 0;
    DAT_00c0819b = 0;
    DAT_00c08198 = 0;
    DAT_00c08199 = 0;
    FUN_00538b20();
    FUN_00540320();
    FUN_00538b20();
    FUN_005404b0();
    iVar3 = FUN_0055a4f0(3);
    return iVar3;
  case 0x81:
    FUN_0055c800(2,param_4);
    FUN_005cfeb8();
    iVar3 = FUN_0055a4f0(6);
    return iVar3;
  case 0x82:
    iVar3 = param_3 * 0x5d9f7391;
    local_38c[0] = param_3 / 0xaf;
    if (local_38c[0] != 0) {
      piVar6 = param_4 + 0x2a;
      do {
        if ((((char)piVar6[1] == '\0') && (DAT_007522c2 != '\0')) &&
           ((cVar1 = FUN_005743b0(*piVar6), cVar1 == '\0' ||
            ((iVar3 = FUN_00574370(*piVar6), iVar3 == 0 ||
             (iVar3 = FUN_00574370(*piVar6), *(int *)(iVar3 + 0xa4) != piVar6[-1])))))) {
          iVar3 = -1;
          piVar9 = piVar6 + -0x21;
          do {
            if (iVar3 == 0) break;
            iVar3 = iVar3 + -1;
            iVar4 = *piVar9;
            piVar9 = (int *)((int)piVar9 + 1);
          } while ((char)iVar4 != '\0');
          if (iVar3 == -2) {
            if ((char)piVar6[-0x2a] == '\0') {
              FUN_006c4f81(local_320,&DAT_00722324,piVar6 + -0x26);
            }
            else {
              FUN_006c4f81(local_320,s__s__s_0074f628,piVar6 + -0x2a,piVar6 + -0x26);
            }
          }
          else {
            FUN_006c4f81(local_320,&DAT_00722324,piVar6 + -0x21);
          }
          FUN_006c4b00(auStack_380,local_320,0x1f);
          uStack_361 = 0;
          FUN_00619640(auStack_360,0x40,0x81c,auStack_380);
          FUN_0055c800(1,auStack_360);
          FUN_005cfeb8();
        }
        iVar3 = FUN_00574370(*piVar6);
        if ((((iVar3 != 0) && (iVar3 = FUN_00574370(*piVar6), *(int *)(iVar3 + 0xa4) == piVar6[-1]))
            && (iVar3 = FUN_0055ab00(), *piVar6 == iVar3)) &&
           ((bVar2 = FUN_0055a5e0(), (*(byte *)((int)piVar6 + 6) & 1) != bVar2 ||
            (bVar2 = FUN_0055a600(), (*(byte *)((int)piVar6 + 6) >> 1 & 1) != bVar2)))) {
          uVar13 = 2;
          iVar3 = FUN_0055a5a0();
          if (((iVar3 == 4) || (iVar3 = FUN_0055a5a0(), iVar3 == 5)) &&
             (iVar3 = FUN_0055a5c0(), iVar3 == 3)) {
            uVar13 = 1;
          }
          if ((*(byte *)((int)piVar6 + 6) & 2) == 0) {
            iVar3 = 0x88a - (uint)((*(byte *)((int)piVar6 + 6) & 1) != 0);
          }
          else {
            iVar3 = 0x888;
          }
          FUN_0055c800(uVar13,iVar3);
          FUN_005cfed0();
        }
        FUN_00574020(piVar6 + -0x2a);
        iVar3 = FUN_0055ab00();
        if (*piVar6 == iVar3) {
          FUN_0055a5d0(CONCAT31((int3)((uint)extraout_ECX >> 8),*(undefined1 *)((int)piVar6 + 6)) &
                       0xffffff01);
          FUN_0055a5f0(CONCAT31((int3)((uint)extraout_EDX_00 >> 8),*(byte *)((int)piVar6 + 6) >> 1)
                       & 0xffffff01);
        }
        piVar6 = (int *)((int)piVar6 + 0xaf);
        local_38c[0] = local_38c[0] - 1;
        if (local_38c[0] == 0) {
          return 0;
        }
      } while( true );
    }
    break;
  case 0x83:
    FUN_00538b10(param_4);
    iVar3 = FUN_0053c270(param_4);
    return iVar3;
  case 0x84:
    uVar13 = 0;
    puVar12 = (undefined4 *)&DAT_00c070f8;
    for (uVar7 = param_3 >> 2; uVar7 != 0; uVar7 = uVar7 - 1) {
      *puVar12 = *param_4;
      param_4 = param_4 + 1;
      puVar12 = puVar12 + 1;
    }
    puVar11 = &DAT_00c070f8;
    for (uVar7 = param_3 & 3; uVar7 != 0; uVar7 = uVar7 - 1) {
      *(undefined1 *)puVar12 = *(undefined1 *)param_4;
      param_4 = (undefined4 *)((int)param_4 + 1);
      puVar12 = (undefined4 *)((int)puVar12 + 1);
    }
    uVar10 = 1;
    FUN_00538b20(1,&DAT_00c070f8,param_3,0);
    FUN_00540b80(uVar10,puVar11,param_3,uVar13);
    iVar3 = FUN_005c2d20(param_1);
    if (iVar3 == 1) {
      FUN_00538b20();
      uVar14 = 0;
      uVar10 = 0xda;
      puVar12 = &DAT_00be0d18;
      uVar13 = 1;
      FUN_00538b20(1,&DAT_00be0d18,0xda,0);
      iVar3 = FUN_00540b80(uVar13,puVar12,uVar10,uVar14);
    }
    DAT_00c08199 = 0;
    DAT_00c08198 = 1;
    return iVar3;
  case 0x85:
    FUN_00538b20();
    iVar3 = FUN_00540360();
    return iVar3;
  case 0x86:
    FUN_00538b10(param_4);
    iVar3 = FUN_0053c3a0(param_4);
    return iVar3;
  case 0x87:
    iVar3 = FUN_0055ab90(param_3,param_4);
    return iVar3;
  case 0x88:
    FUN_00538b20();
    iVar3 = FUN_00540500();
    return iVar3;
  case 0x89:
    param_3 = param_3 >> 1;
    FUN_00538b20(param_3,param_4);
    iVar3 = FUN_005405d0(param_3,param_4);
    return iVar3;
  case 0xc0:
    FUN_00538b00(param_4);
    FUN_0053b2b0(param_4);
    iVar3 = FUN_0059f590();
    return iVar3;
  case 0xc1:
    FUN_00538b00(param_4);
    iVar3 = FUN_0053b320(param_4);
    return iVar3;
  case 0xc2:
    FUN_00538b30(param_4);
    iVar3 = FUN_0053e850(param_4);
    return iVar3;
  case 0xc3:
    FUN_00538b40(param_4);
    iVar3 = FUN_0053e8b0(param_4);
    return iVar3;
  case 0xc4:
    FUN_00538b30(param_4);
    iVar3 = FUN_0053ceb0(param_4);
    return iVar3;
  case 0xc5:
    FUN_00538b30(param_4);
    iVar3 = FUN_0053e880(param_4);
    return iVar3;
  case 0xc6:
    FUN_00538b40(param_4);
    iVar3 = FUN_0053e940(param_4);
    return iVar3;
  case 199:
    puVar11 = (undefined1 *)((int)param_4 + 1);
    FUN_00538b90(*(undefined1 *)param_4,puVar11);
    iVar3 = FUN_0053ceb0(puVar11);
    return iVar3;
  case 200:
    if (DAT_00eab23c == '\0') {
      iVar3 = FUN_005bb2f0(0);
      return iVar3;
    }
    break;
  case 0xc9:
    FUN_00538b20(param_4);
    iVar3 = FUN_005410a0(param_4);
    return iVar3;
  case 0xca:
    piVar6 = (int *)FUN_00538b00();
    iVar3 = (**(code **)(*piVar6 + 0x5c))(param_4);
    return iVar3;
  case 0xcb:
    piVar6 = (int *)FUN_00538b00();
    iVar3 = (**(code **)(*piVar6 + 0x60))(param_4);
    break;
  case 0xd1:
    FUN_00538b20(param_4);
    iVar3 = FUN_00540630(param_4);
    return iVar3;
  case 0xd3:
    iVar3 = FUN_0059c110();
    return iVar3;
  }
  return iVar3;
}


