/* NR2003.exe @ 00427510 ValueEqualsDefault */

/* public: virtual bool __thiscall ProfileCString<24>::ValueEqualsDefault(void) */

bool __thiscall ProfileCString<24>::ValueEqualsDefault(ProfileCString<24> *this)

{
  int iVar1;
  
                    /* 0x27510  193  ?ValueEqualsDefault@?$ProfileCString@$0BI@@@UAE_NXZ */
  iVar1 = FUN_006c4fe0(*(undefined4 *)(this + 0x22),this + 0x26,0x18);
  return (bool)('\x01' - (iVar1 != 0));
}

