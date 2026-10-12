/* NR2003.exe @ 004273f0 Initialize */

/* public: virtual void __thiscall ProfileCString<24>::Initialize(int,char const * const,char const
   * const,char const * const,char * const,enum ProfileValue::SaveOption,enum
   ProfileValue::SaveOption) */

void __thiscall
ProfileCString<24>::Initialize
          (ProfileCString<24> *this,int param_1,char *param_2,char *param_3,char *param_4,
          char *param_5,SaveOption param_6,SaveOption param_7)

{
  undefined4 unaff_ESI;
  
                    /* 0x273f0  76
                       ?Initialize@?$ProfileCString@$0BI@@@UAEXHQBD00QADW4SaveOption@ProfileValue@@2@Z
                        */
  FUN_005cfcc6(param_1,param_2,param_3,param_4,param_6,param_7);
  *(undefined4 *)(this + 0x22) = unaff_ESI;
  FUN_006c4b00(this + 0x26,unaff_ESI,0x18);
  FUN_006c4b00(this + 0x3e,this + 0x26,0x18);
  return;
}

