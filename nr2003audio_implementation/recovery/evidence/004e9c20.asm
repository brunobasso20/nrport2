004e9c20 FLD dword ptr [ECX + 0xc]
004e9c23 FCOMP dword ptr [ECX + 0x14]
004e9c26 FNSTSW AX
004e9c28 TEST AH,0x44
004e9c2b JNP 0x004e9c47
004e9c2d FLD dword ptr [ECX + 0x18]
004e9c30 FSUB dword ptr [ECX + 0x10]
004e9c33 FLD dword ptr [ECX + 0x14]
004e9c36 FSUB dword ptr [ECX + 0xc]
004e9c39 FDIVP
004e9c3b FST dword ptr [ECX + 0x8]
004e9c3e FMUL dword ptr [ECX + 0xc]
004e9c41 FSUBR dword ptr [ECX + 0x10]
004e9c44 FSTP dword ptr [ECX + 0x4]
004e9c47 RET
