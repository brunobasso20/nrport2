/* NR2003.exe @ 00427460 SetValue */

/* public: virtual void __thiscall ProfileCString<24>::SetValue(char *,bool) */

void __thiscall ProfileCString<24>::SetValue(ProfileCString<24> *this,char *param_1,bool param_2)

{
  char cVar1;
  char *pcVar2;
  int iVar3;
  int iVar4;
  uint uVar5;
  undefined4 unaff_EBX;
  undefined4 unaff_EBP;
  undefined4 unaff_ESI;
  char *pcVar6;
  
                    /* 0x27460  171  ?SetValue@?$ProfileCString@$0BI@@@UAEXPAD_N@Z */
  pcVar2 = *(char **)(this + 0x22);
  if ((param_1 != (char *)0x0) && (pcVar2 != (char *)0x0)) {
    cVar1 = *param_1;
    while ((cVar1 != '\0' &&
           (iVar3 = FUN_006c4cd1((int)cVar1,unaff_ESI,unaff_EBP,unaff_EBX), iVar3 != 0))) {
      cVar1 = param_1[1];
      param_1 = param_1 + 1;
    }
    FUN_006c4b00(pcVar2,param_1,0x18);
    uVar5 = 0xffffffff;
    pcVar2[0x17] = '\0';
    pcVar6 = pcVar2;
    do {
      if (uVar5 == 0) break;
      uVar5 = uVar5 - 1;
      cVar1 = *pcVar6;
      pcVar6 = pcVar6 + 1;
    } while (cVar1 != '\0');
    iVar3 = ~uVar5 - 2;
    while ((-1 < iVar3 && (iVar4 = FUN_006c4cd1((int)pcVar2[iVar3]), iVar4 != 0))) {
      pcVar2[iVar3] = '\0';
      iVar3 = iVar3 + -1;
    }
  }
  if (param_2) {
    FUN_006c4b00(this + 0x3e,pcVar2,0x18);
  }
  return;
}

