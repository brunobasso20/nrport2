004c0e30 MOV EAX,dword ptr [ECX + 0x4]
004c0e33 DEC EAX
004c0e34 MOV dword ptr [ECX + 0x4],EAX
004c0e37 JNZ 0x004c0e3f
004c0e39 MOV EAX,dword ptr [ECX]
004c0e3b PUSH 0x1
004c0e3d CALL dword ptr [EAX]
004c0e3f RET
