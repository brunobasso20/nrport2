005b4cc0 PUSH EBX
005b4cc1 PUSH EBP
005b4cc2 MOV EBP,dword ptr [ESP + 0xc]
005b4cc6 PUSH ESI
005b4cc7 MOV ESI,dword ptr [ESP + 0x14]
005b4ccb PUSH EDI
005b4ccc MOV ECX,0xe
005b4cd1 MOV EDI,EBP
005b4cd3 MOVSD.REP ES:EDI,ESI
005b4cd5 FLD float ptr [0x00ebbd80]
005b4cdb FLD float ptr [EBP + 0x18]
005b4cde FSUB float ptr [EBP + 0xc]
005b4ce1 FMUL ST1
005b4ce3 FADD float ptr [EBP + 0xc]
005b4ce6 FSTP float ptr [EBP + 0x18]
005b4ce9 FLD float ptr [EBP + 0x1c]
005b4cec FSUB float ptr [EBP + 0x10]
005b4cef FMUL ST1
005b4cf1 FADD float ptr [EBP + 0x10]
005b4cf4 FSTP float ptr [EBP + 0x1c]
005b4cf7 FLD float ptr [EBP + 0x20]
005b4cfa FSUB float ptr [EBP + 0x14]
005b4cfd FMUL ST1
005b4cff FADD float ptr [EBP + 0x14]
005b4d02 FSTP float ptr [EBP + 0x20]
005b4d05 FLD float ptr [EBP + 0x24]
005b4d08 FSUB float ptr [EBP]
005b4d0b FMUL ST1
005b4d0d FADD float ptr [EBP]
005b4d10 FSTP float ptr [EBP + 0x24]
005b4d13 FLD float ptr [EBP + 0x28]
005b4d16 FSUB float ptr [EBP + 0x4]
005b4d19 FMUL ST1
005b4d1b FADD float ptr [EBP + 0x4]
005b4d1e FSTP float ptr [EBP + 0x28]
005b4d21 FLD float ptr [EBP + 0x2c]
005b4d24 FSUB float ptr [EBP + 0x8]
005b4d27 FMUL ST1
005b4d29 FADD float ptr [EBP + 0x8]
005b4d2c FSTP float ptr [EBP + 0x2c]
005b4d2f FCOM float ptr [0x006ea454]
005b4d35 FNSTSW AX
005b4d37 TEST AH,0x5
005b4d3a JP 0x005b4d46
005b4d3c FSTP ST0
005b4d3e FLD float ptr [0x006ea454]
005b4d44 JMP 0x005b4d5d
005b4d46 FCOM float ptr [0x006e97d8]
005b4d4c FNSTSW AX
005b4d4e AND EAX,0x4100
005b4d53 JNZ 0x005b4d5d
005b4d55 FSTP ST0
005b4d57 FLD float ptr [0x006e97d8]
005b4d5d MOV BL,byte ptr [EBP + 0x31]
005b4d60 XOR EAX,EAX
005b4d62 MOV AL,byte ptr [EBP + 0x32]
005b4d65 MOV ECX,EBX
005b4d67 AND ECX,0xff
005b4d6d SUB EAX,ECX
005b4d6f MOV dword ptr [ESP + 0x18],EAX
005b4d73 FILD dword ptr [ESP + 0x18]
005b4d77 FMUL ST1
005b4d79 CALL 0x006c5018
005b4d7e ADD AL,BL
005b4d80 MOV BL,byte ptr [EBP + 0x30]
005b4d83 MOV byte ptr [EBP + 0x32],AL
005b4d86 XOR EDX,EDX
005b4d88 MOV DL,byte ptr [EBP + 0x33]
005b4d8b MOV EAX,EBX
005b4d8d AND EAX,0xff
005b4d92 SUB EDX,EAX
005b4d94 MOV dword ptr [ESP + 0x18],EDX
005b4d98 FILD dword ptr [ESP + 0x18]
005b4d9c FMUL ST1
005b4d9e CALL 0x006c5018
005b4da3 ADD AL,BL
005b4da5 POP EDI
005b4da6 MOV byte ptr [EBP + 0x33],AL
005b4da9 POP ESI
005b4daa POP EBP
005b4dab POP EBX
005b4dac FSTP ST0
005b4dae RET
