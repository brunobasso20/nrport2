005bd5e0 MOV EAX,dword ptr [ESP + 0x4]
005bd5e4 TEST EAX,EAX
005bd5e6 JZ 0x005bd60d
005bd5e8 MOV ECX,dword ptr [EAX*0x4 + 0xedf228]
005bd5ef DEC ECX
005bd5f0 MOV dword ptr [EAX*0x4 + 0xedf228],ECX
005bd5f7 JNS 0x005bd60d
005bd5f9 MOV ECX,dword ptr [0x00ebfc7c]
005bd5ff DEC ECX
005bd600 MOV dword ptr [0x00ebfc7c],ECX
005bd606 MOV dword ptr [ECX*0x4 + 0xebfc80],EAX
005bd60d RET
