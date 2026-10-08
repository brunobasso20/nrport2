0054b3e0 MOV EAX,dword ptr [ESP + 0x4]
0054b3e4 PUSH ESI
0054b3e5 MOV EDX,ECX
0054b3e7 MOV ESI,dword ptr [EAX]
0054b3e9 MOV dword ptr [EDX],ESI
0054b3eb MOV ESI,dword ptr [EAX + 0x4]
0054b3ee MOV dword ptr [EDX + 0x4],ESI
0054b3f1 MOV ESI,dword ptr [EAX + 0x8]
0054b3f4 MOV dword ptr [EDX + 0x8],ESI
0054b3f7 MOV EAX,dword ptr [EAX + 0xc]
0054b3fa MOV dword ptr [EDX + 0xc],EAX
0054b3fd CALL 0x0054b410
0054b402 POP ESI
0054b403 RET 0x4
