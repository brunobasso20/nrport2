00577cb0 MOV EDX,dword ptr [ECX + 0x8]
00577cb3 SUB ESP,0x30
00577cb6 TEST EDX,EDX
00577cb8 JZ 0x00577d92
00577cbe MOV EAX,dword ptr [ECX + 0x38]
00577cc1 FLD dword ptr [EAX + 0x24]
00577cc4 FSUB dword ptr [EAX + 0x14]
00577cc7 MOV EAX,dword ptr [ECX + 0x28]
00577cca FLD dword ptr [EAX + 0x24]
00577ccd FSUB dword ptr [EAX + 0x14]
00577cd0 MOV EAX,dword ptr [ECX + 0x2c]
00577cd3 FSTP dword ptr [ESP]
00577cd7 FLD dword ptr [EAX + 0x24]
00577cda FSUB dword ptr [EAX + 0x14]
00577cdd MOV EAX,dword ptr [ECX + 0x30]
00577ce0 MOV ECX,dword ptr [ECX + 0x34]
00577ce3 FSTP dword ptr [ESP + 0xc]
00577ce7 FLD dword ptr [EAX + 0x24]
00577cea FSUB dword ptr [EAX + 0x14]
00577ced FSTP dword ptr [ESP + 0x18]
00577cf1 FLD dword ptr [ECX + 0x24]
00577cf4 FSUB dword ptr [ECX + 0x14]
00577cf7 FSTP dword ptr [ESP + 0x24]
00577cfb FCOM dword ptr [ESP]
00577cff FNSTSW AX
00577d01 AND EAX,0x4100
00577d06 JNZ 0x00577d0e
00577d08 FSTP ST0
00577d0a FLD dword ptr [ESP]
00577d0e FCOM dword ptr [ESP + 0xc]
00577d12 FNSTSW AX
00577d14 AND EAX,0x4100
00577d19 JNZ 0x00577d21
00577d1b FSTP ST0
00577d1d FLD dword ptr [ESP + 0xc]
00577d21 FLD dword ptr [ESP + 0x18]
00577d25 FLD dword ptr [ESP + 0x18]
00577d29 FCOMP dword ptr [ESP + 0x24]
00577d2d FNSTSW AX
00577d2f AND EAX,0x4100
00577d34 JNZ 0x00577d3c
00577d36 FSTP ST0
00577d38 FLD dword ptr [ESP + 0x24]
00577d3c MOV EAX,dword ptr [EDX + 0x10]
00577d3f TEST EAX,EAX
00577d41 JZ 0x00577d8e
00577d43 FLD ST1
00577d45 FMUL dword ptr [EAX + 0x8]
00577d48 FADD dword ptr [EAX + 0x14]
00577d4b FSTP dword ptr [EAX + 0x14]
00577d4e MOV EAX,dword ptr [EAX + 0x18]
00577d51 FMUL dword ptr [EAX + 0x8]
00577d54 FADD dword ptr [EAX + 0x14]
00577d57 FSTP dword ptr [EAX + 0x14]
00577d5a MOV EAX,dword ptr [EAX + 0x18]
00577d5d MOV ECX,dword ptr [EAX + 0x18]
00577d60 MOV EDX,dword ptr [ECX + 0x18]
00577d63 MOV EAX,dword ptr [EDX + 0x18]
00577d66 MOV ECX,dword ptr [EAX + 0x18]
00577d69 MOV EDX,dword ptr [ECX + 0x18]
00577d6c MOV EAX,dword ptr [EDX + 0x18]
00577d6f FLD dword ptr [EAX + 0x8]
00577d72 FMUL ST1
00577d74 FADD dword ptr [EAX + 0x14]
00577d77 FSTP dword ptr [EAX + 0x14]
00577d7a MOV EAX,dword ptr [EAX + 0x18]
00577d7d FLD dword ptr [EAX + 0x8]
00577d80 FMUL ST1
00577d82 FADD dword ptr [EAX + 0x14]
00577d85 FSTP dword ptr [EAX + 0x14]
00577d88 FSTP ST0
00577d8a ADD ESP,0x30
00577d8d RET
00577d8e FSTP ST0
00577d90 FSTP ST0
00577d92 ADD ESP,0x30
00577d95 RET
