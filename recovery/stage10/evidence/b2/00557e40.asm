00557e40 PUSH ECX
00557e41 MOV EAX,dword ptr [ESP + 0x8]
00557e45 PUSH ESI
00557e46 LEA EDX,[EAX + EAX*0x2]
00557e49 MOV EAX,dword ptr [ECX + EAX*0x4]
00557e4c PUSH EAX
00557e4d MOV ESI,dword ptr [EDX*0x2 + 0xc05152]
00557e54 CALL dword ptr [ESI + 0x16]
00557e57 MOV ECX,dword ptr [ESI + 0x12]
00557e5a ADD ESP,0x4
00557e5d TEST ECX,ECX
00557e5f MOV dword ptr [ESP + 0xc],EAX
00557e63 JZ 0x00557ece
00557e65 CMP word ptr [ESI],0x3
00557e69 MOV dword ptr [ESP + 0xc],EAX
00557e6d JNZ 0x00557e78
00557e6f SUB EAX,dword ptr [ESI + 0x2]
00557e72 CDQ
00557e73 IDIV dword ptr [ESI + 0xa]
00557e76 JMP 0x00557e98
00557e78 FLD dword ptr [ESP + 0xc]
00557e7c FSUB dword ptr [ESI + 0x2]
00557e7f FDIV dword ptr [ESI + 0xa]
00557e82 FADD dword ptr [0x006ea4cc]   ; [006ea4cc] f32=0.10000000149 i32=1036831949 f64=-9.12696248093e-10
00557e88 FSTP dword ptr [ESP + 0xc]
00557e8c FLD dword ptr [ESP + 0xc]
00557e90 FISTP dword ptr [ESP + 0x4]
00557e94 MOV EAX,dword ptr [ESP + 0x4]
00557e98 CMP word ptr [ESI],0x4
00557e9c MOV dword ptr [ESP + 0xc],EAX
00557ea0 JNZ 0x00557ec1
00557ea2 FILD dword ptr [ESP + 0xc]
00557ea6 FMUL dword ptr [ESI + 0xa]
00557ea9 FADD dword ptr [ESI + 0x2]
00557eac POP ESI
00557ead FSTP dword ptr [ESP + 0x8]
00557eb1 MOV ECX,dword ptr [ESP + 0x8]
00557eb5 MOV dword ptr [ESP + 0x8],ECX
00557eb9 FLD dword ptr [ESP + 0x8]
00557ebd POP ECX
00557ebe RET 0x4
00557ec1 MOV ECX,dword ptr [ESI + 0xa]
00557ec4 IMUL ECX,EAX
00557ec7 ADD ECX,dword ptr [ESI + 0x2]
00557eca MOV dword ptr [ESP + 0xc],ECX
00557ece FLD dword ptr [ESP + 0xc]
00557ed2 POP ESI
00557ed3 POP ECX
00557ed4 RET 0x4
