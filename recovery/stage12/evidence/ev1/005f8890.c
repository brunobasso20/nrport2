/* NR2003.exe @ 005f8890 inServer */

/* bool __cdecl inServer(void) */

bool __cdecl inServer(void)

{
  int iVar1;
  int iVar2;
  
                    /* 0x1f8890  256  ?inServer@@YA_NXZ */
  iVar1 = DAT_00f7219c;
  iVar2 = (*DAT_0103b4ec)();
  return iVar2 == iVar1;
}

