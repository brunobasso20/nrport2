/* NR2003.exe @ 0054a330 FUN_0054a330 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: stack */

void FUN_0054a330(void)

{
  float fVar1;
  int iVar2;
  ushort *puVar3;
  int iVar4;
  int iVar5;
  int *piVar6;
  uint uVar7;
  bool bVar8;
  undefined8 uVar9;
  double dVar10;
  int local_30;
  
  local_30 = 0;
  if (DAT_00bf39e8 < 1) {
    DAT_00bf39e8 = 0;
    return;
  }
  piVar6 = &DAT_00bef3bc;
  do {
    iVar5 = piVar6[-1];
    iVar2 = FUN_00562f70(iVar5);
    if (*(int *)(iVar2 + 4) != 0) {
      puVar3 = (ushort *)FUN_00592db0(iVar2);
      uVar7 = ((*puVar3 & 0x3fc0) >> 6) >> ((char)*piVar6 * '\x02' & 0x1fU) & 3;
      uVar9 = FUN_00547e00(*piVar6);
      iVar4 = (int)((ulonglong)uVar9 >> 0x20);
      bVar8 = (*(uint *)(puVar3 + 6) >> 0x1d & 1 << ((byte)uVar9 & 0x1f) & 3) == 0;
      if ((((iVar4 < piVar6[1]) || ((int)uVar7 < piVar6[2])) || ((piVar6[3] != 0 && (bVar8)))) &&
         ((iVar4 != 3 || (iVar4 = FUN_0055ab00(), iVar5 == iVar4)))) {
        FUN_00592dc0(iVar2,1);
        FUN_00592db0(iVar2);
        FUN_0054b970(*piVar6,piVar6[1]);
        FUN_0054b9b0(*piVar6,piVar6[2]);
        FUN_0054ba50((int)uVar9,piVar6[3] != 0);
        iVar4 = FUN_0055ab00();
        if (iVar5 == iVar4) {
          if ((piVar6[3] != 0) && (bVar8)) {
            FUN_0055e6c0((int)uVar9);
          }
          if ((int)uVar7 < piVar6[2]) {
            fVar1 = (float)piVar6[2] * _DAT_006f49d0;
            dVar10 = rndUniform(0);
            fVar1 = fVar1 * _DAT_006f4658 + (float)dVar10 * fVar1 * _DAT_006ed6c8;
            rndUniform(0);
            iVar5 = FUN_006c5018();
            if (iVar5 == 0) {
              if (1 < *piVar6) goto LAB_0054a594;
              FUN_0055e5d0(*piVar6,fVar1);
            }
            else if (iVar5 == 1) {
LAB_0054a594:
              FUN_0055e610(*piVar6,fVar1);
            }
            else if (iVar5 == 3) {
              FUN_0055e670(*piVar6,0x3f800000);
            }
            else {
              FUN_0055e780(*piVar6,fVar1);
            }
          }
        }
        if (piVar6[1] == 3) {
          FUN_0054b4c0(1);
        }
        FUN_00592dc0(iVar2,1);
      }
    }
    local_30 = local_30 + 1;
    piVar6 = piVar6 + 0xd;
    if (DAT_00bf39e8 <= local_30) {
      DAT_00bf39e8 = 0;
      return;
    }
  } while( true );
}

