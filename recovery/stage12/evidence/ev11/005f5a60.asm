005f5a60 MOV ECX,dword ptr [ESP + 0x8]
005f5a64 MOV EAX,dword ptr [ESP + 0x4]
005f5a68 ADD EAX,0x58
005f5a6b MOV dword ptr [ESP + 0x8],ECX
005f5a6f MOV EDX,dword ptr [ECX]
005f5a71 MOV dword ptr [ESP + 0x4],EAX
005f5a75 MOV dword ptr [EAX + 0x24],EDX
005f5a78 MOV EDX,dword ptr [ECX + 0x4]
005f5a7b MOV dword ptr [EAX + 0x28],EDX
005f5a7e MOV EDX,dword ptr [ECX + 0x8]
005f5a81 MOV dword ptr [EAX + 0x2c],EDX
005f5a84 MOV EDX,dword ptr [ECX + 0xc]
005f5a87 MOV dword ptr [EAX + 0x30],EDX
005f5a8a JMP 0x005f6e40
