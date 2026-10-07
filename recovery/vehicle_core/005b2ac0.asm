005b2ac0 MOV ECX,dword ptr [ESP + 0x8]
005b2ac4 MOV EAX,dword ptr [ECX + 0x71]
005b2ac7 TEST EAX,EAX
005b2ac9 JZ 0x005b2adc
005b2acb MOV ECX,EAX
005b2acd MOV EAX,dword ptr [ECX + 0x71]
005b2ad0 TEST EAX,EAX
005b2ad2 JNZ 0x005b2acb
005b2ad4 MOV EAX,dword ptr [ESP + 0x4]
005b2ad8 MOV dword ptr [ECX + 0x71],EAX
005b2adb RET
005b2adc MOV EDX,dword ptr [ESP + 0x4]
005b2ae0 MOV dword ptr [ECX + 0x71],EDX
005b2ae3 RET
