/* Ghidra pseudo-C; not original source. Program: NR2003.exe; address: 00572430 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_00572430(void)

{
  undefined4 uVar1;
  int iVar2;
  float10 fVar3;
  int *piVar4;
  int *piStack_84;
  undefined4 uStack_80;
  float fStack_7c;
  undefined4 uStack_78;
  undefined1 *puStack_74;
  undefined1 *puStack_70;
  undefined1 **ppuStack_6c;
  undefined1 *puStack_68;
  float fStack_64;
  int *piStack_60;
  undefined4 uStack_5c;
  undefined4 uStack_58;
  undefined1 *puStack_54;
  int iStack_50;
  undefined1 *puStack_4c;
  undefined1 auStack_40 [12];
  undefined1 auStack_34 [52];
  
  if ((DAT_00c72160 != (int *)0x0) && (DAT_00c7215c != (int *)0x0)) {
    puStack_4c = &LAB_005727a0;
    iStack_50 = 1;
    puStack_54 = (undefined1 *)0x57245e;
    (**(code **)(*DAT_00c72160 + 0xd0))();
    puStack_54 = &LAB_00572940;
    uStack_58 = 2;
    uStack_5c = 0x572473;
    (**(code **)(*DAT_00c72160 + 0xd0))();
    uStack_5c = 0x57247e;
    (**(code **)(*DAT_00c7215c + 0x30))();
    uStack_5c = 0x57248c;
    fVar3 = (float10)(**(code **)(*DAT_00c72160 + 0xe0))();
    DAT_00c721b8 = (float)(fVar3 + (float10)DAT_00c721b8);
    uStack_5c = 0x5724a6;
    fVar3 = (float10)(**(code **)(*DAT_00c72160 + 0xe0))();
    uStack_5c = 0;
    piStack_60 = (int *)DAT_00c721bc;
    puStack_68 = auStack_34;
    fStack_64 = DAT_00c721b8;
    DAT_00c721c0 = (float)(fVar3 + (float10)DAT_00c721c0);
    ppuStack_6c = (undefined1 **)0x5724cc;
    FUN_005f6f20();
    ppuStack_6c = &puStack_4c;
    puStack_70 = auStack_34;
    puStack_74 = auStack_40;
    puStack_4c = (undefined1 *)0xbf800000;
    uStack_78 = 0x5724f8;
    FUN_005f6d20();
    iStack_50 = CONCAT31(iStack_50._1_3_,1);
    if (DAT_0074f3f8 + DAT_0074f3f4 + DAT_0074f3f0 <= (float)_DAT_006ed098) {
      iStack_50 = (uint)iStack_50._1_3_ << 8;
    }
    iVar2 = iStack_50;
    uStack_5c = DAT_0074f400;
    piStack_60 = DAT_0074f3fc;
    fStack_64 = (float)iStack_50;
    puStack_70 = (undefined1 *)DAT_0074f3f0;
    ppuStack_6c = (undefined1 **)DAT_0074f3f4;
    puStack_74 = (undefined1 *)DAT_0074f3ec;
    puStack_68 = (undefined1 *)DAT_0074f3f8;
    uStack_78 = DAT_00c721c4;
    fStack_7c = DAT_00c721c0;
    uStack_80 = 0x572571;
    FUN_00567c70();
    uStack_5c = DAT_0074f400;
    piStack_60 = DAT_0074f3fc;
    fStack_64 = (float)iVar2;
    puStack_70 = (undefined1 *)DAT_0074f3f0;
    ppuStack_6c = (undefined1 **)DAT_0074f3f4;
    puStack_68 = (undefined1 *)DAT_0074f3f8;
    puStack_74 = (undefined1 *)DAT_0074f3ec;
    uStack_78 = DAT_00c721c4;
    fStack_7c = DAT_00c721c0;
    uStack_80 = 0x5725c0;
    (**(code **)(*DAT_00c72160 + 0x9c))();
    if ((DAT_00c72164 != (int *)0x0) && (DAT_0074f3d8 != '\0')) {
      uStack_80 = uStack_5c;
      piStack_84 = piStack_60;
      (**(code **)(*DAT_00c72164 + 8))(fStack_64);
      (**(code **)(*DAT_00c72164 + 0xc))(&DAT_0074f3e0);
      (**(code **)(*DAT_00c72164 + 0x10))(&DAT_00c721ac);
    }
    uStack_80 = DAT_00c721c8;
    piStack_84 = (int *)&DAT_0074f404;
    (**(code **)(*DAT_00c72160 + 0xd4))();
    (**(code **)(*DAT_00c72160 + 0x90))(DAT_0074f3d8 == '\0');
    piStack_84 = (int *)0x0;
    if (DAT_00c70e10 != '\0') {
      uVar1 = FUN_0055a680();
      FUN_00572760(uVar1);
      iVar2 = FUN_005d3d80(&DAT_00c70e10,&piStack_84);
      if (iVar2 == 0) {
        FUN_00572760(s_shared_0074f4dc);
        FUN_005d3d80(&DAT_00c70e10,&piStack_84);
      }
      if (piStack_84 != (int *)0x0) {
        piVar4 = piStack_84;
        (**(code **)(*DAT_00c72160 + 0xd8))(&LAB_00572870);
        (**(code **)(*piVar4 + 4))();
        piStack_84 = (int *)0x0;
      }
    }
    if (DAT_00c71fe0 != '\0') {
      uVar1 = FUN_0055a680();
      FUN_00572760(uVar1);
      iVar2 = FUN_005d3d80(&DAT_00c71fe0,&piStack_84);
      if (iVar2 == 0) {
        FUN_00572760(s_shared_0074f4e4);
        FUN_005d3d80(&DAT_00c71fe0,&piStack_84);
      }
    }
    if (piStack_84 != (int *)0x0) {
      FUN_004667a0(&DAT_00c71fe0);
      FUN_00428510(piStack_84);
      FUN_00574b30(piStack_84);
      (**(code **)(*piStack_84 + 4))();
    }
    fVar3 = (float10)(**(code **)(*DAT_00c72160 + 0xe0))();
    FUN_005d4fb0((float)-fVar3);
    (**(code **)(*DAT_00c72160 + 0xdc))(&LAB_00572890);
  }
  return;
}


