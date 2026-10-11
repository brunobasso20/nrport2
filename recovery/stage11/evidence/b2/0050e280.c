/* NR2003.exe @ 0050e280 FUN_0050e280 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_0050e280(void)

{
  char *pcVar1;
  char cVar2;
  short sVar3;
  int iVar4;
  bool bVar5;
  int iVar6;
  
  cVar2 = FUN_0057af40(0x7d);
  if (cVar2 == '\0') {
    if (DAT_00b8fac4 == '\0') {
      return;
    }
  }
  else {
    if (DAT_00b8fac4 != '\0') {
      FUN_0050d710();
      DAT_00b8fac4 = 0;
      return;
    }
    DAT_00b8fac4 = '\x01';
  }
  iVar4 = 0x8a;
  do {
    cVar2 = FUN_0057af40(iVar4);
    if (cVar2 != '\0') {
      if (iVar4 == 0x93) {
        DAT_00b8f215 = DAT_00b8f215 == '\0';
        if (!(bool)DAT_00b8f215) {
          FUN_0050d780(9);
        }
        DAT_00b8f216 = DAT_00b8f216 == '\0';
        if (!(bool)DAT_00b8f216) {
          iVar6 = 10;
          goto LAB_0050e366;
        }
      }
      else if (iVar4 == 0x94) {
        DAT_00b8f219 = DAT_00b8f219 == '\0';
        if (!(bool)DAT_00b8f219) {
          FUN_0050d780(0xd);
        }
        DAT_00b8f21a = DAT_00b8f21a == '\0';
        if (!(bool)DAT_00b8f21a) {
          iVar6 = 0xe;
          goto LAB_0050e366;
        }
      }
      else {
        bVar5 = *(char *)(iVar4 + 0xb8f182) == '\0';
        *(bool *)(iVar4 + 0xb8f182) = bVar5;
        if (!bVar5) {
          iVar6 = iVar4 + -0x8a;
LAB_0050e366:
          FUN_0050d780(iVar6);
        }
      }
    }
    iVar4 = iVar4 + 1;
    if (0x94 < iVar4) {
      cVar2 = FUN_0057af40(0x7f);
      if (cVar2 != '\0') {
        FUN_00501b30();
        bgRequestFGAction(FUN_0050e6b0,(void *)0x0,(void *)0x0);
      }
      cVar2 = FUN_0057af40(0x80);
      if (cVar2 != '\0') {
        if (DAT_00b8fac5 != '\0') {
          FUN_0050e120(DAT_00b8fb00,-DAT_00749424,0);
        }
        FUN_0050dec0();
      }
      cVar2 = FUN_0057af40(0x7e);
      if (cVar2 != '\0') {
        sVar3 = FUN_0055a690();
        if (sVar3 == 2) {
          DAT_00b8fac5 = DAT_00b8fac5 == '\0';
          if ((bool)DAT_00b8fac5) {
            _DAT_0074c36c = 0;
            iVar4 = 0;
            do {
              pcVar1 = s_Reflap_stashing_turned_on_007495e0 + iVar4;
              (&DAT_00b8f830)[iVar4] = *pcVar1;
              iVar4 = iVar4 + 1;
            } while (*pcVar1 != '\0');
          }
          else {
            _DAT_0074c36c = DAT_00b8fac8;
            FUN_0050e120(DAT_00b8fb00,-DAT_00749424,0);
            iVar4 = 0;
            do {
              pcVar1 = s_Reflap_stashing_turned_off_007495fc + iVar4;
              (&DAT_00b8f830)[iVar4] = *pcVar1;
              iVar4 = iVar4 + 1;
            } while (*pcVar1 != '\0');
          }
          DAT_00b8fa94 = &DAT_00b8f830;
        }
        else {
          DAT_00b8fac5 = '\0';
        }
      }
      cVar2 = FUN_0057af40(0x81);
      if (cVar2 != '\0') {
        DAT_00b8fad0 = 1;
        iVar4 = 0;
        do {
          pcVar1 = s_Reflap_splice_start_point_set_00749618 + iVar4;
          (&DAT_00b8f830)[iVar4] = *pcVar1;
          iVar4 = iVar4 + 1;
        } while (*pcVar1 != '\0');
        DAT_00b8fa94 = &DAT_00b8f830;
      }
      cVar2 = FUN_0057af40(0x82);
      if (cVar2 != '\0') {
        DAT_00b8fad1 = 1;
        iVar4 = 0;
        do {
          pcVar1 = s_Reflap_splice_end_point_set_00749638 + iVar4;
          (&DAT_00b8f830)[iVar4] = *pcVar1;
          iVar4 = iVar4 + 1;
        } while (*pcVar1 != '\0');
        DAT_00b8fa94 = &DAT_00b8f830;
      }
      cVar2 = FUN_0057af40(0x83);
      if (cVar2 != '\0') {
        DAT_00b8fad2 = 1;
        iVar4 = 0;
        do {
          pcVar1 = s_Reflap_splice_points_cleared_00749654 + iVar4;
          (&DAT_00b8f830)[iVar4] = *pcVar1;
          iVar4 = iVar4 + 1;
        } while (*pcVar1 != '\0');
        DAT_00b8fa94 = &DAT_00b8f830;
      }
      cVar2 = FUN_0057af40(0x95);
      if (cVar2 != '\0') {
        DAT_00b8fad3 = 1;
        iVar4 = 0;
        do {
          pcVar1 = s_Position_marker_set_00749674 + iVar4;
          (&DAT_00b8f830)[iVar4] = *pcVar1;
          iVar4 = iVar4 + 1;
        } while (*pcVar1 != '\0');
        DAT_00b8fa94 = &DAT_00b8f830;
      }
      cVar2 = FUN_0057af40(0x84);
      if (cVar2 != '\0') {
        FUN_0050de50(0xffffffff);
      }
      cVar2 = FUN_0057af40(0x85);
      if (cVar2 != '\0') {
        FUN_0050de50(1);
      }
      cVar2 = FUN_0057af40(0x89);
      if (cVar2 != '\0') {
        FUN_0050d7e0(DAT_00749428);
      }
      cVar2 = FUN_0057af40(0x86);
      if (cVar2 != '\0') {
        DAT_00749424 = DAT_00749424 - _DAT_006ea44c;
        if (DAT_00749424 < _DAT_006ea44c != (NAN(DAT_00749424) || NAN(_DAT_006ea44c))) {
          DAT_00749424 = 0.5;
        }
        if (DAT_00b8fadc != DAT_00b8fad4) {
          DAT_00b8fadc = FUN_0050d930(DAT_00b8fad4,-DAT_00749424);
        }
        if (DAT_00b8fae0 != DAT_00b8fad8) {
          DAT_00b8fae0 = FUN_0050d930(DAT_00b8fad8,DAT_00749424);
        }
      }
      cVar2 = FUN_0057af40(0x87);
      if (cVar2 != '\0') {
        DAT_00749424 = DAT_00749424 + _DAT_006ea44c;
        if (_DAT_006ea514 < DAT_00749424) {
          DAT_00749424 = 5.0;
        }
        if (DAT_00b8fadc != DAT_00b8fad4) {
          DAT_00b8fadc = FUN_0050d930(DAT_00b8fad4,-DAT_00749424);
        }
        if (DAT_00b8fae0 != DAT_00b8fad8) {
          DAT_00b8fae0 = FUN_0050d930(DAT_00b8fad8,DAT_00749424);
        }
      }
      return;
    }
  } while( true );
}

