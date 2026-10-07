/* Ghidra pseudo-C; NR2003.exe @ 005b7720 */

undefined4 FUN_005b7720(uint *param_1,uint param_2)

{
  code *pcVar1;
  uint uVar2;
  int iVar3;
  ushort local_10;
  ushort uStack_e;
  int local_8;
  int local_4;
  
  pcVar1 = DAT_006e926c;
  if ((int)param_2 < 0) {
    param_2 = 0xffffffff;
  }
  *param_1 = 0x7f;
  do {
    uVar2 = FUN_005b7c00();
    while (3 < uVar2) {
      FUN_005b78c0(&local_10,&DAT_00eab600);
      if ((char)local_10 == -1) {
        FUN_005b7b40(4);
        return 1;
      }
      if ((int)uVar2 < (int)(uStack_e + 4)) break;
      if (*(ushort *)(&DAT_00eab627 + (local_10 & 0xff) * 9) < uStack_e) {
        FUN_005b7b40(uStack_e + 4);
      }
      else {
        FUN_005b7b40(4);
        if (uStack_e == 0) {
          uVar2 = (uint)local_10;
        }
        else {
          FUN_005b7a60(*(undefined4 *)(&DAT_00eab629 + (local_10 & 0xff) * 9),uStack_e);
          uVar2 = CONCAT22(uStack_e,local_10);
          *(ushort *)(&DAT_00eab625 + (local_10 & 0xff) * 9) = uStack_e;
          (&DAT_00eab624)[(local_10 & 0xff) * 9] = 1;
        }
        if (0x7f < (byte)uVar2) {
          *param_1 = uVar2 & 0xff;
          break;
        }
      }
      uVar2 = FUN_005b7c00();
    }
    if (*param_1 != 0x7f) {
      return 0;
    }
    if (param_2 == 0) {
      return 0;
    }
    local_8 = DAT_00eab60c;
    local_4 = DAT_00eab610;
    if ((DAT_00eab60c == 0) || (DAT_00eab610 == 0)) {
      if (param_2 == 0xffffffff) {
        (*pcVar1)(0x10);
      }
      else if (param_2 < 0x11) {
        (*pcVar1)(param_2);
        param_2 = 0;
      }
      else {
        (*pcVar1)(0x10);
        param_2 = param_2 - 0x10;
      }
    }
    else {
      iVar3 = (*DAT_0103b4d8)(2,&local_8,0,param_2);
      if (iVar3 == 0x102) {
        return 0;
      }
    }
  } while( true );
}

