005bccc0 MOV EAX,[0x00b8faa0]
005bccc5 XOR ECX,ECX
005bccc7 TEST EAX,EAX
005bccc9 JLE 0x005bcd35
005bcccb PUSH ESI
005bcccc MOV ESI,dword ptr [ESP + 0xc]
005bccd0 PUSH EDI
005bccd1 MOV EDI,dword ptr [ESP + 0x14]
005bccd5 SUB ESI,EDI
005bccd7 MOV EAX,[0x00b8faa8]
005bccdc MOV EDX,dword ptr [0x00b8faac]
005bcce2 FLD dword ptr [EAX + ECX*0x4]
005bcce5 FLD dword ptr [EDX + ECX*0x4]
005bcce8 FLD ST0
005bccea FMUL ST1
005bccec FLD ST2
005bccee FMUL ST3
005bccf0 LEA EDX,[EDI + ECX*0x4]
005bccf3 FADDP
005bccf5 FSQRT
005bccf7 FSTP ST2
005bccf9 FSTP ST0
005bccfb FST dword ptr [ESP + 0x10]
005bccff FSTP dword ptr [ESI + EDX*0x1]
005bcd02 FLD dword ptr [ESP + 0x10]
005bcd06 FCOMP dword ptr [0x006f412c]   ; [006f412c] f32=9.99999971718e-10 i32=814313567 f64=5.6124725889e-28
005bcd0c FNSTSW AX
005bcd0e TEST AH,0x5
005bcd11 JP 0x005bcd1b
005bcd13 MOV dword ptr [EDX],0x0
005bcd19 JMP 0x005bcd29
005bcd1b MOV EAX,[0x00b8faa8]
005bcd20 FLD dword ptr [EAX + ECX*0x4]
005bcd23 FDIV dword ptr [ESP + 0x10]
005bcd27 FSTP dword ptr [EDX]
005bcd29 MOV EAX,[0x00b8faa0]
005bcd2e INC ECX
005bcd2f CMP ECX,EAX
005bcd31 JL 0x005bccd7
005bcd33 POP EDI
005bcd34 POP ESI
005bcd35 MOV EAX,0x1
005bcd3a RET
