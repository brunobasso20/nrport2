00557dc0 MOV EAX,dword ptr [ESP + 0x4]
00557dc4 LEA EAX,[EAX + EAX*0x2]
00557dc7 MOV ECX,dword ptr [EAX*0x2 + 0xc05152]
00557dce FLD dword ptr [ECX + 0x6]
00557dd1 RET 0x4
