/* NR2003.exe @ 00447360 FUN_00447360 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_00447360(int param_1)

{
  double dVar1;
  double dVar2;
  bool bVar3;
  char cVar4;
  uint uVar5;
  double *pdVar6;
  int iVar7;
  ushort uVar8;
  float10 fVar9;
  
  FUN_004475b0(DAT_0089e3d8 + 0x1493);
  fVar9 = (float10)thunk_FUN_0055a760();
  dVar1 = (double)fVar9;
  cVar4 = FUN_004504c0();
  if (cVar4 == '\0') {
    *(double *)(param_1 + 0xec) = dVar1;
  }
  dVar2 = *(double *)(param_1 + 0xe2);
  uVar8 = (ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe;
  uVar5 = (uint)uVar8;
  if (dVar1 >= dVar2 && dVar1 != dVar2) {
    uVar5 = (uint)CONCAT11((char)(uVar8 >> 8),*(char *)(param_1 + 0xea));
    if ((*(char *)(param_1 + 0xea) != '\0') && (uVar5 = FUN_00451080(7), (char)uVar5 != '\0')) {
      dVar2 = dVar1 - *(double *)(param_1 + 0xec);
      uVar5 = CONCAT22((short)(uVar5 >> 0x10),
                       (ushort)(dVar2 < _DAT_006e9838) << 8 |
                       (ushort)(NAN(dVar2) || NAN(_DAT_006e9838)) << 10 |
                       (ushort)(dVar2 == _DAT_006e9838) << 0xe);
      if (((dVar2 < _DAT_006e9838 != (NAN(dVar2) || NAN(_DAT_006e9838))) &&
          ((*(int *)(param_1 + 0x82) != -1 || (*(int *)(param_1 + 0x92) != -1)))) ||
         ((*(int *)(param_1 + 0x82) != -1 && (*(int *)(param_1 + 0x92) != -1)))) {
        *(undefined *)(param_1 + 0xeb) = 1;
        *(undefined *)(param_1 + 0xea) = 0;
      }
    }
    uVar5 = CONCAT31((int3)(uVar5 >> 8),*(char *)(param_1 + 0xeb));
    if (*(char *)(param_1 + 0xeb) == '\0') {
      bVar3 = true;
      iVar7 = 0;
      pdVar6 = (double *)(param_1 + 0x8a);
      do {
        if (*(int *)(pdVar6 + -1) != -1) {
          dVar2 = *pdVar6;
          bVar3 = false;
          uVar5 = (uint)(ushort)((ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe);
          if ((dVar1 >= dVar2 && dVar1 != dVar2) && (uVar5 = FUN_00451080(7), (char)uVar5 != '\0'))
          {
            iVar7 = iVar7 * 0x10 + param_1;
            if (*(int *)(iVar7 + 0x86) == -1) {
              uVar5 = FUN_00450ec0(7,*(undefined4 *)(iVar7 + 0x82),0xffffffff,0xffffffff,0xffffffff,
                                   0xffffffff,0xffffffff);
            }
            else {
              uVar5 = FUN_00451020(7,*(undefined4 *)(iVar7 + 0x82),0x32,*(int *)(iVar7 + 0x86),0x32,
                                   0xffffffff,0);
            }
            dVar1 = dVar1 + _DAT_006ed050;
            *(undefined4 *)(iVar7 + 0x82) = 0xffffffff;
            *(double *)(param_1 + 0xe2) = dVar1;
            return uVar5 & 0xffffff00;
          }
        }
        iVar7 = iVar7 + 1;
        pdVar6 = pdVar6 + 2;
      } while (iVar7 < 6);
      uVar5 = uVar5 & 0xffffff00;
      if (bVar3) {
        *(undefined *)(param_1 + 0xea) = 1;
      }
    }
    else {
      dVar2 = dVar1 - *(double *)(param_1 + 0xec);
      uVar5 = (uint)(ushort)((ushort)(dVar2 < _DAT_006e9838) << 8 |
                            (ushort)(dVar2 == _DAT_006e9838) << 0xe);
      if (((dVar2 >= _DAT_006e9838 && dVar2 != _DAT_006e9838) &&
          ((*(int *)(param_1 + 0x82) == -1 ||
           (dVar2 = *(double *)(param_1 + 0x8a),
           uVar5 = (uint)(ushort)((ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe),
           dVar1 >= dVar2 && dVar1 != dVar2)))) &&
         ((*(int *)(param_1 + 0x92) == -1 ||
          (dVar2 = *(double *)(param_1 + 0x9a),
          uVar5 = (uint)(ushort)((ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe),
          dVar1 >= dVar2 && dVar1 != dVar2)))) {
        uVar5 = FUN_00450ec0(7,0x81,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
        dVar1 = dVar1 + _DAT_006ed050;
        *(undefined *)(param_1 + 0xeb) = 0;
        *(double *)(param_1 + 0xe2) = dVar1;
        return uVar5 & 0xffffff00;
      }
    }
  }
  return uVar5;
}

