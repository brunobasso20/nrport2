/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00447360 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint __fastcall FUN_00447360(int param_1)

{
  double dVar1;
  double dVar2;
  ushort uVar3;
  bool bVar4;
  char cVar5;
  uint uVar6;
  double *pdVar7;
  int iVar8;
  ushort uVar9;
  float10 fVar10;
  
  FUN_004475b0(DAT_0089e3d8 + 0x1493);
  fVar10 = (float10)thunk_FUN_0055a760();
  dVar1 = (double)fVar10;
  cVar5 = FUN_004504c0();
  if (cVar5 == '\0') {
    *(double *)(param_1 + 0xec) = dVar1;
  }
  dVar2 = *(double *)(param_1 + 0xe2);
  uVar9 = (ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe;
  uVar6 = (uint)uVar9;
  if (dVar1 >= dVar2 && (dVar1 == dVar2) == 0) {
    uVar6 = (uint)CONCAT11((char)(uVar9 >> 8),*(char *)(param_1 + 0xea));
    if ((*(char *)(param_1 + 0xea) != '\0') && (uVar6 = FUN_00451080(7), (char)uVar6 != '\0')) {
      dVar2 = dVar1 - *(double *)(param_1 + 0xec);
      uVar6 = CONCAT22((short)(uVar6 >> 0x10),
                       (ushort)(dVar2 < _DAT_006e9838) << 8 |
                       (ushort)(NAN(dVar2) || NAN(_DAT_006e9838)) << 10 |
                       (ushort)(dVar2 == _DAT_006e9838) << 0xe);
      if (((dVar2 < _DAT_006e9838) &&
          ((*(int *)(param_1 + 0x82) != -1 || (*(int *)(param_1 + 0x92) != -1)))) ||
         ((*(int *)(param_1 + 0x82) != -1 && (*(int *)(param_1 + 0x92) != -1)))) {
        *(undefined1 *)(param_1 + 0xeb) = 1;
        *(undefined1 *)(param_1 + 0xea) = 0;
      }
    }
    uVar6 = CONCAT31((int3)(uVar6 >> 8),*(char *)(param_1 + 0xeb));
    if (*(char *)(param_1 + 0xeb) == '\0') {
      bVar4 = true;
      iVar8 = 0;
      pdVar7 = (double *)(param_1 + 0x8a);
      do {
        if (*(int *)(pdVar7 + -1) != -1) {
          uVar9 = (ushort)(dVar1 < *pdVar7);
          uVar3 = (ushort)(dVar1 == *pdVar7);
          bVar4 = false;
          uVar6 = (uint)(ushort)(uVar9 << 8 | uVar3 << 0xe);
          if ((uVar9 == 0 && uVar3 == 0) && (uVar6 = FUN_00451080(7), (char)uVar6 != '\0')) {
            iVar8 = iVar8 * 0x10 + param_1;
            if (*(int *)(iVar8 + 0x86) == -1) {
              uVar6 = FUN_00450ec0(7,*(undefined4 *)(iVar8 + 0x82),0xffffffff,0xffffffff,0xffffffff,
                                   0xffffffff,0xffffffff);
            }
            else {
              uVar6 = FUN_00451020(7,*(undefined4 *)(iVar8 + 0x82),0x32,*(int *)(iVar8 + 0x86),0x32,
                                   0xffffffff,0);
            }
            dVar1 = dVar1 + _DAT_006ed050;
            *(undefined4 *)(iVar8 + 0x82) = 0xffffffff;
            *(double *)(param_1 + 0xe2) = dVar1;
            return uVar6 & 0xffffff00;
          }
        }
        iVar8 = iVar8 + 1;
        pdVar7 = pdVar7 + 2;
      } while (iVar8 < 6);
      uVar6 = uVar6 & 0xffffff00;
      if (bVar4) {
        *(undefined1 *)(param_1 + 0xea) = 1;
      }
    }
    else {
      dVar2 = dVar1 - *(double *)(param_1 + 0xec);
      uVar6 = (uint)(ushort)((ushort)(dVar2 < _DAT_006e9838) << 8 |
                            (ushort)(dVar2 == _DAT_006e9838) << 0xe);
      if (((dVar2 >= _DAT_006e9838 && (dVar2 == _DAT_006e9838) == 0) &&
          ((*(int *)(param_1 + 0x82) == -1 ||
           (dVar2 = *(double *)(param_1 + 0x8a),
           uVar6 = (uint)(ushort)((ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe),
           dVar1 >= dVar2 && (dVar1 == dVar2) == 0)))) &&
         ((*(int *)(param_1 + 0x92) == -1 ||
          (dVar2 = *(double *)(param_1 + 0x9a),
          uVar6 = (uint)(ushort)((ushort)(dVar1 < dVar2) << 8 | (ushort)(dVar1 == dVar2) << 0xe),
          dVar1 >= dVar2 && (dVar1 == dVar2) == 0)))) {
        uVar6 = FUN_00450ec0(7,0x81,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
        dVar1 = dVar1 + _DAT_006ed050;
        *(undefined1 *)(param_1 + 0xeb) = 0;
        *(double *)(param_1 + 0xe2) = dVar1;
        return uVar6 & 0xffffff00;
      }
    }
  }
  return uVar6;
}


