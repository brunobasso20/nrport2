/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00417fd0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __thiscall FUN_00417fd0(int param_1_00,int param_1,ushort param_2)

{
  float *pfVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  float fVar4;
  float fVar5;
  char cVar6;
  int iVar7;
  int *piVar8;
  undefined4 uVar9;
  byte *pbVar10;
  int iVar11;
  undefined4 *puVar12;
  undefined1 *puVar13;
  float10 fVar14;
  double dVar15;
  int local_4;
  
  if (*(int *)(param_1_00 + 0x3f54) != param_1) {
    local_4 = 0;
    *(undefined1 *)(param_1_00 + 299) = 0;
    switch(param_1) {
    case 0:
      *(ushort *)(param_1_00 + 0xc9) =
           (param_2 & 1) << 6 ^ (*(ushort *)(param_1_00 + 0xc9) & 0xfdb3 | 0x100);
      *(undefined4 *)(param_1_00 + 0x3f58) = *(undefined4 *)(param_1_00 + 0x3f50);
      fVar14 = (float10)FUN_00509a20();
      *(float *)(param_1_00 + 0x3f5c) = (float)fVar14;
      *(undefined4 *)(param_1_00 + 0x3f60) = 2;
      FUN_00538ab0();
      iVar11 = FUN_005398d0();
      if (iVar11 == 0) {
        *(undefined4 *)(param_1_00 + 0x3f60) = 3;
      }
      *(int *)(param_1_00 + 0x9cc) = *(int *)(param_1_00 + 0x9cc) + 1;
      piVar8 = (int *)FUN_00413e20();
      (**(code **)(*piVar8 + 4))();
      puVar13 = (undefined1 *)(param_1_00 + 0x4061);
      puVar12 = (undefined4 *)(param_1_00 + 0x4095);
      do {
        iVar11 = FUN_004f5970(puVar13 + (-0x4061 - param_1_00));
        *(undefined4 *)(iVar11 + 0x1a8a) = 0;
        puVar13[-0x3f66] = 0;
        *puVar13 = 0;
        *puVar12 = 0;
        puVar12[1] = 0xbff00000;
        puVar13[0x270] = 0;
        puVar13[0x2a0] = 0;
        puVar13[0x2da] = 0;
        puVar13 = puVar13 + 1;
        puVar12 = puVar12 + 3;
      } while ((int)(puVar13 + (-0x4061 - param_1_00)) < 0x30);
      pfVar1 = (float *)(DAT_00760b38 + 0x186a);
      fVar14 = (float10)FUN_00516e1a();
      if ((float10)*pfVar1 < fVar14 * (float10)_DAT_006ea44c) {
        *(undefined4 *)(DAT_00760b38 + 0x1a8a) = 1;
      }
      *(undefined4 *)(param_1_00 + 0x4333) = 0;
      *(undefined4 *)(param_1_00 + 0x4337) = 0;
      *(undefined4 *)(param_1_00 + 0x436b) = 0x201;
      FUN_0041a930(0);
      *(int *)(param_1_00 + 0x3f54) = param_1;
      return;
    case 1:
      pfVar1 = (float *)(DAT_00760b38 + 0x186a);
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfdf3 | 0x100;
      fVar14 = (float10)FUN_00516e1a();
      if (fVar14 * (float10)_DAT_006ea44c < (float10)*pfVar1) {
        *(int *)(param_1_00 + 0x3f54) = param_1;
        *(int *)(param_1_00 + 0x3f60) = *(int *)(param_1_00 + 0x3f60) + 1;
        return;
      }
      break;
    case 2:
      *(int *)(param_1_00 + 0x3f54) = param_1;
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfcfb | 8;
      return;
    case 3:
      *(int *)(param_1_00 + 0x3f54) = param_1;
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfcfb | 8;
      return;
    case 4:
      *(int *)(param_1_00 + 0x3f54) = param_1;
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfcfb | 8;
      return;
    case 5:
      FUN_0041a930(1);
      *(undefined4 *)(param_1_00 + 0x4d) = 0;
      *(undefined4 *)(param_1_00 + 0x51) = 0xbff00000;
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfefb | 0x208;
      *(int *)(param_1_00 + 0x3f54) = param_1;
      return;
    case 6:
      dVar15 = rndUniform(0);
      fVar4 = (_DAT_00bddcd8 - _DAT_00bddf28) * (float)dVar15 + _DAT_00bddf28;
      iVar11 = taskGetRate();
      fVar5 = _DAT_0074b080 * _DAT_006e9810 * (float)iVar11;
      *(float *)(param_1_00 + 0x43cf) = fVar4 - (fVar5 + fVar5);
      iVar11 = FUN_00509b60(0xffffffff);
      if (iVar11 != 3) {
        *(int *)(param_1_00 + 0x3f54) = param_1;
        *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfefb | 0x208;
        return;
      }
      break;
    case 7:
      *(ushort *)(param_1_00 + 0xc9) = *(ushort *)(param_1_00 + 0xc9) & 0xfcf7;
      *(undefined4 *)(param_1_00 + 0x4d) = 0;
      *(undefined4 *)(param_1_00 + 0x51) = 0xbff00000;
      *(undefined4 *)(param_1_00 + 0x3f5c) = 0xbf800000;
      *(undefined4 *)(param_1_00 + 0x3f60) = 0;
      cVar6 = FUN_004f5f70(&local_4);
      while (cVar6 != '\0') {
        iVar11 = *(int *)(local_4 + 0x5b2) + param_1_00;
        *(undefined1 *)(iVar11 + 0x3ef0) = 0;
        *(undefined1 *)(iVar11 + 0x3f20) = 0;
        if (*(char *)(local_4 + 0x1233) != '\0') {
          FUN_00420680(*(undefined4 *)(local_4 + 0x122e),1);
          FUN_00420a10(*(undefined4 *)(local_4 + 0x122e),1);
        }
        cVar6 = FUN_004f5f70(&local_4);
      }
      iVar11 = *(int *)(DAT_00760b38 + 0x5b2);
      iVar7 = FUN_00413e20();
      if (((iVar11 != -1) && (iVar7 = iVar7 + iVar11 * 0xd, *(int *)(iVar7 + 0x18c) != -1)) &&
         (*(int *)(iVar7 + 0x188) != -1)) {
        uVar2 = *(undefined4 *)(DAT_00760b38 + 0x5b2);
        piVar8 = (int *)FUN_00413e20();
        (**(code **)(*piVar8 + 0x10))(uVar2);
      }
      cVar6 = FUN_00417f50();
      if (cVar6 != '\0') {
        uVar2 = *(undefined4 *)(param_1_00 + 0x43d3);
        iVar11 = FUN_004f5970(uVar2);
        if ((iVar11 != 0) && (iVar11 = FUN_004f5970(uVar2), *(int *)(iVar11 + 0x5ae) != 0)) {
          uVar3 = *(undefined4 *)(param_1_00 + 0x43d7);
          iVar11 = FUN_004f5970(uVar3);
          if ((iVar11 != 0) && (iVar11 = FUN_004f5970(uVar3), *(int *)(iVar11 + 0x5ae) != 0)) {
            piVar8 = (int *)FUN_00413e20();
            iVar11 = *piVar8;
            uVar9 = FUN_004f5970(uVar2,0x40900000);
            uVar9 = FUN_004f5970(uVar3,uVar9);
            cVar6 = (**(code **)(iVar11 + 0x40))(uVar9);
            if (cVar6 == '\0') {
              iVar11 = FUN_004f5970(uVar3);
              iVar11 = *(int *)(iVar11 + 0x5ae);
              iVar7 = FUN_004f5970(uVar2);
              if (*(float *)(iVar11 + 0x44) <
                  *(float *)(*(int *)(iVar7 + 0x5ae) + 0x44) + _DAT_006ea514) {
                *(undefined4 *)(param_1_00 + 0x43d3) = 0xffffffff;
                *(undefined4 *)(param_1_00 + 0x43d7) = 0xffffffff;
              }
            }
          }
        }
      }
      piVar8 = (int *)FUN_00413e20();
      (**(code **)(*piVar8 + 0x3c))();
      pbVar10 = (byte *)(param_1_00 + 0x3d73);
      iVar11 = 0x30;
      do {
        *pbVar10 = *pbVar10 & 0xc0;
        pbVar10[-1] = 0x31;
        pbVar10[-0xffffffff00000003] = 0x19;
        pbVar10[-0xffffffff00000002] = 0xfc;
        pbVar10[0xc0] = pbVar10[0xc0] & 0xc0;
        pbVar10[0xbf] = 0x31;
        pbVar10[0xbd] = 0x19;
        pbVar10[0xbe] = 0xfc;
        pbVar10 = pbVar10 + 4;
        iVar11 = iVar11 + -1;
      } while (iVar11 != 0);
    }
    *(int *)(param_1_00 + 0x3f54) = param_1;
  }
  return;
}


