0051f860 MOV EAX,dword ptr [ESP + 0x4]
0051f864 MOV EAX,dword ptr [EAX + 0x5ae]
0051f86a TEST EAX,EAX
0051f86c JZ 0x0051f8af
0051f86e FLD dword ptr [0x00e0bb54]
0051f874 FMUL dword ptr [EAX + 0x38]
0051f877 FLD dword ptr [0x00e0bb50]
0051f87d FMUL dword ptr [EAX + 0x34]
0051f880 MOV ECX,dword ptr [ESP + 0x8]
0051f884 MOV EDX,dword ptr [ESP + 0xc]
0051f888 FADDP
0051f88a FMUL dword ptr [0x006efe48]   ; [006efe48] f32=0.0277777779847 i32=1021546041 f64=1.43244536228e+32
0051f890 FSTP dword ptr [ECX]
0051f892 FLD dword ptr [0x00e0bb54]
0051f898 FMUL dword ptr [EAX + 0x34]
0051f89b FLD dword ptr [0x00e0bb50]
0051f8a1 FMUL dword ptr [EAX + 0x38]
0051f8a4 FSUBP
0051f8a6 FMUL dword ptr [0x006efe48]   ; [006efe48] f32=0.0277777779847 i32=1021546041 f64=1.43244536228e+32
0051f8ac FSTP dword ptr [EDX]
0051f8ae RET
0051f8af MOV EAX,dword ptr [ESP + 0x8]
0051f8b3 MOV ECX,dword ptr [ESP + 0xc]
0051f8b7 MOV dword ptr [EAX],0x0
0051f8bd MOV dword ptr [ECX],0x0
0051f8c3 RET
