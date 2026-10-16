004ecdb0 MOV EAX,dword ptr [ECX + 0x2c]
004ecdb3 MOV EDX,dword ptr [ECX + 0x28]
004ecdb6 FLD dword ptr [ECX + 0x18]
004ecdb9 FDIV dword ptr [EDX + EAX*0x4 + 0x184c]
004ecdc0 FMUL dword ptr [ECX + 0x20]
004ecdc3 FCOM dword ptr [0x006ea50c]   ; [006ea50c] f32=0.25 i32=1048576000 f64=9.2703669417e-18
004ecdc9 FNSTSW AX
004ecdcb TEST AH,0x5
004ecdce JP 0x004ecdd8
004ecdd0 FSTP ST0
004ecdd2 FLD dword ptr [0x006ea50c]   ; [006ea50c] f32=0.25 i32=1048576000 f64=9.2703669417e-18
004ecdd8 RET
