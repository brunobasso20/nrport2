/* NR2003.exe @ 005365c0 FUN_005365c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 __thiscall FUN_005365c0(int param_1_00,int param_1,int *param_2)

{
  float fVar1;
  int iVar2;
  char cVar3;
  int iVar4;
  char *pcVar5;
  int iVar6;
  undefined8 uVar7;
  
  if (param_1 != 0) {
    iVar6 = 0;
    uVar7 = FUN_00536160();
    iVar4 = (int)((ulonglong)uVar7 >> 0x20);
    if (0 < (int)uVar7) {
      iVar2 = *(int *)(iVar4 + 0x50);
      pcVar5 = (char *)(param_1_00 + 0x14);
      do {
        if (((iVar2 == 2) || (iVar2 == 4)) &&
           (cVar3 = FUN_00536510(*(undefined4 *)(iVar4 + 0x3c),iVar6), cVar3 != '\0')) {
          fVar1 = *(float *)(param_1 + 0x40);
          if (*pcVar5 == '\0') {
            if (_DAT_006ea454 < fVar1) goto LAB_00536616;
          }
          else if (fVar1 < _DAT_006ea454 != (NAN(fVar1) || NAN(_DAT_006ea454))) {
LAB_00536616:
            if (param_2 != (int *)0x0) {
              *param_2 = iVar6;
            }
            return 1;
          }
        }
        iVar6 = iVar6 + 1;
        pcVar5 = pcVar5 + 0x394;
        uVar7 = FUN_00536160();
        iVar4 = (int)((ulonglong)uVar7 >> 0x20);
      } while (iVar6 < (int)uVar7);
    }
  }
  return 0;
}

