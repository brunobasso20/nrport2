005bd450 MOV ECX,0xffffff80
005bd455 XOR EAX,EAX
005bd457 MOV dword ptr [0x00ebfc68],ECX
005bd45d MOV dword ptr [0x00ebfc6c],ECX
005bd463 MOV dword ptr [0x00ebfc70],ECX
005bd469 MOV dword ptr [0x00ebfc74],ECX
005bd46f MOV dword ptr [0x00ebfc78],ECX
005bd475 MOV dword ptr [EAX*0x4 + 0xebfc54],EAX
005bd47c INC EAX
005bd47d CMP EAX,0x5
005bd480 JL 0x005bd475
005bd482 MOV [0x00ec02c0],EAX
005bd487 RET
