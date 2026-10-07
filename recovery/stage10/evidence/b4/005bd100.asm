005bd100 CALL 0x005bd0d0
005bd105 MOV ECX,dword ptr [ESP + 0x4]
005bd109 MOV EDX,dword ptr [EAX]
005bd10b SHL ECX,0x2
005bd10e AND EDX,0x2
005bd111 AND ECX,0xfffffffc
005bd114 OR EDX,0x1
005bd117 XOR EDX,ECX
005bd119 MOV ECX,dword ptr [ESP + 0x8]
005bd11d TEST ECX,ECX
005bd11f MOV dword ptr [EAX],EDX
005bd121 MOV dword ptr [EAX + 0x4],ECX
005bd124 JZ 0x005bd129
005bd126 INC dword ptr [ECX + 0xc]
005bd129 MOV EDX,dword ptr [ESP + 0xc]
005bd12d TEST EDX,EDX
005bd12f MOV dword ptr [EAX + 0x8],EDX
005bd132 JZ 0x005bd13b
005bd134 CMP ECX,EDX
005bd136 JZ 0x005bd13b
005bd138 INC dword ptr [EDX + 0xc]
005bd13b MOV ECX,dword ptr [EAX]
005bd13d MOV dword ptr [EAX + 0xc],0x0
005bd144 AND ECX,0xfffffffd
005bd147 MOV dword ptr [EAX + 0x10],0x0
005bd14e MOV dword ptr [EAX],ECX
005bd150 RET
