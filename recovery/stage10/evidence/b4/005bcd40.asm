005bcd40 MOV ECX,dword ptr [0x00b8faa0]
005bcd46 XOR EAX,EAX
005bcd48 TEST ECX,ECX
005bcd4a JLE 0x005bcd69
005bcd4c MOV ECX,dword ptr [ESP + 0x8]
005bcd50 MOV EDX,dword ptr [0x00b8faac]
005bcd56 INC EAX
005bcd57 MOV EDX,dword ptr [EDX + EAX*0x4 + -0x4]
005bcd5b MOV dword ptr [ECX + EAX*0x4 + -0x4],EDX
005bcd5f MOV EDX,dword ptr [0x00b8faa0]
005bcd65 CMP EAX,EDX
005bcd67 JL 0x005bcd50
005bcd69 MOV EAX,0x1
005bcd6e RET
