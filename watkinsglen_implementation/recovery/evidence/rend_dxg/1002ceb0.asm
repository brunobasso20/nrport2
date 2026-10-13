1002ceb0 MOV ECX,dword ptr [ECX + 0x5c]
1002ceb3 MOV EAX,dword ptr [ECX + 0x1c]
1002ceb6 LEA EDX,[EAX*0x8 + 0x0]
1002cebd SUB EDX,EAX
1002cebf LEA EAX,[ECX + EDX*0x4 + 0x24]
1002cec3 MOV DL,byte ptr [ESP + 0x10]
1002cec7 MOV byte ptr [EAX + 0x8],DL
1002ceca MOV EDX,dword ptr [ESP + 0xc]
1002cece MOV dword ptr [EAX],EDX
1002ced0 MOV EDX,dword ptr [ESP + 0x4]
1002ced4 MOV dword ptr [EAX + 0x4],0x2
1002cedb MOV byte ptr [EAX + 0x9],0x0
1002cedf MOV dword ptr [EAX + 0xc],EDX
1002cee2 MOV EDX,dword ptr [ESP + 0x8]
1002cee6 MOV dword ptr [EAX + 0x10],EDX
1002cee9 MOV EAX,dword ptr [ECX + 0x1c]
1002ceec INC EAX
1002ceed MOV dword ptr [ECX + 0x1c],EAX
1002cef0 MOV EAX,0x1
1002cef5 RET 0x10
