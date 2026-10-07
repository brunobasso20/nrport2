/* NR2003.exe @ 00558da0 FUN_00558da0 */

undefined4 __fastcall FUN_00558da0(undefined4 *param_1)

{
  short *psVar1;
  float fVar2;
  float fVar3;
  undefined4 uVar4;
  short **ppsVar5;
  
  ppsVar5 = (short **)&DAT_00c05152;
  do {
    psVar1 = *ppsVar5;
    if ((psVar1 != (short *)0x0) && (*(int *)(psVar1 + 9) != 0)) {
      if ((*psVar1 != 3) && (*psVar1 != 4)) {
        return 0;
      }
      fVar3 = (float)(**(code **)(psVar1 + 0xb))(*param_1);
      if (*psVar1 == 4) {
        if (fVar3 < *(float *)(psVar1 + 1) == (NAN(fVar3) || NAN(*(float *)(psVar1 + 1)))) {
          if (*(float *)(psVar1 + 3) < fVar3) {
            fVar3 = *(float *)(psVar1 + 3);
          }
        }
        else {
          fVar3 = *(float *)(psVar1 + 1);
        }
      }
      else {
        fVar2 = *(float *)(psVar1 + 1);
        if (((int)fVar3 < (int)*(float *)(psVar1 + 1)) ||
           (fVar2 = *(float *)(psVar1 + 3), (int)*(float *)(psVar1 + 3) < (int)fVar3)) {
          fVar3 = fVar2;
        }
      }
      uVar4 = (**(code **)(psVar1 + 9))(fVar3);
      *param_1 = uVar4;
    }
    ppsVar5 = (short **)((int)ppsVar5 + 6);
    param_1 = param_1 + 1;
    if (0xc055a1 < (int)ppsVar5) {
      FUN_004247e0();
      return 1;
    }
  } while( true );
}

