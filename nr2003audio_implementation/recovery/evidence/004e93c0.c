/* NR2003.exe @ 004e93c0 recovered_004e93c0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void __fastcall recovered_004e93c0(int *param_1)

{
  float fVar1;
  float *pfVar2;
  int iStack_4;
  
  *(undefined *)(param_1 + 0xd) = 0;
  iStack_4 = 0;
  pfVar2 = (float *)((int)param_1 + 0x35);
  do {
    (**(code **)(*param_1 + 4))(pfVar2,(float)iStack_4 * _DAT_006f3820,1);
    iStack_4 = iStack_4 + 1;
    pfVar2 = pfVar2 + 2;
  } while (iStack_4 < 0x100);
  *(undefined4 *)((int)param_1 + 0x835) = *(undefined4 *)((int)param_1 + 0x82d);
  *(undefined4 *)((int)param_1 + 0x839) = *(undefined4 *)((int)param_1 + 0x831);
  fVar1 = (*(float *)((int)param_1 + 0x3d) - *(float *)((int)param_1 + 0x35)) * _DAT_006f3814;
  *(undefined *)(param_1 + 0xd) = 1;
  *(float *)((int)param_1 + 0x841) = fVar1;
  *(float *)((int)param_1 + 0x83d) =
       (*(float *)((int)param_1 + 0x41) - *(float *)((int)param_1 + 0x39)) * _DAT_006f3814;
  *(float *)((int)param_1 + 0x849) =
       (*(float *)((int)param_1 + 0x82d) - *(float *)((int)param_1 + 0x825)) * _DAT_006f3814;
  *(float *)((int)param_1 + 0x845) =
       (*(float *)((int)param_1 + 0x831) - *(float *)((int)param_1 + 0x829)) * _DAT_006f3814;
  return;
}

