005bcdd0 PUSH EDI
005bcdd1 MOV ECX,0x5dc
005bcdd6 XOR EAX,EAX
005bcdd8 MOV EDI,0xedf228
005bcddd STOSD.REP ES:EDI
005bcddf MOV ECX,0x190
005bcde4 MOV EDI,0xee0998
005bcde9 STOSD.REP ES:EDI
005bcdeb MOV dword ptr [0x00edb530],0x1
005bcdf5 XOR EDX,EDX
005bcdf7 POP EDI
005bcdf8 LEA EAX,[EDX + 0x5dc]
005bcdfe MOV dword ptr [EDX*0x4 + 0xebfc80],EAX
005bce05 INC EDX
005bce06 CMP EDX,0x190
005bce0c JL 0x005bcdf8
005bce0e MOV dword ptr [0x00ebfc7c],0x0
005bce18 MOV dword ptr [0x00ec3fbc],0x76c
005bce22 MOV dword ptr [0x00ec3fb8],0xdac
005bce2c MOV dword ptr [0x00ec02c4],0xebf610
005bce36 RET
