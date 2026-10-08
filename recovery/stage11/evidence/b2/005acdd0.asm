005acdd0 PUSH 0xa
005acdd2 CALL 0x00501870
005acdd7 PUSH 0x10
005acdd9 CALL 0x00501a20
005acdde ADD ESP,0x8
005acde1 TEST EAX,EAX
005acde3 JZ 0x005acdff
005acde5 MOV ECX,dword ptr [ESP + 0x4]
005acde9 MOV EDX,dword ptr [ECX]
005acdeb MOV dword ptr [EAX],EDX
005acded MOV EDX,dword ptr [ECX + 0x4]
005acdf0 MOV dword ptr [EAX + 0x4],EDX
005acdf3 MOV EDX,dword ptr [ECX + 0x8]
005acdf6 MOV dword ptr [EAX + 0x8],EDX
005acdf9 MOV ECX,dword ptr [ECX + 0xc]
005acdfc MOV dword ptr [EAX + 0xc],ECX
005acdff JMP 0x00501a40
