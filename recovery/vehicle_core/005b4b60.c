/* Ghidra pseudo-C; NR2003.exe @ 005b4b60 */

void FUN_005b4b60(void)

{
  uint *puVar1;
  int *piVar2;
  uint *puVar3;
  uint *puVar4;
  char cVar5;
  byte bVar6;
  int *piVar7;
  uint local_40;
  undefined1 local_38 [56];
  
  cVar5 = DAT_00ebbd84;
  puVar3 = DAT_00eab1c0;
  do {
    puVar4 = puVar3;
    if (puVar4 == (uint *)0x0) {
      return;
    }
    bVar6 = 0;
    local_40 = 0;
    piVar7 = (int *)puVar4[3];
    if ((int *)puVar4[3] != (int *)0x0) {
      do {
        if (cVar5 == '\0') {
          if ((DAT_007522b4 < 0) || (*piVar7 <= DAT_007522b4)) goto LAB_005b4bf0;
        }
        else if (*piVar7 == DAT_00eab1c4) {
          FUN_005b4cc0(local_38,piVar7 + 1);
          if (*puVar4 == 0) {
            (**(code **)(*DAT_00c72160 + 0x68))(local_38);
            bVar6 = 1;
          }
          else {
            (**(code **)(*DAT_00c72160 + 0x6c))();
            bVar6 = 1;
          }
        }
        else {
LAB_005b4bf0:
          if (*puVar4 == 0) {
            (**(code **)(*DAT_00c72160 + 0x68))(piVar7 + 1);
          }
          else {
            (**(code **)(*DAT_00c72160 + 0x6c))();
          }
        }
        *puVar4 = 0;
        piVar2 = (int *)piVar7[0xf];
        if (bVar6 == 0) {
          puVar4[3] = (uint)piVar2;
          piVar7[0xf] = 0;
          FUN_005b4ca0(piVar7);
        }
        piVar7 = piVar2;
      } while (piVar2 != (int *)0x0);
      local_40 = (uint)bVar6;
    }
    *puVar4 = local_40;
    puVar1 = puVar4 + 1;
    puVar3 = (uint *)*puVar1;
    if (*puVar4 == 0) {
      if (DAT_00eab1c0 == puVar4) {
        DAT_00eab1c0 = puVar3;
      }
      if (*puVar1 != 0) {
        *(uint *)(*puVar1 + 8) = puVar4[2];
      }
      if (puVar4[2] != 0) {
        *(uint *)(puVar4[2] + 4) = *puVar1;
      }
      *puVar1 = 0;
      puVar4[2] = 0;
      puVar4[3] = 0;
      puVar4[4] = 0;
    }
  } while( true );
}

