004fabc0 MOV ECX,dword ptr [0x00bebe46]
004fabc6 TEST ECX,ECX
004fabc8 JZ 0x004fabe0
004fabca MOV EAX,dword ptr [ESP + 0x8]
004fabce MOV EDX,dword ptr [ESP + 0x4]
004fabd2 PUSH EAX
004fabd3 PUSH EDX
004fabd4 CALL 0x005cfeb8
004fabd9 NEG AL
004fabdb SBB EAX,EAX
004fabdd NEG EAX
004fabdf RET
004fabe0 XOR EAX,EAX
004fabe2 RET
