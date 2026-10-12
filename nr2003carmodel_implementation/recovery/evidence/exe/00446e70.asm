00446e70 MOV EAX,ECX
00446e72 MOV ECX,dword ptr [ESP + 0x4]
00446e76 MOV DL,byte ptr [ECX]
00446e78 MOV byte ptr [EAX],DL
00446e7a MOV DL,byte ptr [ECX + 0x1]
00446e7d MOV byte ptr [EAX + 0x1],DL
00446e80 MOV DL,byte ptr [ECX + 0x2]
00446e83 MOV CL,byte ptr [ECX + 0x3]
00446e86 MOV byte ptr [EAX + 0x2],DL
00446e89 MOV byte ptr [EAX + 0x3],CL
00446e8c RET 0x4
