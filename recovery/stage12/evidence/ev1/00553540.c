/* NR2003.exe @ 00553540 FUN_00553540 */

void FUN_00553540(undefined *param_1)

{
  char cVar1;
  int iVar2;
  
  iVar2 = FUN_005c2d20(DAT_00c08194);
  if (iVar2 == 1) {
    iVar2 = FUN_00509b60(0xffffffff);
    if (iVar2 == 1) goto LAB_00553583;
  }
  iVar2 = FUN_005c2d20(DAT_00c08194);
  if (iVar2 != 1) {
    iVar2 = thunk_FUN_0055a730();
    if (iVar2 == 1) {
LAB_00553583:
      param_1[2] = 1;
      *(undefined4 *)(param_1 + 3) = 1;
      *param_1 = 0;
      param_1[1] = 0;
      return;
    }
  }
  if (DAT_00bf6f0c == 0) {
    cVar1 = FUN_0057af40(0xd);
    *param_1 = cVar1 != '\0';
    cVar1 = FUN_0057af40(0xc);
    param_1[2] = 0;
    param_1[1] = cVar1 != '\0';
    return;
  }
  *param_1 = 0;
  param_1[1] = 0;
  param_1[2] = 0;
  cVar1 = FUN_0057af40(0xe);
  if (cVar1 == '\0') {
    cVar1 = FUN_0057af40(0xf);
    if (cVar1 == '\0') {
      cVar1 = FUN_0057af40(0x10);
      if (cVar1 == '\0') {
        cVar1 = FUN_0057af40(0x11);
        if (cVar1 == '\0') {
          cVar1 = FUN_0057af40(0x12);
          if (cVar1 == '\0') {
            cVar1 = FUN_0057af40(0x13);
            if (cVar1 == '\0') {
              cVar1 = FUN_0057af40(0x14);
              if (cVar1 == '\0') {
                cVar1 = FUN_0057af40(0x15);
                if (cVar1 == '\0') goto LAB_00553695;
                *(undefined4 *)(param_1 + 3) = 7;
              }
              else {
                *(undefined4 *)(param_1 + 3) = 6;
              }
            }
            else {
              *(undefined4 *)(param_1 + 3) = 5;
            }
          }
          else {
            *(undefined4 *)(param_1 + 3) = 4;
          }
        }
        else {
          *(undefined4 *)(param_1 + 3) = 3;
        }
      }
      else {
        *(undefined4 *)(param_1 + 3) = 2;
      }
    }
    else {
      *(undefined4 *)(param_1 + 3) = 1;
    }
  }
  else {
    *(undefined4 *)(param_1 + 3) = 0;
  }
  param_1[2] = 1;
LAB_00553695:
  if ((DAT_00bf6f0c == 2) && (param_1[2] == '\0')) {
    param_1[2] = 1;
    *(undefined4 *)(param_1 + 3) = 1;
  }
  return;
}

