005bd5a0 MOV ECX,dword ptr [ESP + 0x4]
005bd5a4 MOV EAX,dword ptr [ECX*0x4 + 0xedf228]
005bd5ab TEST EAX,EAX
005bd5ad JNZ 0x005bd5d5
005bd5af MOV EAX,[0x00ebfc7c]
005bd5b4 MOV EDX,dword ptr [EAX*0x4 + 0xebfc80]
005bd5bb INC EAX
005bd5bc MOV [0x00ebfc7c],EAX
005bd5c1 MOV EAX,EDX
005bd5c3 MOV dword ptr [ECX*0x4 + 0xedf228],EDX
005bd5ca MOV dword ptr [EAX*0x4 + 0xedf228],0x0
005bd5d5 RET
