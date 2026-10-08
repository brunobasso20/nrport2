005f6dc0 MOV EAX,dword ptr [ESP + 0xc]
005f6dc4 SUB ESP,0xc
005f6dc7 LEA EDX,[ESP]
005f6dcb PUSH ESI
005f6dcc MOV ESI,dword ptr [ESP + 0x14]
005f6dd0 CMP ESI,EAX
005f6dd2 JZ 0x005f6dd6
005f6dd4 MOV EDX,ESI
005f6dd6 MOV ECX,dword ptr [ESP + 0x18]
005f6dda CMP EDX,ESI
005f6ddc FLD dword ptr [ECX + 0x18]
005f6ddf FMUL dword ptr [EAX + 0x8]
005f6de2 FLD dword ptr [ECX + 0xc]
005f6de5 FMUL dword ptr [EAX + 0x4]
005f6de8 FADDP
005f6dea FLD dword ptr [ECX]
005f6dec FMUL dword ptr [EAX]
005f6dee FADDP
005f6df0 FSTP dword ptr [EDX]
005f6df2 FLD dword ptr [ECX + 0x4]
005f6df5 FMUL dword ptr [EAX]
005f6df7 FLD dword ptr [ECX + 0x1c]
005f6dfa FMUL dword ptr [EAX + 0x8]
005f6dfd FADDP
005f6dff FLD dword ptr [ECX + 0x10]
005f6e02 FMUL dword ptr [EAX + 0x4]
005f6e05 FADDP
005f6e07 FSTP dword ptr [EDX + 0x4]
005f6e0a FLD dword ptr [ECX + 0x8]
005f6e0d FMUL dword ptr [EAX]
005f6e0f FLD dword ptr [ECX + 0x20]
005f6e12 FMUL dword ptr [EAX + 0x8]
005f6e15 FADDP
005f6e17 FLD dword ptr [ECX + 0x14]
005f6e1a FMUL dword ptr [EAX + 0x4]
005f6e1d FADDP
005f6e1f FSTP dword ptr [EDX + 0x8]
005f6e22 JZ 0x005f6e34
005f6e24 MOV EAX,dword ptr [EDX]
005f6e26 MOV dword ptr [ESI],EAX
005f6e28 MOV ECX,dword ptr [EDX + 0x4]
005f6e2b MOV dword ptr [ESI + 0x4],ECX
005f6e2e MOV EDX,dword ptr [EDX + 0x8]
005f6e31 MOV dword ptr [ESI + 0x8],EDX
005f6e34 POP ESI
005f6e35 ADD ESP,0xc
005f6e38 RET
