005f6d20 MOV EDX,dword ptr [ESP + 0x4]
005f6d24 MOV EAX,dword ptr [ESP + 0xc]
005f6d28 MOV ECX,dword ptr [ESP + 0x8]
005f6d2c CMP EDX,EAX
005f6d2e JNZ 0x005f6d79
005f6d30 FLD dword ptr [ECX + 0x10]
005f6d33 FMUL dword ptr [EAX + 0x4]
005f6d36 FLD dword ptr [ECX + 0xc]
005f6d39 FMUL dword ptr [EAX]
005f6d3b FADDP
005f6d3d FLD dword ptr [ECX + 0x14]
005f6d40 FMUL dword ptr [EAX + 0x8]
005f6d43 FADDP
005f6d45 FLD dword ptr [ECX + 0x1c]
005f6d48 FMUL dword ptr [EAX + 0x4]
005f6d4b FLD dword ptr [ECX + 0x18]
005f6d4e FMUL dword ptr [EAX]
005f6d50 FADDP
005f6d52 FLD dword ptr [ECX + 0x20]
005f6d55 FMUL dword ptr [EAX + 0x8]
005f6d58 FADDP
005f6d5a FLD dword ptr [ECX + 0x4]
005f6d5d FMUL dword ptr [EAX + 0x4]
005f6d60 FLD dword ptr [ECX + 0x8]
005f6d63 FMUL dword ptr [EAX + 0x8]
005f6d66 FADDP
005f6d68 FLD dword ptr [ECX]
005f6d6a FMUL dword ptr [EAX]
005f6d6c FADDP
005f6d6e FSTP dword ptr [EDX]
005f6d70 FXCH
005f6d72 FSTP dword ptr [EDX + 0x4]
005f6d75 FSTP dword ptr [EDX + 0x8]
005f6d78 RET
005f6d79 FLD dword ptr [ECX + 0x4]
005f6d7c FMUL dword ptr [EAX + 0x4]
005f6d7f FLD dword ptr [ECX + 0x8]
005f6d82 FMUL dword ptr [EAX + 0x8]
005f6d85 FADDP
005f6d87 FLD dword ptr [ECX]
005f6d89 FMUL dword ptr [EAX]
005f6d8b FADDP
005f6d8d FSTP dword ptr [EDX]
005f6d8f FLD dword ptr [ECX + 0x10]
005f6d92 FMUL dword ptr [EAX + 0x4]
005f6d95 FLD dword ptr [ECX + 0xc]
005f6d98 FMUL dword ptr [EAX]
005f6d9a FADDP
005f6d9c FLD dword ptr [ECX + 0x14]
005f6d9f FMUL dword ptr [EAX + 0x8]
005f6da2 FADDP
005f6da4 FSTP dword ptr [EDX + 0x4]
005f6da7 FLD dword ptr [ECX + 0x1c]
005f6daa FMUL dword ptr [EAX + 0x4]
005f6dad FLD dword ptr [ECX + 0x18]
005f6db0 FMUL dword ptr [EAX]
005f6db2 FADDP
005f6db4 FLD dword ptr [ECX + 0x20]
005f6db7 FMUL dword ptr [EAX + 0x8]
005f6dba FADDP
005f6dbc FSTP dword ptr [EDX + 0x8]
005f6dbf RET
