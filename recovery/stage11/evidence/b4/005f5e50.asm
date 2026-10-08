005f5e50 PUSH EDI
005f5e51 MOV EDI,dword ptr [ESP + 0x10]
005f5e55 FLD dword ptr [EDI + 0x8]
005f5e58 FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
005f5e5e FNSTSW AX
005f5e60 TEST AH,0x44
005f5e63 JNP 0x005f5ee0
005f5e65 PUSH ESI
005f5e66 MOV ESI,dword ptr [ESP + 0x10]
005f5e6a PUSH ESI
005f5e6b FLD dword ptr [ESI]
005f5e6d FMUL dword ptr [EDI]
005f5e6f FLD dword ptr [EDI + 0x4]
005f5e72 FMUL dword ptr [ESI + 0x4]
005f5e75 FADDP
005f5e77 FDIV dword ptr [EDI + 0x8]
005f5e7a FCHS
005f5e7c FSTP dword ptr [ESI + 0x8]
005f5e7f CALL 0x005f6a70
005f5e84 FLD dword ptr [EDI]
005f5e86 FMUL dword ptr [ESI + 0x4]
005f5e89 FLD dword ptr [EDI + 0x4]
005f5e8c FMUL dword ptr [ESI]
005f5e8e MOV EAX,dword ptr [ESP + 0x10]
005f5e92 MOV ECX,dword ptr [ESI]
005f5e94 ADD ESP,0x4
005f5e97 FSUBP
005f5e99 FLD dword ptr [ESI + 0x8]
005f5e9c FMUL dword ptr [EDI + 0x4]
005f5e9f FLD dword ptr [ESI + 0x4]
005f5ea2 FMUL dword ptr [EDI + 0x8]
005f5ea5 FSUBP
005f5ea7 FLD dword ptr [ESI]
005f5ea9 FMUL dword ptr [EDI + 0x8]
005f5eac FLD dword ptr [ESI + 0x8]
005f5eaf FMUL dword ptr [EDI]
005f5eb1 MOV dword ptr [EAX],ECX
005f5eb3 MOV EDX,dword ptr [ESI + 0x4]
005f5eb6 MOV dword ptr [EAX + 0xc],EDX
005f5eb9 MOV ECX,dword ptr [ESI + 0x8]
005f5ebc FSUBP
005f5ebe FXCH
005f5ec0 FSTP dword ptr [EAX + 0x4]
005f5ec3 MOV dword ptr [EAX + 0x18],ECX
005f5ec6 POP ESI
005f5ec7 FSTP dword ptr [EAX + 0x10]
005f5eca FSTP dword ptr [EAX + 0x1c]
005f5ecd MOV EDX,dword ptr [EDI]
005f5ecf MOV dword ptr [EAX + 0x8],EDX
005f5ed2 MOV ECX,dword ptr [EDI + 0x4]
005f5ed5 MOV dword ptr [EAX + 0x14],ECX
005f5ed8 MOV EDX,dword ptr [EDI + 0x8]
005f5edb MOV dword ptr [EAX + 0x20],EDX
005f5ede POP EDI
005f5edf RET
005f5ee0 MOV EAX,dword ptr [ESP + 0xc]
005f5ee4 XOR ECX,ECX
005f5ee6 MOV EDX,0x3f800000
005f5eeb POP EDI
005f5eec MOV dword ptr [EAX + 0x8],ECX
005f5eef MOV EAX,dword ptr [ESP + 0x4]
005f5ef3 MOV dword ptr [EAX + 0x10],EDX
005f5ef6 MOV dword ptr [EAX],EDX
005f5ef8 MOV dword ptr [EAX + 0x1c],ECX
005f5efb MOV dword ptr [EAX + 0x18],ECX
005f5efe MOV dword ptr [EAX + 0x14],ECX
005f5f01 MOV dword ptr [EAX + 0xc],ECX
005f5f04 MOV dword ptr [EAX + 0x8],ECX
005f5f07 MOV dword ptr [EAX + 0x4],ECX
005f5f0a MOV dword ptr [EAX + 0x20],EDX
005f5f0d RET
