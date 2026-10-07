/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 0044cfb0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall FUN_0044cfb0(int param_1)

{
  bool bVar1;
  char cVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  float10 fVar6;
  undefined4 *puVar7;
  undefined4 local_c [2];
  
  if (DAT_0089bcfd == '\0') {
    *(undefined4 *)(param_1 + 0x5d) = 0;
    *(undefined1 *)(param_1 + 0x56) = 1;
    *(undefined1 *)(param_1 + 0x57) = 1;
    *(undefined1 *)(param_1 + 0x5b) = 1;
    *(undefined4 *)(param_1 + 0x61) = 0xbff00000;
  }
  else if (*(double *)(param_1 + 0x5d) <= _DAT_006ea4b0) {
    cVar2 = FUN_00450830();
    if ((cVar2 == '\0') && (*(char *)(param_1 + 0x57) != '\0')) {
      puVar7 = local_c;
      local_c[0] = 0;
      FUN_00538b20(puVar7);
      uVar3 = FUN_00540440();
      iVar4 = FUN_00536180(uVar3,puVar7);
      iVar5 = FUN_00538b30();
      puVar7 = (undefined4 *)(iVar5 + 0x113 + iVar4 * 0xc);
      if ((*(int *)(iVar5 + 0x117 + iVar4 * 0xc) == 0) && (puVar7[2] == -0x40100000)) {
        fVar6 = (float10)_DAT_006ea4b8;
        bVar1 = true;
      }
      else {
        fVar6 = (float10)(**(code **)*puVar7)();
        if (fVar6 <= (float10)*(double *)(puVar7 + 1)) {
          fVar6 = (float10)(**(code **)*puVar7)();
          fVar6 = (float10)*(double *)(puVar7 + 1) - fVar6;
          if ((float10)_DAT_006ef4c8 <= fVar6) {
            bVar1 = false;
          }
          else {
            bVar1 = true;
          }
        }
        else {
          fVar6 = (float10)_DAT_006ea4b0;
          bVar1 = true;
        }
      }
      if ((float10)_DAT_006ea4b0 <= fVar6) {
        *(undefined1 *)(param_1 + 0x5b) = 0;
      }
      if (*(char *)(param_1 + 0x5b) == '\0') {
        if (bVar1) {
          fVar6 = (float10)thunk_FUN_0055a760();
          *(double *)(param_1 + 0x5d) = (double)(fVar6 + (float10)_DAT_006e9808);
          return;
        }
        if ((*(char *)(param_1 + 0x56) != '\0') &&
           (cVar2 = FUN_00536400(*(undefined4 *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c),iVar4,
                                 0x437a0000), cVar2 != '\0')) {
          *(undefined1 *)(param_1 + 0x56) = 0;
          FUN_00450ec0(10,2,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
          return;
        }
      }
    }
  }
  else if (*(char *)(param_1 + 0x76) != '\0') {
    puVar7 = local_c;
    local_c[0] = 0;
    FUN_00538b20(puVar7);
    uVar3 = FUN_00540440();
    uVar3 = FUN_00536180(uVar3,puVar7);
    iVar4 = FUN_00536260(uVar3);
    if ((iVar4 != 0) &&
       (cVar2 = FUN_00536400(*(undefined4 *)(*(int *)(DAT_0089e3d8 + 0x5ae) + 0x3c),uVar3,0x437a0000
                            ), cVar2 == '\0')) {
      return;
    }
    if (*(char *)(param_1 + 0x58) != '\0') {
      FUN_00450ec0(10,3,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      *(undefined1 *)(param_1 + 0x57) = 0;
      *(undefined4 *)(param_1 + 0x5d) = 0;
      *(undefined4 *)(param_1 + 0x61) = 0xbff00000;
      return;
    }
    fVar6 = (float10)thunk_FUN_0055a760();
    if ((float10)*(double *)(param_1 + 0x5d) < fVar6) {
      FUN_00450ec0(10,3,4,0xffffffff,0xffffffff,0xffffffff,0xffffffff);
      *(undefined1 *)(param_1 + 0x57) = 0;
      *(undefined4 *)(param_1 + 0x5d) = 0;
      *(undefined4 *)(param_1 + 0x61) = 0xbff00000;
      return;
    }
  }
  return;
}


