004e9bd0 FLD dword ptr [ESP + 0x8]
004e9bd4 MOV EDX,dword ptr [ESP + 0x4]
004e9bd8 FSTP dword ptr [EDX]
004e9bda FLD dword ptr [ECX + 0xc]
004e9bdd FCOMP dword ptr [ECX + 0x14]
004e9be0 FNSTSW AX
004e9be2 TEST AH,0x44
004e9be5 JNP 0x004e9bf3
004e9be7 FLD dword ptr [ESP + 0x8]
004e9beb FMUL dword ptr [ECX + 0x8]
004e9bee FADD dword ptr [ECX + 0x4]
004e9bf1 JMP 0x004e9bf6
004e9bf3 FLD dword ptr [ECX + 0x10]
004e9bf6 FST dword ptr [EDX + 0x4]
004e9bf9 FCOMP dword ptr [0x006ea454]   ; [006ea454] f32=0.0 i32=0 f64=-2048.0
004e9bff FNSTSW AX
004e9c01 AND EAX,0x100
004e9c06 MOV AL,0x1
004e9c08 JZ 0x004e9c11
004e9c0a MOV dword ptr [EDX + 0x4],0x0
004e9c11 RET 0xc
