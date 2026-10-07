005b5270 MOV dword ptr [ECX + 0x5],0x0
005b5277 MOV EAX,dword ptr [ECX + 0x9]
005b527a MOV dword ptr [ECX + 0x1],EAX
005b527d MOV EDX,dword ptr [ECX + 0x1]
005b5280 AND EDX,0x3ff
005b5286 MOV dword ptr [ECX + 0x1],EDX
005b5289 RET
