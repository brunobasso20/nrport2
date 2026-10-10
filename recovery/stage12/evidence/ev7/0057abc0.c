/* NR2003.exe @ 0057abc0 FUN_0057abc0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0057abc0(void)

{
  int iVar1;
  uint uVar2;
  char cVar3;
  char cVar4;
  int iVar5;
  int iVar6;
  uint uVar7;
  uint uVar8;
  float10 fVar9;
  int local_c;
  float local_8;
  undefined local_4 [4];
  
  if (DAT_00d37ca6 != '\0') {
    FUN_0057bdd0();
    return;
  }
  FUN_0057bdb0();
  uVar8 = 0;
  uVar7 = 0;
  local_c = 0;
  do {
    cVar3 = FUN_005d06c0(local_c);
    uVar8 = uVar8 | (uint)(cVar3 != '\0') << ((byte)local_c & 0x1f);
    cVar3 = FUN_005d0700(local_c);
    uVar7 = uVar7 | (uint)(cVar3 != '\0') << ((byte)local_c & 0x1f);
    local_c = local_c + 1;
  } while (local_c < 0x20);
  local_c = 0;
  do {
    iVar5 = local_c * 0x1d;
    if (((*(uint *)((int)&DAT_00d37cc0 + iVar5) & DAT_00d3b028) != 0) &&
       (iVar6 = local_c * 10, (&DAT_00d35b1c)[iVar6] == '\0')) {
      iVar1 = *(int *)((int)&DAT_00d37cc8 + iVar5);
      if (iVar1 == 1) {
        iVar5 = *(int *)((int)&DAT_00d37ccc + local_c * 0x1d);
        iVar6 = FUN_005d0420();
        if (iVar5 < iVar6) {
          fVar9 = (float10)FUN_005d0750(iVar5);
          local_8 = (float)fVar9;
        }
        else {
          local_8 = 0.0;
        }
        iVar5 = local_c * 0x1d;
        if (*(int *)((int)&DAT_00d37cb8 + iVar5) == 0) {
          if ((&DAT_00d37cd4)[iVar5] == '\0') {
LAB_0057ae5b:
            if (local_8 < _DAT_006ea454 != (NAN(local_8) || NAN(_DAT_006ea454))) {
              *(float *)((int)&DAT_00d35b18 + local_c * 10) = -local_8;
            }
          }
          else if (local_8 <= _DAT_006ea454) {
            if ((&DAT_00d37cd4)[iVar5] == '\0') goto LAB_0057ae5b;
          }
          else {
            *(float *)((int)&DAT_00d35b18 + local_c * 10) = local_8;
          }
        }
        else if (*(int *)((int)&DAT_00d37cb8 + iVar5) == 1) {
          cVar3 = (&DAT_00d37cd4)[iVar5];
          iVar5 = local_c * 10;
          if ((&DAT_00d35b1d)[iVar5] == '\0') {
            if (cVar3 == '\0') {
LAB_0057aec2:
              if (local_8 < _DAT_006ee368 == (NAN(local_8) || NAN(_DAT_006ee368)))
              goto LAB_0057ad13;
            }
            else if (local_8 <= _DAT_006ea44c) {
              if (cVar3 != '\0') goto LAB_0057ad13;
              goto LAB_0057aec2;
            }
            (&DAT_00d35b1d)[iVar5] = 1;
            *(undefined4 *)((int)&DAT_00d35b18 + iVar5) = 0x3f800000;
          }
          else {
            if (cVar3 == '\0') {
LAB_0057af0a:
              if (local_8 <= _DAT_006f6648) goto LAB_0057ad13;
            }
            else if (local_8 < _DAT_006ea50c == (NAN(local_8) || NAN(_DAT_006ea50c))) {
              if (cVar3 != '\0') goto LAB_0057ad13;
              goto LAB_0057af0a;
            }
            (&DAT_00d35b1d)[iVar5] = 0;
          }
        }
      }
      else if (iVar1 == 2) {
        uVar2 = uVar8;
        if (*(int *)((int)&DAT_00d37cb8 + iVar5) == 0) {
          uVar2 = uVar7;
        }
        if ((*(uint *)((int)&DAT_00d35b1e + iVar6) & uVar2) == *(uint *)((int)&DAT_00d37ccc + iVar5)
           ) {
          *(undefined4 *)((int)&DAT_00d35b18 + iVar6) = 0x3f800000;
        }
      }
      else if (iVar1 == 4) {
        cVar3 = FUN_0057c510(*(undefined4 *)((int)&DAT_00d37cd0 + iVar5));
        iVar5 = local_c * 0x1d;
        if (*(int *)((int)&DAT_00d37cb8 + iVar5) == 0) {
          cVar4 = FUN_005d0060(*(undefined4 *)((int)&DAT_00d37ccc + iVar5));
          if ((cVar4 != '\0') && (cVar3 != '\0')) {
            *(undefined4 *)((int)&DAT_00d35b18 + local_c * 10) = 0x3f800000;
          }
        }
        else {
          cVar4 = FUN_005d0070(*(undefined4 *)((int)&DAT_00d37ccc + iVar5),local_4);
          if (cVar4 != '\0') {
            if (cVar3 != '\0') {
              *(undefined4 *)((int)&DAT_00d35b18 + local_c * 10) = 0x3f800000;
            }
            FUN_0057c540(local_c + 1,*(undefined4 *)((int)&DAT_00d37ccc + local_c * 0x1d));
          }
        }
      }
LAB_0057ad13:
      (&DAT_00d35b1c)[local_c * 10] = 1;
    }
    local_c = local_c + 1;
    if (0xd6 < local_c) {
      local_c = 0;
      do {
        if ((((*(uint *)((int)&DAT_00d37cc0 + local_c * 0x1d) & DAT_00d3b028) != 0) &&
            (*(int *)((int)&DAT_00d37cb8 + local_c * 0x1d) == 1)) &&
           (*(int *)((int)&DAT_00d35b18 + local_c * 10) == 0x3f800000)) {
          iVar5 = FUN_005cff30(&DAT_00c0751c);
          if (iVar5 < 2) {
            return;
          }
          FUN_005cff2a(&DAT_00c0751c,1,&local_c);
        }
        local_c = local_c + 1;
      } while (local_c < 0xd7);
      return;
    }
  } while( true );
}

