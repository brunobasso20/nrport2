/* NR2003.exe @ 005512f0 FUN_005512f0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */


void FUN_005512f0(undefined4 param_1,undefined4 param_2,undefined4 param_3)


{

  undefined4 uVar1;

  int iVar2;

  undefined4 local_84;

  undefined4 local_80;

  undefined4 local_7c;

  undefined4 local_78;

  float local_74;

  undefined4 local_70;

  undefined local_6c [4];

  undefined local_68 [4];

  undefined local_64 [4];

  undefined local_60 [4];

  undefined local_5c [4];

  undefined local_58 [8];

  undefined local_50 [4];

  undefined local_4c [4];

  undefined local_48 [36];

  undefined local_24 [36];



  FUN_005150fa(&local_7c,&local_78,local_60,&local_74,local_6c,local_68,local_64,local_5c,local_58,

               local_50,local_4c,param_1,param_2,0);

  FUN_005f5e50(local_48,local_5c,local_6c);

  FUN_005f6f20(local_24,param_3,0,0);

  FUN_005f6b50(local_48,local_48,local_24);

  FUN_005f74c0(&local_84,&local_80,&local_70,local_48);

  FUN_00551800();

  iVar2 = FUN_0055ab00();

  FUN_0059fa90();

  uVar1 = DAT_00c08194;

  (&DAT_00c08a18)[iVar2 * 0xcb] = iVar2;

  iVar2 = FUN_005c2d20(uVar1);

  if (iVar2 == 1) {

    iVar2 = FUN_0055ab00();

    FUN_0059fa90();

    (&DAT_00b33090)[iVar2 * 0xcb] = iVar2;

  }

  FUN_00551480();

  FUN_00551520(local_7c,local_78,local_74 + _DAT_006ea44c,local_84,local_80,local_70);

  DAT_00bf63da = DAT_00bf63da + 1;

  DAT_00c0819c = DAT_00c0819c + 1;

  DAT_00bf6e04 = 1;

  _DAT_00bf6f18 = 0;

  FUN_00538b20();

  FUN_00541110();

  return;

}
