/* NR2003.exe @ 005f8560 taskStart */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* void __cdecl taskStart(void (__cdecl*)(void),void (__cdecl*)(void),void
   (__cdecl*)(void),int,bool) */

void __cdecl
taskStart(_func_void *param_1,_func_void *param_2,_func_void *param_3,int param_4,bool param_5)

{
  code *pcVar1;
  bool bVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  longlong lVar6;
  longlong lVar7;
  char *pcVar8;
  undefined local_54 [80];
  
                    /* 0x1f8560  285  ?taskStart@@YAXP6AXXZ00H_N@Z */
  DAT_00f72344 = 1;
  DAT_007559bc = 0;
  DAT_007559c0 = 0;
  DAT_007559c4 = 0;
  DAT_007559d4 = 0;
  DAT_007559d8 = 0;
  DAT_007559dc = 0;
  DAT_007559e0 = 0;
  DAT_007559a8 = param_1;
  DAT_007559ac = param_2;
  DAT_007559b0 = param_3;
  DAT_007559b4 = param_4;
  _DAT_007559b8 = 0x3f800000;
  DAT_00755a18 = (uint)param_5;
  DAT_00755a14 = 0;
  DAT_00755a10 = 0;
  taskRegisterCommFuncs((taskCommFunctions *)0x0);
  taskRegisterIntFunc((_func_void *)0x0);
  FUN_005f8f30(&DAT_007559cc);
  FUN_005f8f30(&DAT_007559d0);
  FUN_005f8f30(&DAT_00755a00);
  DAT_00755a04 = 1;
  FUN_005f7e70();
  if ((param_4 != 0) || (!param_5)) {
    FUN_005f84c0(param_4);
  }
  DAT_00f72164 = FUN_010149a0(0,0,&LAB_005f8800,0,4,&DAT_00f7215c);
  pcVar1 = DAT_006e923c;
  (*DAT_006e923c)(DAT_00f72164,0xffffffff);
  DAT_00f7226c = FUN_01014b60();
  DAT_00f72230 = FUN_01014be0();
  (*pcVar1)(DAT_00f72230,1);
  pcVar1 = DAT_006e9220;
  uVar3 = (*DAT_006e9220)(&DAT_00f72230,0,0,2);
  uVar3 = (*pcVar1)(DAT_00f72230,uVar3);
  FUN_01014be0(uVar3);
  DAT_00755a14 = 1;
  DAT_00f7230c = 1;
  DAT_00f7222c = '\x01';
  iVar5 = 0;
  do {
    iVar4 = FUN_005f8f70(DAT_00f72164,s_C__Views_prgbuild2_nr2003_beta_p_00755bf8,0x36e);
    if (iVar4 != 0) break;
    iVar5 = iVar5 + 1;
  } while (iVar5 < 10);
  if (iVar5 == 10) {
    FUN_006c4f81(local_54,s_Couldn_t_start_fg_thread__00755c30);
    (*DAT_0103b4e8)(local_54);
    FUN_006c38c6(1,1);
  }
  uVar3 = 900;
  pcVar8 = s_C__Views_prgbuild2_nr2003_beta_p_00755c4c;
  while( true ) {
    uVar3 = FUN_01014be0(pcVar8,uVar3);
    FUN_005f8f90(uVar3);
    bVar2 = bgIsRunning();
    if ((!bVar2) && (bVar2 = svIsRunning(), pcVar1 = DAT_006e926c, !bVar2)) break;
    while( true ) {
      iVar5 = DAT_00f722fc;
      LOCK();
      DAT_00f722fc = DAT_00f722fc + -1;
      UNLOCK();
      if (DAT_00f722fc < 0) break;
      if (DAT_00f72160 != (code *)0x0) {
        lVar6 = FUN_005cfcfc();
        (*DAT_00f72160)();
        lVar7 = FUN_005cfcfc();
        DAT_00f72304 = (uint)(lVar7 - lVar6) >> 8 |
                       (int)((ulonglong)(lVar7 - lVar6) >> 0x20) * 0x1000000;
      }
    }
    LOCK();
    UNLOCK();
    uVar3 = 0x3b4;
    pcVar8 = s_C__Views_prgbuild2_nr2003_beta_p_00755c84;
    DAT_00f722fc = iVar5;
  }
  if (DAT_00755a14 != 0) {
    DAT_00f7230c = 0;
    DAT_00755a14 = 0;
  }
  while (DAT_00f7222c != '\0') {
    (*pcVar1)(5);
  }
  (*(code *)PTR_LOOP_0105831c)(DAT_00f72230,0);
  (*DAT_0103b4f0)(DAT_00f72230);
  FUN_005f9100();
  FUN_005f9100();
  DAT_00f72344 = 0;
  return;
}

