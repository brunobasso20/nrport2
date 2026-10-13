1002cf00 PUSH ECX
1002cf01 PUSH EBX
1002cf02 MOV EBX,0x1
1002cf07 PUSH ESI
1002cf08 PUSH EBX
1002cf09 MOV ESI,ECX
1002cf0b CALL 0x1002cad0
1002cf10 CMP EAX,EBX
1002cf12 JNZ 0x1002cffa
1002cf18 MOV ECX,dword ptr [ESI + 0x5c]
1002cf1b PUSH EBP
1002cf1c PUSH EDI
1002cf1d XOR EDX,EDX
1002cf1f MOV EDI,dword ptr [ECX + 0x1c]
1002cf22 MOV EBP,dword ptr [ECX + 0xec]
1002cf28 CMP EBP,EDX
1002cf2a MOV EAX,dword ptr [ECX + EDI*0x4 + 0x8]
1002cf2e JNZ 0x1002cf3b
1002cf30 MOV dword ptr [EAX + 0x2c],EDX
1002cf33 MOV dword ptr [EAX + 0x1c],EDX
1002cf36 MOV dword ptr [EAX + 0x20],EBX
1002cf39 JMP 0x1002cf56
1002cf3b MOV dword ptr [EAX + 0x2c],EBX
1002cf3e MOV dword ptr [EAX + 0x1c],EBX
1002cf41 MOV dword ptr [EAX + 0x20],0xd2
1002cf48 MOV dword ptr [EAX + 0x30],0x5
1002cf4f MOV dword ptr [EAX + 0x34],0x6
1002cf56 MOV byte ptr [ESP + 0x10],DL
1002cf5a MOV EDX,dword ptr [ESI + 0xc]
1002cf5d TEST DL,0x4
1002cf60 MOV ECX,0x2
1002cf65 JZ 0x1002cf70
1002cf67 MOV dword ptr [EAX + 0x8],0x0
1002cf6e JMP 0x1002cf80
1002cf70 TEST CL,DL
1002cf72 JZ 0x1002cf79
1002cf74 MOV dword ptr [EAX + 0x8],EBX
1002cf77 JMP 0x1002cf80
1002cf79 MOV dword ptr [EAX + 0x8],ECX
1002cf7c MOV byte ptr [ESP + 0x10],BL
1002cf80 MOV EDX,dword ptr [0x100b6be4]
1002cf86 MOV dword ptr [EAX + 0xc],EBX
1002cf89 ADD EDI,EDX
1002cf8b MOV EDX,0x4
1002cf90 MOV dword ptr [EAX + 0x28],EDI
1002cf93 XOR EDI,EDI
1002cf95 MOV dword ptr [EAX + 0x18],EBX
1002cf98 MOV dword ptr [EAX + 0x24],EDX
1002cf9b MOV dword ptr [EAX + 0xbd],EDX
1002cfa1 MOV dword ptr [EAX + 0xc1],ECX
1002cfa7 MOV dword ptr [EAX + 0xc5],EBX
1002cfad MOV dword ptr [EAX + 0xc9],0x3
1002cfb7 MOV dword ptr [EAX + 0xcd],ECX
1002cfbd MOV dword ptr [EAX + 0xd1],EBX
1002cfc3 MOV dword ptr [EAX + 0x7c],ECX
1002cfc6 MOV dword ptr [EAX + 0x80],ECX
1002cfcc MOV dword ptr [EAX + 0x84],EDI
1002cfd2 MOV dword ptr [EAX + 0x88],ECX
1002cfd8 MOV dword ptr [EAX + 0x8c],ECX
1002cfde MOV dword ptr [EAX + 0x90],EDI
1002cfe4 MOV EAX,dword ptr [ESP + 0x10]
1002cfe8 PUSH EAX
1002cfe9 PUSH 0x10
1002cfeb PUSH EDX
1002cfec PUSH ECX
1002cfed MOV ECX,ESI
1002cfef CALL 0x1002ceb0
1002cff4 POP EDI
1002cff5 POP EBP
1002cff6 POP ESI
1002cff7 POP EBX
1002cff8 POP ECX
1002cff9 RET
1002cffa POP ESI
1002cffb XOR EAX,EAX
1002cffd POP EBX
1002cffe POP ECX
1002cfff RET
