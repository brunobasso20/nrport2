005f59f0 MOV ECX,dword ptr [ESP + 0x8]
005f59f4 MOV EAX,dword ptr [ESP + 0x4]
005f59f8 MOV EDX,dword ptr [ECX]
005f59fa MOV dword ptr [EAX + 0xc],EDX
005f59fd MOV EDX,dword ptr [ECX + 0x4]
005f5a00 MOV dword ptr [EAX + 0x10],EDX
005f5a03 MOV ECX,dword ptr [ECX + 0x8]
005f5a06 MOV dword ptr [EAX + 0x14],ECX
005f5a09 FLD dword ptr [EAX + 0x10]
005f5a0c FMUL dword ptr [EAX + 0x38]
005f5a0f FLD dword ptr [EAX + 0x34]
005f5a12 FMUL dword ptr [EAX + 0xc]
005f5a15 FADDP
005f5a17 FSTP dword ptr [EAX + 0x44]
005f5a1a FLD dword ptr [EAX + 0x10]
005f5a1d FMUL dword ptr [EAX + 0x34]
005f5a20 FLD dword ptr [EAX + 0x38]
005f5a23 FMUL dword ptr [EAX + 0xc]
005f5a26 FSUBP
005f5a28 FSTP dword ptr [EAX + 0x48]
005f5a2b RET
