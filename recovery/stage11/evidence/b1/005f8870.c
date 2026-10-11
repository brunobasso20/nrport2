/* NR2003.exe @ 005f8870 inBackground */

/* bool __cdecl inBackground(void) */

bool __cdecl inBackground(void)

{
  int iVar1;
  int iVar2;
  
                    /* 0x1f8870  251  ?inBackground@@YA_NXZ */
  iVar1 = DAT_00f72274;
  iVar2 = (*DAT_0103b4cc)();
  return iVar2 == iVar1;
}

