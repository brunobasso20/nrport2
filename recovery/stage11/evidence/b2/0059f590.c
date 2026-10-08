/* NR2003.exe @ 0059f590 FUN_0059f590 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0059f590(void)

{
  char cVar1;
  int iVar2;
  int iVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  char *pcVar6;
  int iVar7;
  char *pcVar8;
  int iVar9;
  undefined4 *puVar10;
  int local_8;
  
  iVar2 = FUN_0055a5a0();
  if ((3 < iVar2) && (iVar2 < 6)) {
    iVar9 = 0;
    local_8 = 0;
    iVar2 = FUN_0055a6a0();
    iVar3 = FUN_0055a680();
    if (iVar2 == *(int *)(iVar3 + 0x67) + -1) {
      iVar3 = iVar2;
      FUN_00538b00(iVar2);
      cVar1 = FUN_00539840(iVar3);
      if (cVar1 != '\0') {
        iVar3 = 0;
        do {
          puVar4 = (undefined4 *)FUN_00574370(iVar3);
          iVar7 = 0x2b;
          puVar5 = (undefined4 *)((int)&DAT_00daf3f5 + iVar9);
          if (puVar4 == (undefined4 *)0x0) {
            *(undefined4 *)((int)&DAT_00e07bf8 + iVar9) = 0xffffffff;
            for (; iVar7 != 0; iVar7 = iVar7 + -1) {
              *puVar5 = 0;
              puVar5 = puVar5 + 1;
            }
            *(undefined2 *)puVar5 = 0;
            *(undefined *)((int)puVar5 + 2) = 0;
          }
          else {
            for (; iVar7 != 0; iVar7 = iVar7 + -1) {
              *puVar5 = *puVar4;
              puVar4 = puVar4 + 1;
              puVar5 = puVar5 + 1;
            }
            *(undefined2 *)puVar5 = *(undefined2 *)puVar4;
            local_8 = local_8 + 1;
            *(undefined *)((int)puVar5 + 2) = *(undefined *)((int)puVar4 + 2);
          }
          iVar9 = iVar9 + 0xaf;
          iVar3 = iVar3 + 1;
        } while (iVar9 < 0x20d0);
        _DAT_00daf3f1 = local_8;
        FUN_00538b00();
        puVar5 = (undefined4 *)FUN_00539880();
        if (puVar5 != (undefined4 *)0x0) {
          puVar4 = &DAT_00db14c5;
          for (iVar3 = 0x82; iVar3 != 0; iVar3 = iVar3 + -1) {
            *puVar4 = *puVar5;
            puVar5 = puVar5 + 1;
            puVar4 = puVar4 + 1;
          }
          iVar3 = iVar2;
          FUN_00538b00(iVar2);
          puVar5 = (undefined4 *)FUN_00539860(iVar3);
          if (puVar5 != (undefined4 *)0x0) {
            puVar4 = puVar5;
            puVar10 = &DAT_00db16cd;
            for (iVar3 = 0x82; iVar3 != 0; iVar3 = iVar3 + -1) {
              *puVar10 = *puVar4;
              puVar4 = puVar4 + 1;
              puVar10 = puVar10 + 1;
            }
            iVar3 = FUN_0055a680();
            _DAT_00db18d5 = (int)*(short *)(iVar3 + 0x6d + iVar2 * 8);
            pcVar6 = (char *)FUN_0055a680();
            pcVar8 = &DAT_00db18ed;
            do {
              cVar1 = *pcVar6;
              pcVar6 = pcVar6 + 1;
              *pcVar8 = cVar1;
              pcVar8 = pcVar8 + 1;
            } while (cVar1 != '\0');
            _DAT_00db18d9 = FUN_0055ab00();
            if (*(char *)((int)puVar5 + 9) == -1) {
              _DAT_00db18dd = 0;
              _DAT_00db18e1 = 0;
              _DAT_00db18e5 = 0;
              DAT_00daf3f0 = 1;
              _DAT_00db18e9 = 0;
              return;
            }
            iVar2 = FUN_00562f70(*(char *)((int)puVar5 + 9));
            _DAT_00db18dd = *(undefined4 *)(iVar2 + 0x1493);
            _DAT_00db18e1 = *(undefined4 *)(iVar2 + 0x1497);
            _DAT_00db18e5 = *(undefined4 *)(iVar2 + 0x149b);
            DAT_00daf3f0 = 1;
            _DAT_00db18e9 = *(undefined4 *)(iVar2 + 0x149f);
            return;
          }
        }
      }
    }
  }
  DAT_00daf3f0 = 0;
  return;
}

