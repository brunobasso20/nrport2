004e9ce0 MOV ECX,dword ptr [ECX + 0x14]
004e9ce3 TEST ECX,ECX
004e9ce5 JZ 0x004e9cfc
004e9ce7 MOV EDX,dword ptr [ESP + 0xc]
004e9ceb MOV EAX,dword ptr [ECX]
004e9ced MOV dword ptr [ESP + 0xc],EDX
004e9cf1 MOV EDX,dword ptr [ESP + 0x8]
004e9cf5 MOV dword ptr [ESP + 0x8],EDX
004e9cf9 JMP dword ptr [EAX + 0x4]
004e9cfc MOV EAX,dword ptr [ESP + 0x4]
004e9d00 MOV dword ptr [EAX + 0x4],0x3f800000
004e9d07 XOR AL,AL
004e9d09 RET 0xc
