004ed1d0 MOV ECX,dword ptr [ECX]
004ed1d2 TEST ECX,ECX
004ed1d4 JZ 0x004ed1e3
004ed1d6 MOV EAX,dword ptr [ESP + 0x4]
004ed1da MOV dword ptr [ESP + 0x4],EAX
004ed1de JMP 0x004f07e0
004ed1e3 RET 0x4
