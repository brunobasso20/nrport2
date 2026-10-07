005bcd80 MOV EAX,[0x00ec3fbc]
005bcd85 MOV EDX,dword ptr [ESP + 0x4]
005bcd89 LEA ECX,[EAX*0x4 + 0xebbf60]
005bcd90 MOV dword ptr [EDX],ECX
005bcd92 MOV EAX,[0x00ec3fbc]
005bcd97 INC EAX
005bcd98 MOV [0x00ec3fbc],EAX
005bcd9d RET
